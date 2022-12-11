resource "azurerm_storage_account" "terraform-storage-account" {
  name                     = "mahmutterrafomstorage"
  resource_group_name      = azurerm_resource_group.terraformrgname1.name
  location                 = azurerm_resource_group.terraformrgname1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}