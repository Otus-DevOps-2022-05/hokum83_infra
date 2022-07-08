output "external_ip_address_app" {
  value = join(" ", yandex_compute_instance.app[*].network_interface.0.nat_ip_address)
}

output "external_ip_address_lb" {
  value = yandex_compute_instance.lb.network_interface.0.nat_ip_address
}
