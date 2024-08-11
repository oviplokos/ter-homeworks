variable "each_vm" {
  type = list(object({
    name          = string,
    platform_id   = string,
    cores         = string,
    memory        = string,
    core_fraction = string,
    hdd_size      = string,
    hdd_type      = string,
    family        = string,
    nat           = bool,
    }
    )
  )
  default = [
    {
      name          = "main",
      platform_id   = "standard-v1",
      cores         = 4,
      memory        = 4,
      core_fraction = 20,
      hdd_size      = 20,
      hdd_type      = "network-hdd",
      family        = "ubuntu-2004-lts",
      nat           = true,
    },
    {
      name          = "replica",
      platform_id   = "standard-v1",
      cores         = 2,
      memory        = 2,
      core_fraction = 5,
      hdd_size      = 10,
      hdd_type      = "network-hdd",
      family        = "ubuntu-2004-lts",
      nat           = true,
    }
  ]
}

resource "yandex_compute_instance" "db" {
  for_each                  = { for vm in var.each_vm : vm.name => vm }
  name                      = each.value.name
  allow_stopping_for_update = var.vm_allow_stopping_for_update

  platform_id = each.value.platform_id

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = each.value.hdd_type
      size     = each.value.hdd_size
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }


  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = each.value.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

}
