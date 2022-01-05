# zmienna z katalogiem roboczym
$workDir = $PSScriptRoot
function prepare_modules {
    if ($null -eq $(Get-InstalledModule -Name Az -ErrorAction SilentlyContinue)) { 
        Install-Module -Name AZ -AllowClobber -Scope AllUsers  
    }
    Import-Module Az
}
# Funkcja łącząca do Azure
function connect_to_azure {
    try 
    { Get-AzureADTenantDetail } 
    catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] 
    { Write-Host "You're not connected."; Connect-AzAccount -TenantId xxxxx}
}

prepare_modules
connect_to_azure | Out-Null
$collection = Get-Content $workDir\regions.txt
foreach ($item in $collection) {
    New-AzResourceGroup -Name "17313_$($item -replace '\s','')" -Location "$($item)"
}
