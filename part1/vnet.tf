# vnet
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.1.0"
  vnet_name           = "vnet-test${lower(random_id.ri.id)}"
  vnet_location       = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
  subnet_prefixes     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  subnet_names        = ["snet-ext", "snet-int", "snet-pl", "AzureBastionSubnet"]

  #   subnet_service_endpoints = {
  #     "subnet1" : ["Microsoft.Sql", "Microsoft.KeyVault"],
  #     "subnet2" : ["Microsoft.Sql", "Microsoft.KeyVault"],
  #     "subnet3" : ["Microsoft.Sql", "Microsoft.KeyVault"]
  #   }

  subnet_service_endpoints = {
    "snet-ext" : ["Microsoft.KeyVault"]
  }
  use_for_each = true
}

data "azurerm_subnet" "snets" {
  for_each             = module.vnet.vnet_subnets_name_id
  name                 = each.key
  virtual_network_name = module.vnet.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  depends_on           = [module.vnet]
}
