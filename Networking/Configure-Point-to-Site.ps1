
$vpnClientPool = "10.1.0.0/24"
# Below is your First VNET Gateway
$vpnGWName = "MYGW1"
# Below is Resource Group of your MYGW1
$rgName = "VNETRG1"
$rootCertName = "P2SRoot.cer" 

$publicCertData = "[REPLACE WITH PUBLIC KEY VALUE]" 

# Retrieve the current virtual network configuration 
$vpnGW = Get-AzureRmVirtualNetworkGateway -ResourceGroupName $rgName `
                                          -Name $vpnGWName


# This cmdlet adds the client address pool defined in the $vpnClientPool variable to the gateway
# This is the range of addresses VPN clients will use to connect to the gateway
Set-AzureRmVirtualNetworkGatewayVpnClientConfig `
             -VirtualNetworkGateway $vpnGW `
             -VpnClientAddressPool $vpnClientPool  

# This cmdlet applies the certificate to the gateway for authentication
Add-AzureRmVpnClientRootCertificate `
            -VpnClientRootCertificateName $rootCertName `
            -VirtualNetworkGatewayName $vpnGWName `
            -ResourceGroupName $rgName `
            -PublicCertData $publicCertData 

# This cmdlet downloads the VPN client to the machine that is running the PowerShell script and saves it in the same folder
$downloadUrl = Get-AzureRmVpnClientPackage `
            -ResourceGroupName $rgName `
            -VirtualNetworkGatewayName $vpnGWName `
            -ProcessorArchitecture Amd64 

Invoke-WebRequest -Uri $downloadUrl.Replace("""","") -OutFile "$PSScriptRoot\VPNclient.exe" 