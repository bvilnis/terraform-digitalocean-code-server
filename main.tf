provider "digitalocean" {
  token = var.do_token
}

# Passwords
resource "random_password" "user" {
  length  = 16
  special = false
}

# Cookie string
resource "random_password" "cookie" {
  length  = 16
  special = false
}

# VPC
resource "digitalocean_vpc" "vpc" {
  name   = var.hostname
  region = var.region
}

# User data
data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    HOSTNAME             = "${var.hostname}",
    USERNAME             = "${var.username}",
    USERPASS             = "${random_password.user.result}",
    GITHUB_USER          = "${var.github_username}",
    DOMAIN               = "${var.domain_name}",
    OAUTH2_CLIENT_ID     = "${var.oauth2_client_id}",
    OAUTH2_CLIENT_SECRET = "${var.oauth2_client_secret}",
    OAUTH2_PROVIDER      = "${var.oauth2_provider}",
    EMAIL                = "${var.email_address}",
    COOKIE               = base64encode("${random_password.cookie.result}")
  }
}

# Droplet
resource "digitalocean_droplet" "droplet" {
  image              = "ubuntu-20-04-x64"
  name               = var.hostname
  region             = var.region
  size               = var.droplet_size
  backups            = true
  monitoring         = true
  private_networking = "true"
  vpc_uuid           = digitalocean_vpc.vpc.id
  user_data          = data.template_file.user_data.rendered
}

# Volume
resource "digitalocean_volume" "disk" {
  name                    = "${var.hostname}-home-volume"
  region                  = var.region
  size                    = var.storage_size
  initial_filesystem_type = "ext4"
  description             = "persistent storage for /home on ${var.hostname}"
}

resource "digitalocean_volume_attachment" "disk_attachment" {
  droplet_id = digitalocean_droplet.droplet.id
  volume_id  = digitalocean_volume.disk.id
}

# Floating IP
resource "digitalocean_floating_ip" "ip" {
  region = var.region
}

resource "digitalocean_floating_ip_assignment" "ip_assign" {
  ip_address = digitalocean_floating_ip.ip.ip_address
  droplet_id = digitalocean_droplet.droplet.id
}

# DNS
resource "digitalocean_domain" "entry" {
  name       = var.domain_name
  ip_address = digitalocean_floating_ip.ip.ip_address
}

# Firewall
resource "digitalocean_firewall" "firewall" {
  name = "${var.hostname}-firewall"

  droplet_ids = ["${digitalocean_droplet.droplet.id}"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Project
resource "digitalocean_project" "project" {
  name = var.hostname
  resources = [
    "do:domain:${digitalocean_domain.entry.id}",
    "do:droplet:${digitalocean_droplet.droplet.id}",
    "do:floatingip:${digitalocean_floating_ip.ip.ip_address}",
    "do:volume:${digitalocean_volume.disk.id}"
  ]
}
