using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$ActivateZone = $Request.Query.ActivateZone
if (-not $ActivateZone) {
    $ActivateZone = $Request.Body.ActivateZone
}

if ($ActivateZone) {
    $status = [HttpStatusCode]::OK

    if ($ActivateZone -eq "1") {
        $RG = "LBTest"
        $ActivateNICName = "LB-manual-vm1-networkInterface"
        $DeactivateNICName = "LB-manual-vm2-networkInterface"

        $ActivateNIC = Get-AzNetworkInterface -ResourceGroupName $RG -Name $ActivateNICName
    
        $lb = Get-AzLoadBalancer -ResourceGroupName $RG -Name "LB-manual-lb"
        $lbPoolConfig = Get-AzLoadBalancerBackendAddressPoolConfig -LoadBalancer $lb 

        $ActivateNIC.IpConfigurations[0].LoadBalancerBackendAddressPools=$lbPoolConfig
        Set-AzNetworkInterface -NetworkInterface $ActivateNIC
    
    
        $DeactivateNIC = Get-AzNetworkInterface -ResourceGroupName $RG -Name $DeactivateNICName
        $DeactivateNIC.IpConfigurations[0].LoadBalancerBackendAddressPools = $null
        Set-AzNetworkInterface -NetworkInterface $DeactivateNIC

        $body = "zone 1 activated"
        }
    
    if ($ActivateZone -eq "2") {

        $RG = "LBTest"
        $ActivateNICName = "LB-manual-vm2-networkInterface"
        $DeactivateNICName = "LB-manual-vm1-networkInterface"

        $ActivateNIC = Get-AzNetworkInterface -ResourceGroupName $RG -Name $ActivateNICName

        $lb = Get-AzLoadBalancer -ResourceGroupName $RG -Name "LB-manual-lb"
        $lbPoolConfig = Get-AzLoadBalancerBackendAddressPoolConfig -LoadBalancer $lb 

        $ActivateNIC.IpConfigurations[0].LoadBalancerBackendAddressPools=$lbPoolConfig
        Set-AzNetworkInterface -NetworkInterface $ActivateNIC
    
    
        $DeactivateNIC = Get-AzNetworkInterface -ResourceGroupName $RG -Name $DeactivateNICName
        $DeactivateNIC.IpConfigurations[0].LoadBalancerBackendAddressPools = $null
        Set-AzNetworkInterface -NetworkInterface $DeactivateNIC

        $body = "zone 2 activated"
    }

    else {
    $body = "zone must be 1 or 2"
    }
}

else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Pass a Zone name on the query string or in the request body. Allowed Zone names are 1 or 2"
}

Write-host $body

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
