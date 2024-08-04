resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vm_web_vpc_name
  zone           = var.vm_web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_web_cidr
  route_table_id = yandex_vpc_route_table.outdoor_a.id
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_cidr
  route_table_id = yandex_vpc_route_table.outdoor_b.id
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = local.web_name
  platform_id = var.vm_web_platform
  zone        = var.vm_web_zone
  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadata.metadata_web.serial-port-enable
    ssh-keys           = "${var.vm_web_ssh_user}:${var.metadata.metadata_web.ssh-keys}"
  }

}

resource "yandex_compute_instance" "platform_db" {
  name        = local.db_name
  platform_id = var.vm_db_platform
  zone        = var.vm_db_zone
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadata.metadata_db.serial-port-enable
    ssh-keys           = "${var.vm_web_ssh_user}:${var.metadata.metadata_db.ssh-keys}"
  }

}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id = var.folder_id
  name      = "gateway"
  shared_egress_gateway {}
}
resource "yandex_vpc_route_table" "outdoor_a" {
  folder_id  = var.folder_id
  name       = "segment-a"
  network_id = yandex_vpc_network.develop.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
resource "yandex_vpc_route_table" "outdoor_b" {
  folder_id  = var.folder_id
  name       = "segment-b"
  network_id = yandex_vpc_network.develop.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }

}
