# =============================================================================
# RESOURCES
# =============================================================================

# Create the Azure Virtual Network.
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Create the Azure subnets.
resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_definitions

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}

# Create the Azure Network Security Groups.
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Associate Network Security Groups with subnets.
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = var.subnet_definitions

  subnet_id = azurerm_subnet.subnets[each.key].id

  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}