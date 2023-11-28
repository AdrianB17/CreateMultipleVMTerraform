resource "random_integer" "random1" {
  min = 100
  max = 999
}
resource "random_string" "random2" {
  length  = 32
  upper   = false
  numeric  = true
  special = false  
}

resource "azurerm_network_interface" "example" {
  count               = length(var.subnet_names_create)
  name                = "${lower(var.vm_names_create[count.index])}${random_integer.random1.result}_z2"
  location            = data.azurerm_resource_group.existing_resource_group.location
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = values(data.azurerm_subnet.subnets)[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
  enable_accelerated_networking = false
}

resource "azurerm_virtual_machine" "vms" {
  count               = length(var.existing_images)
  name                = var.vm_names_create[count.index]
  location            = data.azurerm_resource_group.existing_resource_group.location
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name

  network_interface_ids = [azurerm_network_interface.example[count.index].id]
  
  vm_size              = "Standard_B4ms"  # Generalizar, hay otro Standard_D4s_v3

  zones = ["2"]

  storage_image_reference {
    id = data.azurerm_image.existing_images[count.index].id
  }

  storage_os_disk {
    name              = "${var.vm_names_create[count.index]}_disk1_${random_string.random2.result}"
    caching           = "ReadWrite"
    create_option     = "FromImage"  #Attach or FromImage
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name  = var.vm_names_create[count.index]
    admin_username = "administrador"
    admin_password = "tecno09logia2019*"  # Reemplaza esto con tu contraseña
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }
  
  tags = {
    Ticket    = "WO0000008838313"
    COD_APP   = "INCT"
    Template  = "TPL004"
  }

}
