# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-lab-tf-we"
    storage_account_name = "terraformlab001"
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 0.15.0"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "my-rsg" {
  name     = var.resource_group_name
  location = var.location
   
}


resource "azurerm_virtual_network" "this" {
  name                = "vnet-eja-ta-we-001"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.my-rsg.location
  resource_group_name = azurerm_resource_group.my-rsg.name
}

resource "azurerm_storage_account" "storage" {
  name                     = var.my_storage_account
  resource_group_name      = var.resource_group_name
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}


resource "azurerm_storage_container" "this" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"
}