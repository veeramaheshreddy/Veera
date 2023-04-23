#Run the Complete script in The CommandLine
#.\myscript.ps1 

#Installing the Azure Modules 
Install-Module -Name Az -AllowClobber -Scope CurrentUser

#Az-cloud shell to LocalMachine(Windows PowerShell Script)..Configuration.
#Enter the Azure Subsciption Credential Details for connecting 
Connect-AzAccount

#Create a New resourceGroup
New-AzResourceGroup -ResourceGroupName myResourceGroup -Location EastUS

#Create a new Virtual network and location must be same as resourceGroup
$virtualNetwork1 = New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroup `
  -Location EastUS `
  -Name myVirtualNetwork1 `
  -AddressPrefix 10.0.0.0/16

# Create the subnet configuration.
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name Subnet1 `
  -AddressPrefix 10.0.0.0/24 `
  -VirtualNetwork $virtualNetwork1

#Write the subnet configuration to the virtual network with Set-AzVirtualNetwork,
$virtualNetwork1 | Set-AzVirtualNetwork

# Create the virtual network2.
$virtualNetwork2 = New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroup `
  -Location EastUS `
  -Name myVirtualNetwork2 `
  -AddressPrefix 10.1.0.0/16

# Create the subnet configuration.
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name Subnet1 `
  -AddressPrefix 10.1.0.0/24 `
  -VirtualNetwork $virtualNetwork2

# Write the subnet configuration to the virtual network.
$virtualNetwork2 | Set-AzVirtualNetwork

#create the peering from myVirtualNetwork1 to myVirtualNetwork2.
Add-AzVirtualNetworkPeering `
  -Name myVirtualNetwork1-myVirtualNetwork2 `
  -VirtualNetwork $virtualNetwork1 `
  -RemoteVirtualNetworkId $virtualNetwork2.Id

#create the peering from myVirtualNetwork2 to myVirtualNetwork1.
Add-AzVirtualNetworkPeering `
  -Name myVirtualNetwork2-myVirtualNetwork1 `
  -VirtualNetwork $virtualNetwork2 `
  -RemoteVirtualNetworkId $virtualNetwork1.Id

#Here We checking the Peering Status of VNets Connected or Not
Get-AzVirtualNetworkPeering `
  -ResourceGroupName myResourceGroup `
  -VirtualNetworkName myVirtualNetwork1 `
  | Select PeeringState
## Creating IP for VirtualMachine ##
$ip1 = @{
    Name = 'myPublicIP1'
    ResourceGroupName = 'myResourceGroup'
    Location = 'EastUS'
    Sku = 'Standard'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
    Zone = 1,2,3   
}
New-AzPublicIpAddress @ip1

$ip2 = @{
    Name = 'myPublicIP2'
    ResourceGroupName = 'myResourceGroup'
    Location = 'EastUS'
    Sku = 'Standard'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
    Zone = 1,2,3   
}
New-AzPublicIpAddress @ip2

## Create virtual machine. ##
#Virtual machine 1..........
New-AzVm `
  -ResourceGroupName "myResourceGroup" `
  -Location "EastUS" `
  -VirtualNetworkName "myVirtualNetwork1" `
  -SubnetName "Subnet1" `
  -ImageName "Win2016Datacenter" `
  -PublicIpAddressName "myPublicIP1" `
  -Name "myVm1"

#Virtual Machine 2........
New-AzVm `
  -ResourceGroupName "myResourceGroup" `
  -Location "EastUS" `
  -VirtualNetworkName "myVirtualNetwork2" `
  -SubnetName "Subnet1" `
  -ImageName "Win2016Datacenter" `
  -PublicIpAddressName "myPublicIP2" `
  -Name "myVm2"

#Get the PublicIp address of VirtualMachine.....
Get-AzPublicIpAddress `
 