# hokum83_infra
hokum83 Infra repository

# ДЗ-4

## Адреса ВМ
testapp_IP = 51.250.84.202
\
testapp_port = 9292
\
Созданы скрипты:
- install_mongodb.sh
- install_ruby.sh
- deploy.sh

### Доп. задание - создание startup script
**Как решить отдельным скриптом .sh и передачей его ВМ не понял и не нашел. Прошу пояснить.**
Задача выполнена через дополнительный файл cloud-config.yaml:
```
#cloud-config

users:
  - name:  yc-user
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDErYDY+AMTSeCOpu3kmU5mZYyu7XhcOZ8RuPXeWP2V4hSsfnNmtP4mkI45dpSySLPgwwItrp/HAXGP57dUeB47BZKp/L1Z/PW2ZY9KcA0u0NRgsB9GhfDpH7yTi4K9kSYgaNcobgT+ROMSfTci8pYVzFkfXUwjV5ktl3SOZJ1EdQGL2P8X11WXjKjwSO12mZikRdt0RdraGbdULDVZIOUm6/bUjJc+z32EPaWjnBIz6rmFEtKsr6kVTpNapmgKgUYmmjCadq/ytzNbtwNHzj41LqQqGrocjUzCGncXPz0ZrnG9z+vMvTqT0wM+9k/QWPhICVCU/Zmx+HMVV2eoI++zxhG/xLJ1nfczTplsWM41n849MEaSiSs+1EoZLWykhUEv83UBedgaxKDB/T1hZcnv93yZOw8hdVGEt7VBAkY35fit4eH6zoLEDYJ7Iiro00URqjT0fulm23Xs6gIzGXPQlyAEzA1vKhTsUu8Wv9mdRuBLCl1VQ4RR8reMAoVyXYM= appuser

runcmd:
  - sudo apt update
  - sudo apt install -y ruby-full ruby-bundler build-essential mongodb-server git
  - sudo systemctl enable mongodb
  - sudo systemctl start mongodb
  - mkdir /run/ruby-app
  - cd /run/ruby-app
  - git clone -b monolith https://github.com/express42/reddit.git
  - cd reddit && bundle install
  - puma -d

```
Команда создания инстанса:
```
yc compute instance create  \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1
  --metadata-from-file user-data=./cloud-config.yaml
```




# ДЗ-3

## Адреса ВМ
bastion_IP = 51.250.91.111
\
someinternalhost_IP = 10.128.0.6
\
### Доп. задание - Подключение через **ssh someinternalhost**
Создать файл .ssh/config со следующим содержимым:
```
Host bastion
    HostName 51.250.91.111
    User appuser
    IdentityFile ~/.ssh/appuser

Host someinternalhost
    HostName 10.128.0.6
    User appuser
    ProxyJump bastion
```
### Доп. задание - Подключение сертификата LetsEncrypt
Задать доменное имя сервера 51-250-91-111-sslip.ip в настройках pritunl в разделе Lets Encrypt Domain. \
Адрес - [https://51-250-91-111-sslip.ip/](https://51-250-91-111-sslip.ip/)
