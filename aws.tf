# Query availability zones
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create a persistent disk for PostgreSQL storage
resource "aws_lightsail_disk" "postgresql" {
  name              = "ente-postgresql"
  size_in_gb        = 8
  availability_zone = aws_lightsail_instance.museum.availability_zone
}

# Add a public SSH key
resource "aws_lightsail_key_pair" "museum" {
  name = "museum-key-pair"
}

# Create a Lightsail instance
resource "aws_lightsail_instance" "museum" {
  name              = "museum"
  availability_zone = data.aws_availability_zones.available.names[0]
  blueprint_id      = "debian_12"
  bundle_id         = "small_3_0"
  key_pair_name     = aws_lightsail_key_pair.museum.name
  user_data         = "cp /home/admin/.ssh/authorized_keys /root/.ssh/authorized_keys"
}

# Attach disk to the instance
resource "aws_lightsail_disk_attachment" "ente_postgresql" {
  disk_name     = aws_lightsail_disk.postgresql.name
  instance_name = aws_lightsail_instance.museum.name
  disk_path     = "/dev/xvdf"

  # Recreate disk attachment upon replacement of either the instance or the disk
  lifecycle {
    replace_triggered_by = [
      aws_lightsail_instance.museum.created_at,
      aws_lightsail_disk.postgresql.created_at
    ]
  }

  # Mark disk attachment dependent on the instance and the disk
  depends_on = [
    aws_lightsail_instance.museum,
    aws_lightsail_disk.postgresql
  ]
}

# Open instance ports
resource "aws_lightsail_instance_public_ports" "museum" {
  instance_name = aws_lightsail_instance.museum.name

  # SSH
  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  # HTTPS
  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }

  # Tailscale
  port_info {
    protocol  = "udp"
    from_port = 41641
    to_port   = 41641
  }
}

# Encryption key for Museum
resource "random_bytes" "encryption_key" {
  length = 32
}

resource "random_bytes" "encryption_hash" {
  length = 64
}

# JWT secrets
resource "random_bytes" "jwt_secret" {
  length = 32
}

# Build the NixOS system configuration
module "nixos_system" {
  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = "github:lyuk98/nixos-config#nixosConfigurations.museum.config.system.build.toplevel"
}

# Build the NixOS partition layout
module "nixos_partitioner" {
  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = "github:lyuk98/nixos-config#nixosConfigurations.museum.config.system.build.diskoScript"
}

# Install NixOS to Lightsail instance
module "nixos_install" {
  source = "github.com/nix-community/nixos-anywhere//terraform/install"

  nixos_system      = module.nixos_system.result.out
  nixos_partitioner = module.nixos_partitioner.result.out

  target_host     = aws_lightsail_instance.museum.public_ip_address
  target_user     = aws_lightsail_instance.museum.username
  ssh_private_key = aws_lightsail_key_pair.museum.private_key

  instance_id = aws_lightsail_instance.museum.public_ip_address

  extra_files_script = "${path.module}/deploy-secrets.sh"
  extra_environment = {
    MODULE_PATH                   = path.module
    VAULT_ROLE_ID                 = vault_approle_auth_backend_role.museum.role_id
    VAULT_SECRET_ID               = vault_approle_auth_backend_role_secret_id.museum.secret_id
    TAILSCALE_OAUTH_CLIENT_ID     = tailscale_oauth_client.museum.id
    TAILSCALE_OAUTH_CLIENT_SECRET = tailscale_oauth_client.museum.key
  }
}
