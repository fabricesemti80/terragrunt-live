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
#TODO: create dev tag
dependency "dev_tag" {
  # https://itnext.io/terragrunt-inter-module-dependency-management-36528693acdf
  config_path = "${get_terragrunt_dir()}/../dev_tags"
  mock_outputs = {
    vsphere_tag_id = "999" #! mock ID is needed for planning before the actual deployment
  }
}
# locals {
#   # flexible number of data disks for VM
#   disks = [
#     { "id" : 1, "dev" : "sdb", "sizeGB" : 10 },
#     { "id" : 2, "dev" : "sdc", "sizeGB" : 20 }
#   ]
# }
inputs = {
  tag_id                    = dependency.dev_tag.outputs.vsphere_tag_id
  deploy_vsphere_datastore  = "AL001-Local-DataStore01"
  deploy_vsphere_datacenter = "ALW"
  template_vm               = "alw_2019_gui"
  deploy_vsphere_network    = "ANDCserver06"
  deploy_vsphere_cluster    = "ALWCLESX001"
  instance_count            = 1
  vm_name_prefix            = "Server0"
  previous_server_index     = 0
  vm_folder                 = "AL-Local-VMs"
  guest_vcpu                = 2
  guest_memory              = 4096
  ip_first_address          = 200
  domain_selector           = "XMA"
  #? DO NOT REMOVE THE FOLLOWING BLOCK. 
  #? UNCOMMENT, IF YOU NEED TO ADD 1 / MORE DATA DISKS WITH THE VM
  #? THE EXAMPLE BLOCK ADDS TWO DISKS TO THE VM, WITH UNIT NUMBER 1 & 2, 11 GB AND 22 GB
  disk_size = [
     {
      size   = 11,
      number = 1
    }
    ,
     {
      size   = 22,
      number = 2
    }
  ]
  #?
}
