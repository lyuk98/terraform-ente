# Write secret containing connection details
resource "vault_kv_secret" "museum" {
  path = "kv/ente/aws/museum"
  data_json = jsonencode({
    key = {
      encryption = random_bytes.encryption_key.base64
      hash       = random_bytes.encryption_hash.base64
    }
    jwt = {
      secret = random_bytes.jwt_secret.base64
    }
  })
}

# Write application key to Vault
resource "vault_kv_secret" "application_key" {
  path = "kv/ente/b2/ente-b2"
  data_json = jsonencode({
    key      = b2_application_key.ente.application_key_id
    secret   = b2_application_key.ente.application_key
    endpoint = data.b2_account_info.account.s3_api_url
    region   = "us-west-002"
    bucket   = b2_bucket.ente.bucket_name
  })
}

# Prepare policy document
data "vault_policy_document" "museum" {
  rule {
    path         = vault_kv_secret.museum.path
    capabilities = ["read"]
    description  = "Allow access to credentials for Museum"
  }
  rule {
    path         = vault_kv_secret.application_key.path
    capabilities = ["read"]
    description  = "Allow access to secrets for object storage"
  }
  rule {
    path         = "kv/ente/cloudflare/certificate"
    capabilities = ["read"]
    description  = "Allow access to TLS certificate data"
  }
}

# Write policy allowing Museum to read secrets
resource "vault_policy" "museum" {
  name   = "museum"
  policy = data.vault_policy_document.museum.hcl
}

# Mount AppRole auth backend
data "vault_auth_backend" "approle" {
  path = "approle"
}

# Create an AppRole for Museum to retrieve secrets with
resource "vault_approle_auth_backend_role" "museum" {
  backend        = data.vault_auth_backend.approle.path
  role_name      = "museum"
  token_policies = [vault_policy.museum.name]
}

# Create a SecretID for the Vault AppRole
resource "vault_approle_auth_backend_role_secret_id" "museum" {
  backend   = vault_approle_auth_backend_role.museum.backend
  role_name = vault_approle_auth_backend_role.museum.role_name
}
