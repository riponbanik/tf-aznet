# Random id
resource "random_id" "ri" {
  byte_length = 8
}

resource "random_string" "random" {
  length  = 4
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-test${lower(random_id.ri.id)}"
  location = "Australia East"
}



