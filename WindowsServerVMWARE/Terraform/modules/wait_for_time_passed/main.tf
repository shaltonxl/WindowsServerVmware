/*
Terraform Skript "wait_for_time_passed"
*/

# Festlegen der kommenden Wartezeit
resource "null_resource" "wait_for_time_passed" {
    triggers = {start = timestamp()}
    provisioner "local-exec" {
        command = "sleep 600"    
    } 
}
