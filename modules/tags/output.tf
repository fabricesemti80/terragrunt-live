output "tag_summary" {
  value = concat(
    formatlist("%s; %s",
      vsphere_tag_category.category.*.name,
      vsphere_tag.tag.*.name
    )
  )
}

output "vsphere_tag_id" {
  value       = vsphere_tag.tag.id
  description = "ID of the new tag"
}
output "vsphere_tag_category_id" {
  value       = vsphere_tag_category.category.id
  description = "ID of the new tag category"
}
