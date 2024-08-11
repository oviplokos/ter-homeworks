variable "disk_storage" {
  type = object({
    name  = string
    type  = string
    zone  = string
    size  = number
    count = number
  })
  default = {
    name  = "disk"
    type  = "network-hdd"
    zone  = "ru-central1-a"
    size  = 1
    count = 3
  }
}
variable "vm_storage" {
  type = object({
    name          = string
    platform_id   = string
    cores         = string
    memory        = string
    core_fraction = string
    hdd_size      = string
    hdd_type      = string
    family        = string
    nat           = bool
    zone          = string

  })

  default = {
    name          = "storage-vm"
    platform_id   = "standard-v1"
    cores         = 2
    memory        = 1
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    family        = "ubuntu-2004-lts"
    nat           = false
    zone          = "ru-central1-a"

  }
}

resource "yandex_compute_disk" "storage" {
  count = var.disk_storage.count
  name  = "${var.disk_storage.name}-${count.index + 1}"
  type  = var.disk_storage.type
  zone  = var.disk_storage.zone
  size  = var.disk_storage.size

}

resource "yandex_compute_instance" "storage" {
  name        = var.vm_storage.name
  platform_id = var.vm_storage.platform_id
  zone        = var.vm_storage.zone
  resources {
    cores         = var.vm_storage.cores
    memory        = var.vm_storage.memory
    core_fraction = var.vm_storage.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage
    content {
      disk_id = lookup(secondary_disk.value, "id", null)
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_storage.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

}
