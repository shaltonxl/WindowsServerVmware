/*
Terraform Skript "password_generation"

benötigte Variablen:
- password_length
*/

# Generieren eines Passwortes
resource "random_password" "generated_password" {
  length = "${var.password_length}"
  special = true
  upper = true
  lower = true
  numeric = true
  override_special = "!#$%&-?"
}
