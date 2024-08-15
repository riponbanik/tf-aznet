# NSG External
module "nsg-snet-ext" {
  source                = "Azure/network-security-group/azurerm"
  version               = "4.1.0"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  security_group_name   = "nsg-snet-ext"
  use_for_each          = true
  source_address_prefix = ["0.0.0.0/0"]
  predefined_rules = [
    {
      name     = "HTTP"
      priority = "100"
    },
    {
      name     = "HTTPS"
      priority = "101"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-snet-ext-assoc" {
  subnet_id                 = module.vnet.vnet_subnets_name_id["snet-ext"]
  network_security_group_id = module.nsg-snet-ext.network_security_group_id
}

# NSG Internal
module "nsg-snet-int" {
  source              = "Azure/network-security-group/azurerm"
  version             = "4.1.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_group_name = "nsg-snet-int"

  custom_rules = [
    {
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "10.1.4.0/24"
      description            = "allow-bastion-ssh"
    },
    {
      name                    = "myrdp"
      priority                = 200
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      destination_port_range  = "3389"
      source_address_prefixes = ["10.1.4.0/24"]
      description             = "allow-bastion-rdp"
    },
  ]

  use_for_each = true

}

resource "azurerm_subnet_network_security_group_association" "nsg-snet-int-assoc" {
  subnet_id                 = module.vnet.vnet_subnets_name_id["snet-int"]
  network_security_group_id = module.nsg-snet-int.network_security_group_id
}

# NSG Private Link
module "nsg-snet-pl" {
  source                = "Azure/network-security-group/azurerm"
  version               = "4.1.0"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  security_group_name   = "nsg-snet-pl"
  use_for_each          = true
  source_address_prefix = ["10.1.2.0/24"]
  predefined_rules = [
    {
      name     = "HTTPS"
      priority = "101"
    }
  ]
  custom_rules = [
    {
      name                   = "DenyVnetInBound"
      priority               = 102
      direction              = "Inbound"
      access                 = "Deny"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "*"
      source_address_prefix  = "10.1.0.0/16"
      description            = "Deny default access from VirtualNetwork"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-snet-pl-assoc" {
  subnet_id                 = module.vnet.vnet_subnets_name_id["snet-pl"]
  network_security_group_id = module.nsg-snet-pl.network_security_group_id
}
