

terraform {
  # https://terragrunt.gruntwork.io/docs/reference/built-in-functions/#get_terragrunt_dir
  source = "${get_terragrunt_dir()}/../../modules/tags"
}

include {
  # https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/
  path = find_in_parent_folders("common.hcl")
}

inputs = {
  deploy_vsphere_tag_category   = "DEV-CATEGORY-Terraform"
  deploy_vsphere_tag            = "DEVELOPMENT-Terraform"
  deploy_vsphere_tag_decription = "DEVELOPMENT infrastructure managed by Terraform (for any changes on this resource, please contact fabrice.semti@westcoast.co.uk first!)"
}
