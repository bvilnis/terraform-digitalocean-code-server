variable "do_token" {
  type        = string
  description = "Digital Ocean API token."
}

variable "domain_name" {
  type        = string
  description = "A record value for your Digital Ocean managed domain (eg. 'mydomain.com' or 'subdomain.mydomain.com')."
}

variable "droplet_size" {
  type        = string
  description = "Digital Ocean droplet size."
  default     = "s-2vcpu-2gb"
}

variable "email_address" {
  type        = string
  description = "If set, OAuth2 Proxy will only authenticate supplied email address rather than entire org/account of the Oauth2 provider."
  default     = ""
}

variable "github_username" {
  type        = string
  description = "GitHub username for importing public SSH keys associated to the GitHub account."
}

variable "hostname" {
  type        = string
  description = "Hostname for the EC2 instance."
  default     = "code-server"
}

variable "oauth2_client_id" {
  type        = string
  description = "OAuth2 client ID key for chosen OAuth2 provider."
}

variable "oauth2_client_secret" {
  type        = string
  description = "OAuth2 client secret key for chosen OAuth2 provider."
}

variable "oauth2_provider" {
  type        = string
  description = "OAuth2 provider."
}

variable "region" {
  type        = string
  description = "Digital Ocean regional endpoint."
  default     = "sfo2"
}

variable "storage_size" {
  type        = number
  description = "Size (in GB) for immutable volume mounted to `/home`."
  default     = 20
}

variable "username" {
  type        = string
  description = "Username for the non-root user on the droplet."
  default     = "coder"
}
