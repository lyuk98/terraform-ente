variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Zone ID for Cloudflare domain"
  sensitive   = true
}
