# https://github.com/mspnp/template-building-blocks/wiki/VNet-(v1)
# https://github.com/mspnp/template-building-blocks/wiki/DMZ-(v1)
# Deploying the DMZ building block requires a VNet deployment
# This includes the Vnet-n-subnet scenario using building blocks 
# template to fill this requirement and demonstrate how to also use it.
# Notice all URI's point to my github repro, the mspp v1 repro is not working.


$rg = New-AzureRmResourceGroup -Location westus2 -Name bc-dev-rg
# Create new resource group variable in my selected region (westus2)

New-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName -TemplateUri https://raw.githubusercontent.com/anthonyonazure/template-building-blocks/master/scenarios/vnet-n-subnet/azuredeploy.json -templateParameterUriFromTemplate https://raw.githubusercontent.com/anthonyonazure/template-building-blocks/master/scenarios/vnet-n-subnet/parameters/vnet-multiple-subnet-dns.parameters.json
# Deploy Vnet-n-subnet scenario using building blocks

<#
From https://github.com/mspnp/template-building-blocks/wiki/DMZ-(v1)
Note that this scenario requires an existing resource group named bb-dev-rg, 
and a VNet named bb-dev-vnet with a 10.0.0.0/22 address space. 
The VNet must have one subnet with a 10.0.1.0/24 address space, 
one with a 10.0.2.0/24 address space, 
and one named GatewaySubnet with any address space. 
#>

$frontendSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix "10.0.1.0/24"
$virtualNetwork = New-AzureRmVirtualNetwork -Name "bb-dev-vnet" -ResourceGroupName $rg.ResourceGroupName -Location westus2 -AddressPrefix "10.0.0.0/22" -Subnet $frontendSubnet -Force
    Add-AzureRmVirtualNetworkSubnetConfig -Name "backendSubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.0.2.0/24" 
    Add-AzureRMVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.0.3.0/24" 
$virtualNetwork | Set-AzureRmVirtualNetwork
#
# Deploy a new VNet with three subnets based on the requirements listed above


New-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName -TemplateUri https://raw.githubusercontent.com/anthonyonazure/template-building-blocks/master/scenarios/dmz/azuredeploy.json -templateParameterUriFromTemplate https://raw.githubusercontent.com/anthonyonazure/template-building-blocks/master/scenarios/dmz/parameters/internal-dmz-new-subnets.parameters.json
#
# Deploy DMZ scenario template

<# 
IMPORTANT! The parameter files in the scenarios folder include hard-coded administrator usernames and passwords. 
It is strongly recommended that you immediately change the administrator password on the NVA VMs when the deployment is complete.
#>
