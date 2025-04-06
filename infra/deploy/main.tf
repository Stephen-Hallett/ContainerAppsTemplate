data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "azurerm_resource_group" "rg" {
  name = "rg-${var.project_id}-${var.env}-eau-001"
}

resource "azurerm_container_app_environment" "cae" {
  name                = "cae-${var.project_id}-${var.env}-eau-001"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "backend" {
  name                         = "ca-${var.project_id}-${var.env}-eau-backend"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  secret {
    name  = "ghcr-token"
    value = var.ghcr-token
  }

  ingress {
    external_enabled           = false
    allow_insecure_connections = false
    target_port                = 8000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "backend"
      image  = "ghcr.io/<USER>/backend:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  registry {
    server               = "ghcr.io"
    username             = "<USER>"
    password_secret_name = "ghcr-token"
  }
}

resource "azurerm_container_app" "frontend" {
  depends_on                   = [azurerm_container_app.backend]
  name                         = "ca-${var.project_id}-${var.env}-eau-frontend"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  secret {
    name  = "ghcr-token"
    value = var.ghcr-token
  }


  ingress {
    external_enabled = true
    target_port      = 6969
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }


  template {
    container {
      name   = "frontend"
      image  = "ghcr.io/<USER>/frontend:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "BACKEND_ENDPOINT"
        value = "https://${azurerm_container_app.backend.name}.internal.${azurerm_container_app_environment.cae.default_domain}"
      }
    }
  }

  registry {
    server               = "ghcr.io"
    username             = "<USER>"
    password_secret_name = "ghcr-token"
  }

}
