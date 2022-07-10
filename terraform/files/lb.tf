resource "yandex_compute_instance" "lb" {
  name = "reddit-lb"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma-servers"
    destination = "/tmp/puma-servers"
  }

  provisioner "file" {
    source      = "files/puma.conf"
    destination = "/tmp/puma.conf"
  }

  provisioner "remote-exec" {
    script = "files/deploy_lb.sh"
  }
  provisioner "local-exec" {
    command = "rm -f files/puma-servers"
  }
  depends_on = [yandex_compute_instance.app]
}
