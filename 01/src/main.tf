terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.126.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "yandex" {
  token     = var.yandex_cloud_token #секретные данные должны быть в сохранности!! Никогда не выкладывайте токен в публичный доступ.
  folder_id = "b1gngfs82v779s82s5lh"
  zone      = "ru-central1-a"

}
provider "docker" {
  host     = "ssh://netology@${yandex_compute_instance.docker.network_interface.0.nat_ip_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}
#однострочный комментарий


resource "yandex_compute_disk" "docker" {
  name     = "disk-docker"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd88m3uah9t47loeseir"
  size     = 50

  labels = {
    environment = "docker"
  }
}

resource "yandex_compute_instance" "docker" {
  name = "docker"
  zone = "ru-central1-a"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {

    disk_id = yandex_compute_disk.docker.id

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true

  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
resource "yandex_vpc_network" "default" {
  name = "default"

}
resource "yandex_vpc_subnet" "default" {
  name           = "default"
  v4_cidr_blocks = ["172.16.17.0/28"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
}
resource "random_password" "root_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}
resource "random_password" "mysql_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}
output "external_ip_address_docker" {
  value = yandex_compute_instance.docker.network_interface.0.nat_ip_address
}
resource "docker_image" "mysql" {
  name = "mysql:8"

}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql"
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_pass.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_pass.result}",
    #"MYSQL_ROOT_HOST=" % ""

  ]


  ports {
    internal = 3306
    external = 3306
  }
}
