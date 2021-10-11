variable "deploy_vsphere_datastore" {
  description = "The target datastore to deploy the into"
}
variable "deploy_vsphere_datacenter" {
  description = "The target datastore to deploy the VM into"
}
variable "template_vm" {
  description = "The template VM that serves as the template"
}
variable "deploy_vsphere_network" {
  description = "The target network to deploy the VM into"
}
variable "deploy_vsphere_cluster" {
  description = "The target cluser to deploy the VM into"
}
variable "instance_count" {
  description = "How many VM we want"
}
variable "vm_name_prefix" {
  description = "Enter the name prefix of the VM(s). (Eg. to create Server001, Server002, enter 'Server00'):"
}
variable "previous_server_index" {
  description = "Enter the PREVIOUS number that you want the VM numbers start from. (Eg. to create Server002, Server003, enter '2'): "
}
variable "vm_folder" {
  description = "The target folder to deploy the VM into"
}
variable "guest_vcpu" {
  description = "Number of vCPU cores for the new VM"
}
variable "guest_memory" {
  description = "Memore for the new VM (in MB)"
}
# variable "domain_ad" {
#   description = "Active Driectory domain to join the macine into. (Valid options currently: westcoast.co.uk & xma.co.uk)"
# }
variable "guest_local_admin_username" {
  description = "Windows domain administrator username for the VM-s domain"
}
variable "guest_local_admin_password" {
  sensitive = true
}
# variable "network_selector" {
#   description = "This helps selecting from the available networks listed in the 'network-setup' block "
# }
variable "network-setup" {
  # source: https://stackoverflow.com/questions/68528209/terraform-switch
  default = {
    # default for BN
    "SVWPserver00" = {
            "ip_network_prefix"  = "10.171.16."
      "ip_network_gateway" = "10.171.16.1"
      "ip_netmask"         = "24" # "The IPv4 subnet mask, in bits (example: 24 for 255.255.255.0)."
      # "deploy_vsphere_network" = "SVWTserver01"
    }
    # default for AL
    "SVWTserver01" = {
      "ip_network_prefix"  = "10.172.17."
      "ip_network_gateway" = "10.172.17.1"
      "ip_netmask"         = "24" # "The IPv4 subnet mask, in bits (example: 24 for 255.255.255.0)."
      # "deploy_vsphere_network" = "SVWPserver00"
    }
    # AL-XMA
    "ANDCserver06" = {
      "ip_network_prefix"  = "10.163.22."
      "ip_network_gateway" = "10.163.22.1"
      "ip_netmask"         = "24" # "The IPv4 subnet mask, in bits (example: 24 for 255.255.255.0)."
      # "deploy_vsphere_network" = "ANDCserver06"
    }
  }
}
variable "domain_selector" {
  description = "This helps selecting from the available domains listed in the 'domain-setup' block"
}
variable "domain-setup" {
  # source: https://stackoverflow.com/questions/68528209/terraform-switch
  default = {
    "WC" = {
      guest_domain      = "westcoast.co.uk"
      guest_dns_servers = ["10.171.16.11", "10.171.16.12"]
    },
    "XMA" = {
      guest_domain      = "xma.co.uk"
      guest_dns_servers = ["10.171.22.11", "10.171.22.12"]
    },
  }
}
variable "hardware_version" {
  default     = 15
  description = "Desired VM hardware version, defaults to 15"
}
variable "domain_logon" {
  description = "Domain admin account for Active Directory joining"
}
variable "domain_password" {
  description = "Domain admin password for Active Directory joining"
}
variable "ip_first_address" {
  description = "Enter the first (or only) IP that want to use. Make sure there is enough free IP following this for all servers!:"
}
variable "tag_id" {
  description = "ID of the new tag"
}
