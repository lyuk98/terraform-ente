terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.10"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.21"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "b2" {}

provider "cloudflare" {}

provider "random" {}

provider "tailscale" {
  scopes = ["oauth_keys", "auth_keys"]
}

provider "vault" {}
