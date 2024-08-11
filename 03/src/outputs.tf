output "vm_list" {
  value = flatten([
    for instances in [yandex_compute_instance.web, yandex_compute_instance.db] : [
      for i in instances : {
        instance_name = i.name,
        id            = i.id,
        fqdn          = i.fqdn
      }
    ]
  ])

}
