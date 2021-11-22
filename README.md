
This is example of usage of the next terraform module https://github.com/vleskiv/terraform-vault-approle

## Pre requisites
### Vault
Run vault locally in development mode
```bash
docker run -e 'SKIP_SETCAP=true' -p 8080:8200 -d --name=dev-vault vault:1.8.3
docker logs dev-vault
export VAULT_TOKEN="s.xxxxxxxxxxxxxxxxxxx"
vault status
vault auth enable approle
export TF_VAR_vault_addr='http://localhost:8080'
```
### Kubernetes
Kubernetes config should be configured locally