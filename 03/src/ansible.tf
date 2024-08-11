resource "local_file" "inventory" {
  content  = <<-EOT
[webservers]
%{for i in yandex_compute_instance.web~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}  fqdn=${i["fqdn"]}
%{endfor~}

[databases]
%{for i in yandex_compute_instance.db~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}  fqdn=${i["fqdn"]}
%{endfor~}

[storage]
%{for i in [yandex_compute_instance.storage]~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}  fqdn=${i["fqdn"]}
%{endfor~}

  EOT
  filename = "${abspath(path.module)}/inventory.ini"
}

resource "local_file" "inventory_dinamic_ip" {
  content = templatefile("${path.module}/ansible.tftpl",
    {
      instances = {
        webservers = yandex_compute_instance.web,
        databases  = yandex_compute_instance.db,
        storage    = [yandex_compute_instance.storage]
      }
  })

  filename = "${abspath(path.module)}/inventory_ip.ini"
}


resource "random_password" "each" {
  for_each = toset([for k, v in yandex_compute_instance.web : v.name])
  length   = 17
}

resource "null_resource" "web_hosts_provision" {
  depends_on = [local_file.inventory_dinamic_ip]

  provisioner "local-exec" {
    command = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/inventory_ip.ini ${abspath(path.module)}/test.yml --extra-vars '{\"secrets\": ${jsonencode({ for k, v in random_password.each : k => v.result })} }'"

    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }

  triggers = {
    playbook_src_hash = file("${abspath(path.module)}/test.yml")                         # change test.yml
    template_rendered = "${local_file.inventory_dinamic_ip.content}"                     #change ansible.tftpl  
    password_change   = jsonencode({ for k, v in random_password.each : k => v.result }) #change password
  }
}
