# These tests validate configuration only, not Azure Policy compliance or denial.
mock_provider "azurerm" {
  mock_data "azurerm_policy_definition" {
    defaults = {
      id = "/providers/Microsoft.Authorization/policyDefinitions/00000000-0000-0000-0000-000000000000"
    }
  }
}

variables {
  tenant_id                 = "00000000-0000-0000-0000-000000000000"
  subscription_id           = "00000000-0000-0000-0000-000000000000"
  resource_group_name       = "rg-policy-contract"
  name                      = "ws2-policy-contract"
  dedicated_scope_confirmed = true
}

run "observe_only_in_explicit_rg" {
  command = plan

  assert {
    condition     = azurerm_resource_group_policy_assignment.lesson.enforce == false
    error_message = "Observation must be the initial mode."
  }

  assert {
    condition     = endswith(azurerm_resource_group_policy_assignment.lesson.resource_group_id, "/resourceGroups/rg-policy-contract")
    error_message = "The assignment must remain at the declared lab RG."
  }
}

run "reject_unconfirmed_scope" {
  command = plan

  variables {
    dedicated_scope_confirmed = false
  }

  expect_failures = [azurerm_resource_group_policy_assignment.lesson]
}
