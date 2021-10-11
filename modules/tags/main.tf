resource "vsphere_tag_category" "category" {
  name        = var.deploy_vsphere_tag_category
  cardinality = "SINGLE"
  description = var.deploy_vsphere_tag_decription #"managed by Terraform"
  associable_types = [
    "VirtualMachine"
  ]
}
resource "vsphere_tag" "tag" {
  name        = var.deploy_vsphere_tag
  category_id = vsphere_tag_category.category.id
  description = var.deploy_vsphere_tag_decription # "managed by Terraform"
  depends_on  = [vsphere_tag_category.category]
}
