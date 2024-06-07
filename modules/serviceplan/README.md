# Service Plans

This submodule demonstates how to manage service plans

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.61 |

## Resources

| Name | Type |
|------|------|
| [azurerm_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | default azure region yo be used | `string` | `null` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | used for naming purposes | `map(string)` | `{}` | no |
| <a name="input_plans"></a> [plans](#input\_plans) | contains all service plan config | `any` | n/a | yes |
| <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup) | default resource group to be used | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be added to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_plans"></a> [plans](#output\_plans) | contains the service plans |
