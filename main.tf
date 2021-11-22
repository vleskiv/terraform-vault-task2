terraform {
  required_version = ">= 0.14"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
    vault = {
      source = "hashicorp/vault"
      version = "~> 2.8.0"
    }
  }
}

#-------------------------------
# Providers
#-------------------------------
// Hook-up kubectl Provider for Terraform
provider "kubernetes" {
  load_config_file       = true
}

provider "vault" {
  address = var.vault_addr
}

locals {
  // base prefix for resources
  base_name    = "mySuperApp"
}

#-------------------------------
# Module
#-------------------------------
module "approle" {
  source = "github.com/vleskiv/terraform-vault-approle.git"

  role_name   = "${local.base_name}-role"
  policy_name = "${local.base_name}-policy"
  policy      = <<EOT
  path "secret/data/mySuperApp" {
    capabilities = ["read","list","update"]
  }
  EOT

  create_secret_id = false
  template_path   = "templates/secret-value.json.tpl"
  vault_addr = var.vault_addr
}