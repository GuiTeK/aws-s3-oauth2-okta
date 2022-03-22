resource "random_password" "jwt_secret" {
  length = 64

  upper   = true
  lower   = true
  number  = true
  special = true
}
