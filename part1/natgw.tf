# Public IP
resource "azurerm_public_ip" "nat_pip" {
  name                = "natgw-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


# Nat Gateway
resource "azurerm_nat_gateway" "natgw" {
  name                    = "natgw-test${lower(random_id.ri.id)}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

}

# Nat Gateway public ip
resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_subnet_assoc" {
  nat_gateway_id = azurerm_nat_gateway.natgw.id
  subnet_id      = module.vnet.vnet_subnets_name_id["snet-int"]
}
