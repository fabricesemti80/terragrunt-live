locals {
  time = timestamp()
}
data "vsphere_datacenter" "target_datacenter" {
  name = var.deploy_vsphere_datacenter
}
data "vsphere_datastore" "target_datastore" {
  name          = var.deploy_vsphere_datastore
  datacenter_id = data.vsphere_datacenter.target_datacenter.id
}
data "vsphere_virtual_machine" "template_vm" {
  name          = var.template_vm
  datacenter_id = data.vsphere_datacenter.target_datacenter.id
}
data "vsphere_network" "target_network" {
  name          = var.deploy_vsphere_network
  datacenter_id = data.vsphere_datacenter.target_datacenter.id
}
data "vsphere_compute_cluster" "target_cluster" {
  name          = var.deploy_vsphere_cluster
  datacenter_id = data.vsphere_datacenter.target_datacenter.id
}
resource "vsphere_virtual_machine" "cloned_virtual_machine" {
  count            = var.instance_count
  name             = "${var.vm_name_prefix}${count.index + 1 + var.previous_server_index}"
  resource_pool_id = data.vsphere_compute_cluster.target_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.target_datastore.id
  folder           = var.vm_folder
  num_cpus         = var.guest_vcpu
  memory           = var.guest_memory
  guest_id         = data.vsphere_virtual_machine.template_vm.guest_id
  annotation       = "Deployed at ${local.time} using Terraform. Please contact Fabrice Semti <fabrice.semti@westcoast.co.uk> before modifying this resource! "
  scsi_type        = data.vsphere_virtual_machine.template_vm.scsi_type
  firmware         = data.vsphere_virtual_machine.template_vm.firmware
  network_interface {
    network_id   = data.vsphere_network.target_network.id
    adapter_type = data.vsphere_virtual_machine.template_vm.network_interface_types[0]
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_vm.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template_vm.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_vm.disks[0].thin_provisioned
  }
  #tags = [vsphere_tag.tag.id] # COMMENT THIS LINE TO OMIT TAG/CATEGORY
  tags = [var.tag_id]
  clone {
    template_uuid = data.vsphere_virtual_machine.template_vm.id
    customize {
      windows_options {
        computer_name         = "${var.vm_name_prefix}${count.index + 1 + var.previous_server_index}"
        join_domain           = var.domain-setup[var.domain_selector].guest_domain
        domain_admin_user     = var.domain_logon
        domain_admin_password = var.domain_password
        admin_password        = var.guest_local_admin_password
        auto_logon            = true
        auto_logon_count      = 1
        run_once_command_list = [
          # * set up WinRM
          "winrm set winrm/config @{MaxEnvelopeSizekb=\"100000\"}",
          "winrm set winrm/config/Service @{AllowUnencrypted=\"true\"}",
          "winrm set winrm/config/Service/Auth @{Basic=\"true\"}",
          "Start-Service WinRM",
          "Set-service WinRM -StartupType Automatic",
          # * turn on firewall
          "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled true",
          # * enable MSTSC
          "Set-ItemProperty -Path 'HKLM:/System/CurrentControlSet/Control/Terminal Server' -name 'fDenyTSConnections' -Value 0",
          "netsh advfirewall firewall add rule name='allow RemoteDesktop' dir=in protocol=TCP localport=3389 action=allow"
        ]
      }
      network_interface {
        ipv4_address = "${var.network-setup[var.deploy_vsphere_network].ip_network_prefix}${var.ip_first_address + count.index}"
        ipv4_netmask = var.network-setup[var.deploy_vsphere_network].ip_netmask
      }
      # * changeme -> 
      ipv4_gateway    = var.network-setup[var.deploy_vsphere_network].ip_network_gateway
      dns_server_list = var.domain-setup[var.domain_selector].guest_dns_servers
    }
  }
  hardware_version = var.hardware_version
  lifecycle {
    ignore_changes = [
      tags, annotation, folder, disk
    ]
  }
}
