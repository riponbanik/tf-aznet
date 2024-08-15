# External route table
resource "azurerm_route_table" "rtb-snet-ext" {
  name                          = "rtb-snet-ext"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  bgp_route_propagation_enabled = false

  route {
    name           = "route-snet-int"
    address_prefix = "10.1.2.0/24"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "route-snet-pl"
    address_prefix = "10.1.3.0/24"
    next_hop_type  = "None"
  }

  route {
    name           = "route-bastion"
    address_prefix = "10.1.4.0/24"
    next_hop_type  = "None"
  }

  route {
    name           = "route-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

}

resource "azurerm_subnet_route_table_association" "rtb-snet-ext-assoc" {
  subnet_id      = module.vnet.vnet_subnets_name_id["snet-ext"]
  route_table_id = azurerm_route_table.rtb-snet-ext.id
}

# Internal route table
resource "azurerm_route_table" "rtb-snet-int" {
  name                          = "rtb-snet-int"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  bgp_route_propagation_enabled = false

  route {
    name           = "route-snet-ext"
    address_prefix = "10.1.1.0/24"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "route-snet-pl"
    address_prefix = "10.1.3.0/24"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "route-bastion"
    address_prefix = "10.1.4.0/24"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "route-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

}

resource "azurerm_subnet_route_table_association" "rtb-snet-int-assoc" {
  subnet_id      = module.vnet.vnet_subnets_name_id["snet-int"]
  route_table_id = azurerm_route_table.rtb-snet-int.id
}

# Private Link route table
resource "azurerm_route_table" "rtb-snet-pl" {
  name                          = "rtb-snet-pl"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  bgp_route_propagation_enabled = false

  route {
    name           = "route-snet-int"
    address_prefix = "10.1.2.0/24"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "route-snet-ext"
    address_prefix = "10.1.1.0/24"
    next_hop_type  = "None"
  }

  route {
    name           = "route-bastion"
    address_prefix = "10.1.4.0/24"
    next_hop_type  = "None"
  }

  route {
    name           = "route-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "None"
  }

}

resource "azurerm_subnet_route_table_association" "rtb-snet-pl-assoc" {
  subnet_id      = module.vnet.vnet_subnets_name_id["snet-pl"]
  route_table_id = azurerm_route_table.rtb-snet-pl.id
}
