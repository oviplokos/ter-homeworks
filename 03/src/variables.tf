###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "public_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcg3/z8meFK2AboLbtx4HNRh2euj/mx01qMY6EziHlM netology@netology-VirtualBox"
  description = "ssh-keygen -t ed25519"
}


variable "vms_resources" {
  type = map(object({
    platform_id   = string
    cores         = string
    memory        = string
    core_fraction = string
    hdd_size      = string
    hdd_type      = string
    family        = string
    nat           = bool
    count         = number

  }))
  default = {
    web = {
      platform_id   = "standard-v1"
      cores         = 2
      memory        = 1
      core_fraction = 5
      hdd_size      = 10
      hdd_type      = "network-hdd"
      family        = "ubuntu-2004-lts"
      nat           = true
      count         = 2

    },

  }
  description = "map variable vms resources"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "family name"
}



variable "vm_allow_stopping_for_update" {
  type        = bool
  description = "Is it allowed to stop a VM instance to make changes"
  default     = true
}

