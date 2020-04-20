$RG = "LBTestVMs"

$vnet = Get-AzVirtualNetwork -Name "LB-manual-vnet" -ResourceGroupName $RG
$backendSubnet = Get-AzVirtualNetworkSubnetConfig -Name "BackendSubnet" -VirtualNetwork $vnet

$NICName = "testNIC2"

$lb = Get-AzLoadBalancer -ResourceGroupName $RG -Name "LB-manual-lb"
$lbPoolConfig = Get-AzLoadBalancerBackendAddressPoolConfig -LoadBalancer $lb 


$NIC = Get-AzNetworkInterface -ResourceGroupName $RG -Name $NICName 
$NIC.IpConfigurations[0].LoadBalancerBackendAddressPools=$lbPoolConfig
Set-AzNetworkInterface -NetworkInterface $NIC

$lb | Set-AzLoadBalancer 



$removeConfig = Remove-AzNetworkInterfaceIpConfig -NetworkInterface $NIC
Set-AzNetworkInterfaceIpConfig -NetworkInterface $NIC -Name "ipconfig1" -PrivateIpAddress 10.0.1.4 -Subnet $backendSubnet -PublicIpAddress  -ApplicationSecurityGroup

New-AzNetworkInterfaceIpConfig -Name ipconfig1 -PrivateIpAddress 10.0.1.4 -Subnet $backendSubnet 
$nic | Set-AzNetworkInterfaceIpConfig -Name ipconfig1 -PrivateIpAddress 10.0.1.4 -Subnet $backendSubnet -Primary

$nic | Set-AzNetworkInterface