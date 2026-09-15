variable "tenant_id" {
  type        = string
  description = "Your approved tenant GUID; supplied privately."
}

variable "subscription_id" {
  type        = string
  description = "Your approved subscription GUID; supplied privately."
}

variable "resource_group_name" {
  type        = string
  description = "Existing dedicated lab RG, not a shared subscription or management group."
}

variable "name" {
  type        = string
  description = "Unique lab-owned policy assignment name."

  validation {
    condition     = can(regex("^ws2-policy-[a-z0-9][a-z0-9-]{1,25}$", var.name))
    error_message = "Use a unique ws2-policy- assignment name."
  }
}

variable "dedicated_scope_confirmed" {
  type        = bool
  description = "Explicit scope acknowledgement; does not grant permissions or authorize deployment."
  default     = false
}

variable "enforce" {
  type        = bool
  description = "Default false observes compliance only; true is a separately approved denial experiment."
  default     = false
}
