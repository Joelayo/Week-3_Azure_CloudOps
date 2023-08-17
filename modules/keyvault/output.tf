# This output block exports the secret identifier of the key vault certificate.
output "kv_secret_identifier" {
    value = azurerm_key_vault_certificate.kv_certificate.secret_id
}

# This output block exports the ID of the user-assigned managed identity.
output "user_assigned_identity_id" {
    value = azurerm_user_assigned_identity.base.id
}