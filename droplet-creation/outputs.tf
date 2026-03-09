output "droplet_ipv4_address" {
  description = "The public IP address of your Droplet"
  value       = digitalocean_droplet.web_server.ipv4_address
}
