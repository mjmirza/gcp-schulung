variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where the VM will be deployed."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where the VM will be deployed."
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "The name of the VM instance."
  type        = string
}

variable "machine_type" {
  description = "The type of machine to use for the VM."
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_size" {
  description = "The size of the boot disk in GB."
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "The type of the boot disk."
  type        = string
  default     = "pd-standard"
}

variable "network" {
  description = "The name of the VPC network to attach the VM to."
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach the VM to."
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account to use for the VM."
  type        = string
}

variable "tags" {
  description = "A list of tags to apply to the VM."
  type        = list(string)
  default     = []
}

variable "startup_script" {
  description = "The startup script to run on VM initialization."
  type        = string
}