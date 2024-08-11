data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources.web.family
}

resource "yandex_compute_instance" "web" {

  count      = var.vms_resources.web.count
  depends_on = [yandex_compute_instance.db]

  name        = "web-${count.index + 1}"
  platform_id = var.vms_resources.web.platform_id

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.vms_resources.web.hdd_type
      size     = var.vms_resources.web.hdd_size
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }


  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vms_resources.web.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

}
