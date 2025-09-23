# Terraform configurations

This repository contains Terraform configurations for deploying self-hosted Ente.

## Cloud providers used

### Amazon Web Services ([`aws.tf`](./aws.tf))

- Amazon Lightsail
	- An instance (`aws_lightsail_instance`)
	- A storage disk for persistent data (`aws_lightsail_disk`)
	- Attachment of the disk to the instance (`aws_lightsail_disk_attachment`)
- Museum's [encryption keys](https://help.ente.io/self-hosting/installation/config#encryption-keys "Configuration - Self-hosting | Ente Help") and [JWT secret](https://help.ente.io/self-hosting/installation/config#jwt "Configuration - Self-hosting | Ente Help") (`random_bytes`)
- Installation of NixOS (with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere/ "nix-community/nixos-anywhere: Install NixOS everywhere via SSH"))
	- NixOS system configuration (`nixos_system`)
	- Partition layout configuration (`nixos_partitioner`)
	- NixOS installer (`nixos_install`)

### Backblaze B2 ([`b2.tf`](./b2.tf))

- A bucket (`b2_bucket`)
- An application key to access the bucket (`b2_application_key`)

### Cloudflare ([`cloudflare.tf`](./cloudflare.tf))

- `A` and `AAAA` records for accessing the service (`cloudflare_dns_record`)

### Tailscale ([`tailscale.tf`](./tailscale.tf))

- OAuth client (`tailscale_oauth_client`)

### Vault ([`vault.tf`](./vault.tf))

- KV-V1 secrets for Museum (`vault_kv_secret`)
- Policy for Museum (`vault_policy`)
- AppRole for Museum (`vault_approle_auth_backend_role` and `vault_approle_auth_backend_role_secret_id`)
