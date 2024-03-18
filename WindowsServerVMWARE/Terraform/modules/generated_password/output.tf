# Ausgabe des Passwortes
output "secure_password" {
  description = "Generiert ein Passsword."
  value       = "${random_password.generated_password.result}"
}
