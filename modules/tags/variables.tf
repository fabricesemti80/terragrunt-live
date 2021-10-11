variable "deploy_vsphere_tag_category" {
  description = "Tag category used by Terraform"
}
variable "deploy_vsphere_tag" {
  description = "Tag used by terraform"
}
variable "deploy_vsphere_tag_decription" {
  description = "Description for the tag and for the  category"
  default     = "managed by Terraform"
}
