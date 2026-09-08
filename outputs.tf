# TODO: return the real NSG and association IDs.
output "nsg_id" {
  description = "Managed NSG ID."
  value       = null
}

output "association_ids" {
  description = "Association IDs keyed by subnet name."
  value       = {}
}
