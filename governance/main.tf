terraform {
  required_version = "= 1.16.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.81.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id                 = var.subscription_id
  tenant_id                       = var.tenant_id
  resource_provider_registrations = "none"
}

data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag on resources"
}

resource "azurerm_resource_group_policy_assignment" "lesson" {
  name                 = var.name
  resource_group_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  policy_definition_id = data.azurerm_policy_definition.require_tag.id
  display_name         = "WS2 disposable tag-policy exercise"
  description          = "Dedicated lab scope only; observation first, no automatic remediation identity."
  enforce              = var.enforce
  parameters = jsonencode({
    tagName = { value = "ws2-policy-demo" }
  })

  lifecycle {
    precondition {
      condition     = var.dedicated_scope_confirmed
      error_message = "Confirm this existing RG is an approved dedicated lab scope; never apply this assignment to a shared RG."
    }
  }
}
