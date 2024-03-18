#! /bin/bash/

# Check if terraform.tfstate file exists
if [ -e "./terraform.tfstate" ]; then
    echo "Terraform state file exists. Continuing..."
else
    # Initialisieren von Terraform mit Updates
    terraform init -upgrade
fi
# Prüfen der Terraform Skripte mit einer Planerstellung
terraform plan -out plan.out
# Ausführen des Plans
terraform apply plan.out
