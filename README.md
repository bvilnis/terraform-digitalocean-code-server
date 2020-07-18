# Digital Ocean Code Server Terraform module

Terraform module which creates an OAuth2-authenticated [Code Server](https://github.com/cdr/code-server) on Digital Ocean.

## Usage

```hcl
//--------------------------------------------------------------------
// Variables
variable "oauth2_client_id" {}
variable "oauth2_client_secret" {}

//--------------------------------------------------------------------
// Modules
module "code-server" {
  source  = "bvilnis/code-server/digitalocean"
  version = "0.1.0"

  domain_name          = "ide.mydomain.com"
  github_username      = "bvilnis"
  oauth2_client_id     = var.oauth2_client_id
  oauth2_client_secret = var.oauth2_client_secret
  oauth2_provider      = "google"
}
```

```
terraform apply \
-var="do_token=<digitalocean_api_token>" \
-var="oauth2_client_id=<client_id>" \
-var="oauth2_client_secret=<client_secret>"
```

## Notes

* The `oauth_client_id` and `oauth_client_secret` variables should not be defined in code as they are considered sensitive values. When used with with CLI, set them as [variables on the command line](https://www.terraform.io/docs/configuration/variables.html#variables-on-the-command-line), as outlined above. When used in [Terraform Cloud](https://www.terraform.io/), set them as [sensitive variables](https://www.terraform.io/docs/cloud/workspaces/variables.html#sensitive-values).
* The sudo password for your created user can be found at `/home/$USER/sudo.txt`. It is recommended you run `passwd` to change your password and then delete this file.
* User data on droplets can take several minutes to execute and complete. Allow enough time for the droplet to launch and execute the commands in [user_data.tpl](user_data.tpl).

## Examples

* [Complete](examples/complete/README.md)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

* [OAuth2 client ID and secret](https://oauth2-proxy.github.io/oauth2-proxy/auth-configuration) from your chosen provider.
* A valid domain name [managed on Digital Ocean](https://www.digitalocean.com/docs/networking/dns/).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| do_token | Digital Ocean API token. | `string` | n/a | yes |
| domain_name | A record value for your Digital Ocean managed domain (eg. 'mydomain.com' or 'subdomain.mydomain.com'). | `string` | n/a | yes |
| droplet_size | Digital Ocean droplet size. | `string` | `""` | no |
| email_address | If set, OAuth2 Proxy will only authenticate supplied email address rather than entire org/account of the OAuth2 provider. | `string` | `"s-2vcpu-2gb"` | no |
| github_username | GitHub username for importing public SSH keys associated to the GitHub account. | `string` | n/a | yes |
| hostname | Hostname for the droplet. | `string` | `"code-server"` | no |
| oauth2_client_id | OAuth2 client ID key for your chosen OAuth2 provider. | `string` | n/a | yes |
| oauth2_client_secret | OAuth2 client secret key for your chosen OAuth2 provider. | `string` | n/a | yes |
| oauth2_provider | Your chosen OAuth2 provider. | `string` | n/a | yes |
| region | Digital Ocean regional endpoint. | `string` | `"us-east-1"` | no |
| storage_size | Size (in GB) for immutable volume mounted to `/home`. | `number` | `20` | no |
| username | Username for the non-root user on the droplet. | `string` | `"coder"` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain_name | The domain name record. |
| droplet_id | The droplet ID. |
| droplet_private_ip | The droplet private IP address. |
| droplet_public_ip | The droplet public IP address. |
| firewall_id | The firewall ID. |
| volume_id | The volume ID for the immutable disk mounted to `/home`. |
| vpc_id | The VPC ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Ben Vilnis](https://github.com/bvilnis).

## License

Apache 2 Licensed. See LICENSE for full details.
