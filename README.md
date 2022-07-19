# hokum83_infra
hokum83 Infra repository

# ДЗ-8
Что сделано:
- Поднято окружение stage через terraform
- создан файл inventory в формате ini выполнена проверка работы ping через ansible
- выполнены настройки файла ansible.cfg, файл inventory зачищен от избыточных параметров
- хосты сгруппированы в файле inventory по назначению, выполнена проверка через пинг группы хостов
- создан файл inventory в формате yaml, проверена работа
- выполнена проверка работы модулей command, shell, bash: проверена установка необходимых компонентов, выполнено клонирование приложения через модуль git
- написан плейбук для клонирования приложения на апп сервер
- создан скрипт yc-inventory.sh на bash для формирования динамического инвентори в формате json. Информация берется через yc compute, затем парсится утилитой jq (требуется дополнительно установить из репозитария дистрибутива, я использовал версию 1.6). Задавать любые необходимые группы для инвентори можно через массив types в скрипте. Так же предусмотрены варианты когда массив пустой (делается вывод всех хостов), либо существуют хосты, которые не входят в группы - в этом случае эти хосты попадают в корневой справочник hosts (ungrouped в статическом варианте). Проверена работа скрипта через запуск модуля ping как всех хостов (all), так и отдельных групп и хостов
 - ansible.cfg перенастроен на использование инвентори с помощью скрипта yc-inventory.sh


# ДЗ-7
Что сделано:
- создана сеть через terraform, определена неявная зависимость от нее при создании вм приложения
- блоки создания вм приложения и бд, а так же блок создания сети вынесены в отдельные файлы
- блоки создания вм вынесены в модули
- созданы отдельные папки для создания окружений prod и stage с ссылками на созданные модули
- удалены не нужные файлы в корневой директории проекта, выполнено форматирование
- настроен бэкенд для хранения конфиграции состояния в s3 (backend.tf.example в папках stage и prod)
- папка stage была задублирована, выполнено одновременный запуск развертывания окружения stage из разных мест - блокировка отработала корректно
- в модули добавлены провиженоры для развертывания приложения и передачи переменной окружения DATABASE_URL на сервер приложений, настроены зависимости модуля развертывания сервера приложений от модуля сервера бд


# ДЗ-6
Что сделано:
- создана сервисная УЗ и ключ для подключения из terraform в YC
- подготовлен проект развертывания вм в YC с помощью terraform
- настроены провиженеры для запуска приложения puma в вм
- некоторые входные параметры вынесены в файл переменных (примеры в terraform/terraform.tfvars.example)
- опеределена переменная для приватного ключа и зоны, выполнено форматирование через terrafirm ftm
- создан файл для создания образа вм балансировщика lb.tf, настроена автоматизация установки необходимого ПО и передача в вм конфигурции nginx
- изменена конфигурация main.tf для развертывания нескольких серверов приложений через параметр count

# ДЗ-5
Что сделано:
- настроены билдеры для файла создания образа packer в yc packer/ubuntu16.json
- настроены провиженеры для файла создания образа packer в yc packer/ubuntu16.json (2 скрипта установки монго и руби)
- некоторые параметры вынесены в файл переменных (примеры в packer/files/variables.json.examples)
- создан скрипт установки всех зависимостей, приложения и запуска приложения через юнит systemd - packer/scripts/prepare.sh
- создан файл для создания образа со всеми зависимостями и установленным приложением - packer/immutable.json
- создан скрипт развертывания вм из созданного пакером образа - config-scripts/create-reddit-vm.sh
- выполнено тестовое развертывание образа и вм на его основе

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

Как решить отдельным скриптом .sh и передачей его ВМ не понял и не нашел. Прошу пояснить.


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
