resource "random_password" "db_password" {
  length           = 32
  min_lower        = 1
  min_numeric      = 1
  min_upper        = 1
  min_special      = 1
  override_special = "_%!"
}

output "password" {
  value = nonsensitive(random_password.db_password.result)
}