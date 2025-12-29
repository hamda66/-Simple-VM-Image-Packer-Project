packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "2.3.3"
    }
  }
}


variable "client_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

source "azure-arm" "test-image"{
 use_azure_cli_auth = true
  subscription_id = "6221f3bf-b411-4b86-a1a2-5ffdd5f36cd9"
  client_id     = var.client_id
  tenant_id     = var.tenant_id

  location            = "uksouth"
  managed_image_resource_group_name = "demo"
  managed_image_name = "hamda-image"

  vm_size             = "Standard_D4lds_v6" 
  os_type             = "Linux"
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-jammy"
  image_sku           = "22_04-LTS-gen2"
  public_ip_sku       = "Standard"

}

build{
    sources = ["source.azure-arm.test-image"]

    provisioner "shell" {
        inline = [
            "echo Hamdaaa > /tmp/hamda.txt",
            "cat /tmp/hamda.txt"
        ]
    }

    provisioner "shell" {
      execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
      inline = [
        "sudo apt update",
        "sudo apt -y install nmap",
        "nmap --version"
      ]
      inline_shebang = "/bin/sh -x"
    }

  
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}