#Basic Get- Started Script
Get-Module azure -ListAvailable
Login-AzureRmAccount
Get-AzureRmSubscription

#Set default Subscription ID in case there are mulptiple Azure Subscriptions associated
Set-AzureRmContext -SubscriptionId #<your Subscription ID>

#New Resource Group Creation
New-AzureRmResourceGroup –Name 'KeyVaultResourceGroup' –Location 'Southeast Asia'

#New Key Vault Creation
New-AzureRmKeyVault -VaultName 'KeyVaultDXDemo1' -ResourceGroupName 'KeyVaultResourceGroup' -Location 'Southeast Asia' -Sku Premium


#New Key Creation
$key = Add-AzureKeyVaultKey -VaultName 'KeyVaultDXDemo1' -Name 'ContosoFirstKey' -Destination 'Software'
$Key.key.kid
$Key.key
$Key

#if you have existing sofware protected key in a .pfx:
$securepfxpwd = ConvertTo-SecureString –String 'password' –AsPlainText –Force
$key = Add-AzureKeyVaultKey -VaultName 'KeyVaultDXDemo1' -Name 'ContosoSecondKey' -KeyFilePath 'C:\Windows\System32\ClientAppKeyVaultcert.pfx' -KeyFilePassword $securepfxpwd

$secretvalue = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$secretvalue
$secret = Set-AzureKeyVaultSecret -VaultName 'KeyVaultDXDemo1' -Name 'SQLPassword' -SecretValue $secretvalue
$secret
$secret.Id

$vaultName           = 'KeyVaultDXDemo1'
$resourceGroupName   = 'KeyVaultResourceGroup'
$applicationName     = 'AppKV'
$location            = 'Southeast Asia'                          # Get-AzureLocation

#create and register app in AAD and then generate key - 
$SvcPrincipals = (Get-AzureRmADServicePrincipal -SearchString $applicationName)
if(-not $SvcPrincipals)
{
    # Create a new AD application if not created before
    $identifierUri = [string]::Format("http://localhost:8080/{0}",[Guid]::NewGuid().ToString("N"))
    $homePage = "http://contoso.com"
    Write-Host "Creating a new AAD Application"
    $ADApp = New-AzureRmADApplication -DisplayName $applicationName -HomePage $homePage -IdentifierUris $identifierUri  -CertValue $credValue -StartDate $now -EndDate $oneYearFromNow
    Write-Host "Creating a new AAD service principal"
    $servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $ADApp.ApplicationId
}
# Specify full privileges to the vault for the application - demo
Write-Host "Setting access policy"
Set-AzureRmKeyVaultAccessPolicy -VaultName $vaultName `
	-ObjectId $servicePrincipal.Id `
	-PermissionsToKeys all `
	-PermissionsToSecrets all `
	-PermissionsToCertificate all 
Write-Host "Paste the following settings into the app.config file for the HelloKeyVault project:" -ForegroundColor Cyan
'<add key="VaultUrl" value="' + $vault.VaultUri + '"/>'
'<add key="AuthClientId" value="' + $servicePrincipal.ApplicationId + '"/>'
'<add key="AuthCertThumbprint" value="' + $myCertThumbprint + '"/>'
Write-Host


#Authorize app to use key or secret
Get-AzureKeyVaultKey –VaultName 'KeyVaultDXDemo1'
Get-AzureKeyVaultSecret –VaultName 'KeyVaultDXDemo1'

##Grant permissions to a user for a key vault and then modify these permissions to the key vault

#The first command grants permissions for a user in your Azure Active Directory, PattiFuller@contoso.com, 
#to perform operations on keys and secrets with a key vault named Contoso03Vault. The second command modifies the 
#permissions that were granted to PattiFuller@contoso.com in the first command, to now allow getting secrets in
# addition to setting and deleting them. The permissions to key operations remain unchanged after this command.
#The PassThru parameter results in the updated object being returned by the cmdlet.
        Set-AzureRmKeyVaultAccessPolicy -VaultName 'Contoso03Vault' -UserPrincipalName 'PattiFuller@contoso.com' -PermissionsToKeys create,import,delete,list -PermissionsToSecrets 'Set,Delete'
        Set-AzureRmKeyVaultAccessPolicy -VaultName 'Contoso03Vault' -UserPrincipalName 'PattiFuller@contoso.com' -PermissionsToSecrets 'Set,Delete,Get' -PassThru
        Set-AzureRmKeyVaultAccessPolicy -VaultName 'Contoso03Vault' -UserPrincipalName 'PattiFuller@contoso.com' -PermissionsToKeys @() -PassThru

##Grant permissions for an application service principal to read and write secrets

#The application must be registered in your Azure Active Directory. The value of the ServicePrincipalName 
#parameter must be either the service principal name of the application(REDIRECT uri) or the application ID GUID
Set-AzureRmKeyVaultAccessPolicy -VaultName 'KeyVaultDXDemo1' -ResourceGroupName 'KeyVaultResourceGroup' -ServicePrincipalName ff5ea56c-6faa-4ec4-8526-5b6d54d0b42a -PermissionsToKeys decrypt,sign -PassThru
Set-AzureRmKeyVaultAccessPolicy -VaultName 'KeyVaultDXDemo1' -ResourceGroupName 'KeyVaultResourceGroup' -ServicePrincipalName ff5ea56c-6faa-4ec4-8526-5b6d54d0b42a -PermissionsToSecrets get -PassThru
Set-AzureRmKeyVaultAccessPolicy -VaultName 'KeyVaultDXDemo1' -ResourceGroupName 'KeyVaultResourceGroup' -ServicePrincipalName 'http://test3.contoso.com' -PermissionsToKeys @() -PassThru


$Keys = Get-AzureKeyVaultKey -VaultName 'KeyVaultDXDemo1'
$Keys
Get-AzureKeyVaultKey -VaultName 'KeyVaultDXDemo1'
#after creating a new key
 Get-AzureKeyVaultKey -VaultName 'KeyVaultDXDemo1'
 $Keys[0]
Get-AzureKeyVaultSecret -VaultName 'KeyVaultDXDemo1'
