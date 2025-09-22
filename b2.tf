# Get account information
data "b2_account_info" "account" {}

# Add random suffix to bucket name
resource "random_bytes" "bucket_suffix" {
  length = 4
}

# Add bucket for photo storage
resource "b2_bucket" "ente" {
  bucket_name = sensitive("ente-${random_bytes.bucket_suffix.hex}")
  bucket_type = "allPrivate"

  cors_rules {
    allowed_operations = [
      "s3_head",
      "s3_put",
      "s3_delete",
      "s3_post",
      "s3_get"
    ]
    allowed_origins = ["*"]
    cors_rule_name  = "ente-cors-rule"
    max_age_seconds = 3000
    allowed_headers = ["*"]
    expose_headers  = ["Etag"]
  }
}

# Create application key for accessing the bucket
resource "b2_application_key" "ente" {
  capabilities = [
    "bypassGovernance",
    "deleteFiles",
    "listFiles",
    "readFiles",
    "shareFiles",
    "writeFileLegalHolds",
    "writeFileRetentions",
    "writeFiles"
  ]
  key_name  = "ente"
  bucket_id = b2_bucket.ente.bucket_id
}
