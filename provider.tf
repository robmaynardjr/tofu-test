terraform {
    required_providers {
        azurerm = {
            source  = "r-t-m/azurerm"
            version = "3.39.1"
        }
    }
}

provider "azurerm" {
    features {}
    subscription_id = "51c7239f-55d9-49c2-8878-d9ac2918dc68"
    client_id = "f08630de-a906-4485-8487-4e38240ca663"
    client_secret = var.ARM_CLIENT_SECRET
    tenant_id = "5a2ec06b-b05e-4d96-affa-afc83b2a4629"
}