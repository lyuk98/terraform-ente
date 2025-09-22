# Get Cloudflare Zone information
data "cloudflare_zone" "ente" {
  zone_id = var.cloudflare_zone_id
}

# A record for Ente accounts
resource "cloudflare_dns_record" "accounts" {
  name    = "ente-accounts"
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.public_ip_address
  proxied = true
}

# A record for Ente cast
resource "cloudflare_dns_record" "cast" {
  name    = "ente-cast"
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.public_ip_address
  proxied = true
}

# A record for Ente albums
resource "cloudflare_dns_record" "albums" {
  name    = "ente-albums"
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.public_ip_address
  proxied = true
}

# A record for Ente photos
resource "cloudflare_dns_record" "photos" {
  name    = "ente-photos"
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.public_ip_address
  proxied = true
}

# A record for Ente API (Museum)
resource "cloudflare_dns_record" "api" {
  name    = "ente-api"
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.public_ip_address
  proxied = true
}

# AAAA record for Ente accounts
resource "cloudflare_dns_record" "accounts_aaaa" {
  name    = "ente-accounts"
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.ipv6_addresses[0]
  proxied = true
}

# AAAA record for Ente cast
resource "cloudflare_dns_record" "cast_aaaa" {
  name    = "ente-cast"
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.ipv6_addresses[0]
  proxied = true
}

# AAAA record for Ente albums
resource "cloudflare_dns_record" "albums_aaaa" {
  name    = "ente-albums"
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.ipv6_addresses[0]
  proxied = true
}

# AAAA record for Ente photos
resource "cloudflare_dns_record" "photos_aaaa" {
  name    = "ente-photos"
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.ipv6_addresses[0]
  proxied = true
}

# AAAA record for Ente API (Museum)
resource "cloudflare_dns_record" "api_aaaa" {
  name    = "ente-api"
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.ente.zone_id
  content = aws_lightsail_instance.museum.ipv6_addresses[0]
  proxied = true
}
