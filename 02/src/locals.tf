
locals {
  web_name = "${var.vm_web_family}-${var.vm_web_name}"
  db_name  = "${var.vm_db_family}-${var.vm_db_name}"
}

