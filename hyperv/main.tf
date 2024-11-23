#TF file used with create_vm.ps1 on HyperV.  Passes either the create or destroy action to the create_vm.ps1 script.
provider "local" {}

resource "null_resource" "ubuntu_amx_vm" {
  # Provisioner to create the VM
  provisioner "local-exec" {
    command = "PowerShell -File D:\\Terraform_create_VM\\create_vm.ps1 -action create"
    when    = "create"
  }

  # Provisioner to destroy the VM
  provisioner "local-exec" {
    command = "PowerShell -File D:\\Terraform_create_VM\\create_vm.ps1 -action destroy"
    when    = "destroy"
  }
}