output "external_ip_address_platform_web" {
  value       = yandex_compute_instance.platform.network_interface.0.nat_ip_address
  description = "platform external ip"
}
output "external_ip_address_platform_db" {
  value       = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
  description = "platform db external ip"
}
output "fqdn_platform_web" {
  value       = yandex_compute_instance.platform.fqdn
  description = "platform fqdn"
}
output "fqdn_platform_db" {
  value       = yandex_compute_instance.platform_db.fqdn
  description = "platform db fqdn"
}
output "instance_name_platform_web" {
  value       = yandex_compute_instance.platform.name
  description = "platform instance name"
}
output "instance_name_platform_db" {
  value       = yandex_compute_instance.platform_db.name
  description = "platform db instance name"
}
