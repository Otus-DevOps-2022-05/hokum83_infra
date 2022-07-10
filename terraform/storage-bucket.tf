terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "your-bucket-name"
    region                      = "you-region"
    key                         = "your-path/file-name.state"
    access_key                  = "your-access-key"
    secret_key                  = "your-secret-key"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
