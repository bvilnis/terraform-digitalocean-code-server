output "domain_name" {
  value       = digitalocean_domain.entry.id
  description = "The domain name record."
}

output "droplet_id" {
  value       = digitalocean_droplet.droplet.id
  description = "The Droplet ID."
}

output "droplet_private_ip" {
  value       = digitalocean_droplet.droplet.ipv4_address_private
  description = "The Droplet private IP address."
}

output "droplet_public_ip" {
  value       = digitalocean_floating_ip.ip.ip_address
  description = "The Droplet public IP address."
}

output "firewall_id" {
  value       = digitalocean_firewall.firewall.id
  description = "The firewall ID."
}

output "volume_id" {
  value       = digitalocean_volume.disk.id
  description = "The volume ID for the immutable disk mounted to `/home`."
}

output "vpc_id" {
  value       = digitalocean_vpc.vpc.id
  description = "The VPC ID."
}
