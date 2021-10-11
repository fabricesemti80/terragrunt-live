output "vm_summary" {
  value = concat(
    formatlist(
      "%s: %s",
      vsphere_virtual_machine.cloned_virtual_machine.*.name,
      vsphere_virtual_machine.cloned_virtual_machine.*.clone.0.customize.0.network_interface.0.ipv4_address
    )
  )
}
