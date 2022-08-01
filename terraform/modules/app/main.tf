resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  labels = {
    tags = "app"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  depends_on = [var.db_ip_address]

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }


#  provisioner "file" {
#    source      = "../modules/app/puma.service"
#    destination = "/tmp/puma.service"
#  }
#  provisioner "file" {
#    source      = "../modules/app/deploy.sh"
#    destination = "/tmp/deploy.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo sh -c \"echo 'export DATABASE_URL=${var.db_ip_address}:27017' >> /etc/profile\"",
#      "bash /tmp/deploy.sh",
#    ]
#  }
}
