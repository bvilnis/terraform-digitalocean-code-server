## Complete example

```hcl
module "code-server" {
  source  = "bvilnis/code-server/digitalocean"
  version = "0.1.0"

  domain_name          = "ide.mydomain.com"
  droplet_size         = "s-2vcpu-2gb"
  email_address        = "email@mydomain.com"
  github_username      = "bvilnis"
  hostname             = "code-server"
  oauth2_client_id     = var.oauth2_client_id
  oauth2_client_secret = var.oauth2_client_secret
  oauth2_provider      = "google"
  region               = "sfo2"
  storage_size         = 20
  username             = "coder"
}
```

```
terraform apply \
-var="do_token=<digitalocean_api_token>" \
-var="oauth2_client_id=<client_id>" \
-var="oauth2_client_secret=<client_secret>"
```