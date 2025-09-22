# Create a Tailscale OAuth client
resource "tailscale_oauth_client" "museum" {
  description = "museum"
  scopes      = ["auth_keys"]
  tags        = ["tag:museum", "tag:webserver"]
}
