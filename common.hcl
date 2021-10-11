generate "provider" {
  # https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user                 = var.provider_vsphere_username
  password             = var.provider_vsphere_password
  vsphere_server       = var.provider_vsphere_host
  allow_unverified_ssl = true
}
EOF
}

generate "provider-var" {
  # https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/
  path      = "provider_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "provider_vsphere_host" {
  description = "vCenter server FQDN or IP"
}
variable "provider_vsphere_password" {
  sensitive = true
}
variable "provider_vsphere_username" {
}
EOF
}

terraform {
  extra_arguments "common_vars" {
    # https://terragrunt.gruntwork.io/docs/reference/built-in-functions/
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars"
    ]
  }
}
