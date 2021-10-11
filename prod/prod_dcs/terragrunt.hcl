terraform {
  # https://terragrunt.gruntwork.io/docs/reference/built-in-functions/#get_terragrunt_dir
  source = "${get_terragrunt_dir()}/../../modules/cluster_vm"
  extra_arguments "common_vars" {
    # https://terragrunt.gruntwork.io/docs/reference/built-in-functions/
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars",
      "-var-file=${get_terragrunt_dir()}/dcs.tfvars"
    ]
  }
}
include {
  # https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/
  path = find_in_parent_folders("common.hcl")
}
dependency "prod_tag" {
  # https://itnext.io/terragrunt-inter-module-dependency-management-36528693acdf
  config_path = "${get_terragrunt_dir()}/../prod_tags"
  mock_outputs = {
    vsphere_tag_id = "999" #! mock ID is needed for planning before the actual deployment
  }
}
inputs = {
  tag_id                    = dependency.prod_tag.outputs.vsphere_tag_id
  deploy_vsphere_datastore  = "AL001-Local-DataStore01"
  deploy_vsphere_datacenter = "ALW"
  template_vm               = "alw_2019_gui"
  deploy_vsphere_network    = "ANDCserver06"
  deploy_vsphere_cluster    = "ALWCLESX001"
  instance_count            = 2
  vm_name_prefix            = "ANXDC00"
  previous_server_index     = 0
  vm_folder                 = "AL-Local-VMs"
  guest_vcpu                = 4
  guest_memory              = 8196
  ip_first_address          = 11
  domain_selector           = "XMA"
}
