variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}


variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}
variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
  default     = "eastus"
}
variable "k8s_cluster" {
  description = "Azure sK8S Cluser name"
  type        = string
}
variable "dns_prefix" {
  description = "Azure sdns prefix name"
  type        = string
}
variable "vm_size" {
  description = "Azure VM Size"
  type        = string
}

