provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "fluxcd-poc-rg"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "fluxcd-poc-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "fluxcdpoc"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B1s" # Free tier VM
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    environment = "poc"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}