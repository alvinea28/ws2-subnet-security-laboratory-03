module "security" {
  source = "../.."

  name                = "ws2-security"
  resource_group_name = "rg-ws2-existing"
  location            = "southeastasia"
  subnet_ids = {
    web  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ws2-existing/providers/Microsoft.Network/virtualNetworks/ws2-network/subnets/web"
    data = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ws2-existing/providers/Microsoft.Network/virtualNetworks/ws2-network/subnets/data"
  }
  tags = {
    owner       = "team"
    environment = "dev"
    cost_center = "training"
    workshop    = "ws2"
  }
  rules = {}
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
