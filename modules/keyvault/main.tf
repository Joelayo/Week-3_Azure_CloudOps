# This data block retrieves the current Azure client configuration.
data "azurerm_client_config" "current" {}

# This resource block creates a user-assigned identity for the key vault.
resource "azurerm_user_assigned_identity" "base" {
    resource_group_name = var.resource_group_name
    location            = var.location
    name                = "mi-appgw-keyvault"
}

# This resource block creates an Azure Key Vault with access policies for certificates, keys, and secrets.
resource "azurerm_key_vault" "kv" {
    name                  = var.kv_name
    location              = var.location
    resource_group_name   = var.resource_group_name
    tenant_id             = data.azurerm_client_config.current.tenant_id
    sku_name              = "standard"

    # Define the access policies for the key vault
    access_policy {
        object_id    = data.azurerm_client_config.current.object_id
        tenant_id    = data.azurerm_client_config.current.tenant_id

        # Define the certificate permissions for the access policy
        certificate_permissions = [
            "Create",
            "Delete",
            "DeleteIssuers",
            "Get",
            "GetIssuers",
            "Import",
            "List",
            "ListIssuers",
            "ManageContacts",
            "ManageIssuers",
            "Purge",
            "SetIssuers",
            "Update"
        ]

        # Define the key permissions for the access policy
        key_permissions = [
            "Backup",
            "Create",
            "Decrypt",
            "Delete",
            "Encrypt",
            "Get",
            "Import",
            "List",
            "Purge",
            "Recover",
            "Restore",
            "Sign",
            "UnwrapKey",
            "Update",
            "Verify",
            "WrapKey"
        ]

        # Define the secret permissions for the access policy
        secret_permissions = [
            "Backup",
            "Delete",
            "Get",
            "List",
            "Purge",
            "Restore",
            "Restore",
            "Set"
        ]
    }

    # Define a second access policy for the user-assigned identity
    access_policy {
        object_id    = azurerm_user_assigned_identity.base.principal_id
        tenant_id    = data.azurerm_client_config.current.tenant_id

        # Define the secret permissions for the user-assigned identity access policy
        secret_permissions = [
            "Get"
        ]
    }
}

# This resource block creates a certificate in the key vault.
resource "azurerm_key_vault_certificate" "kv_certificate" {
    name         = "generated-cert"
    key_vault_id = azurerm_key_vault.kv.id

    # Define the certificate policy for the certificate
    certificate_policy {
        issuer_parameters {
            name = "Self"
        }

        key_properties {
            exportable = true
            key_size   = 2048
            key_type   = "RSA"
            reuse_key  = true
        }

        lifetime_action {
            action {
                action_type = "AutoRenew"
            }

            trigger {
                days_before_expiry = 30
            }
        }

        secret_properties {
            content_type = "application/x-pkcs12"
        }

        x509_certificate_properties {
            # Define the extended key usage for the certificate
            # Server Authentication = 1.3.6.1.5.5.7.3.1
            # Client Authentication = 1.3.6.1.5.5.7.3.2
            extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

            # Define the key usage for the certificate
            key_usage = [
                "cRLSign",
                "dataEncipherment",
                "digitalSignature",
                "keyAgreement",
                "keyCertSign",
                "keyEncipherment",
            ]

            # Define the subject alternative names for the certificate
            subject_alternative_names {
                dns_names = ["internal.contoso.com", "domain.hello.world"]
            }

            # Define the subject and validity period for the certificate
            subject            = "CN=hello-world"
            validity_in_months = 12
        }
    }
}