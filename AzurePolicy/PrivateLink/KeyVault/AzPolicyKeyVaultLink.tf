resource "azurerm_policy_definition" "keyvaultprivatelink" {
  name         = "${var.prefix}KeyVault-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "${var.prefix}Audit KeyVault for Private Link usage"

  metadata     = <<METADATA
    {
    "category": "${var.category}"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.KeyVault/vaults"
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.KeyVault/vaults/privateEndpointConnections",
          "existenceCondition": {
            "field": "Microsoft.KeyVault/vaults/privateEndpointConnections/privateLinkServiceConnectionState.status",
            "equals": "Approved"
          }
        }
      }
    }
POLICY_RULE

  parameters = <<PARAMETERS
    {
		"effect":{
			"type": "String",
			"metadata":{
				"displayName": "Effect",
				"description": "Enable or disable the execution of the policy"
			},
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "defaultValue": "AuditIfNotExists"
      }
		}
PARAMETERS
}