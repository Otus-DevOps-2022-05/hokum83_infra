# hokum83_infra
hokum83 Infra repository

# ДЗ-3

## Адреса ВМ
bastion_IP = 51.250.91.111 \
someinternalhost_IP = 10.128.0.6

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
