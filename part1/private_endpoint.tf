
# private dns zone
resource "azurerm_private_dns_zone" "private_dns_zone_st" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# private dns zone virtual link
resource "azurerm_private_dns_zone_virtual_network_link" "vlink-storage" {
  name                  = "vlink-storage"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_st.name
  virtual_network_id    = module.vnet.vnet_id
}

# create storage account with blob storage
resource "azurerm_storage_account" "storage_account" {
  name                            = "st${lower(random_string.random.id)}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
}

# private endpoint
resource "azurerm_private_endpoint" "pe_storage_account" {
  name                = "pe-st${lower(random_string.random.id)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet.vnet_subnets_name_id["snet-pl"]

  private_service_connection {
    name                           = "st-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "st-endpoint-connection"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_st.id]
  }

  depends_on = [
    azurerm_storage_account.storage_account
  ]
}


