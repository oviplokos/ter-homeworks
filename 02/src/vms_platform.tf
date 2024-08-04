variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "family name"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "vm name"
}
variable "vm_web_platform" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}
# variable "vm_web_core" {
#   type        = string
#   default     = "2"
#   description = "core count"
# }
# variable "vm_web_memory" {
#   type        = string
#   default     = "1"
#   description = "nenory count"
# }
# variable "vm_web_core_fraction" {
#   type        = string
#   default     = "5"
#   description = "fraction %"
# }
variable "vm_web_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "ssh user"
}
variable "vm_web_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "zone web"
}
variable "vm_web_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "cidr web servers"
}
variable "vm_web_vpc_name" {
  type        = string
  default     = "develop-web"
  description = "VPC network & subnet name"
}

#vm_db_  vars

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "family name"
}
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "vm name"
}
variable "vm_db_platform" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}
# variable "vm_db_core" {
#   type        = string
#   default     = "2"
#   description = "core count"
# }
# variable "vm_db_memory" {
#   type        = string
#   default     = "2"
#   description = "memory count"
# }
# variable "vm_db_core_fraction" {
#   type        = string
#   default     = "20"
#   description = "fraction %"
# }
variable "vm_db_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "ssh user"
}
variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "zone db"
}
variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "cidr db"
}
variable "vm_db_vpc_name" {
  type        = string
  default     = "develop-db"
  description = "VPC network & subnet name"
}


variable "vms_resources" {
  type = map(object({
    cores         = string
    memory        = string
    core_fraction = string
    hdd_size      = string
    hdd_type      = string
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
      hdd_size      = 10
      hdd_type      = "network-hdd"
    },
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 10
      hdd_type      = "network-ssd"

    }
  }
  description = "map variable vms resources"
}

variable "metadata" {
  type = map(
    object({
      serial-port-enable = string
      ssh-keys           = string
    })
  )
  default = {
    metadata_web = {
      serial-port-enable = 1
      ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcg3/z8meFK2AboLbtx4HNRh2euj/mx01qMY6EziHlM netology@netology-VirtualBox"
    }
    metadata_db = {
      serial-port-enable = 1
      ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcg3/z8meFK2AboLbtx4HNRh2euj/mx01qMY6EziHlM netology@netology-VirtualBox"
    }
  }

}
variable "test" {
  type = list(map(list(string)))
  default = [
    {
      "dev1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
        "10.0.1.7",
      ]
    },
    {
      "dev2" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
        "10.0.2.29",
      ]
    },
    {
      "prod1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
        "10.0.1.30",
      ]
    },
  ]

}
