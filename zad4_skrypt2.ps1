function prepare_modules {
    if ($null -eq $(Get-InstalledModule -Name Az -ErrorAction SilentlyContinue)) { 
        Install-Module -Name AZ -AllowClobber -Scope AllUsers  
    }
    Import-Module Az
}
# Funkcja łącząca do Azure
function LoginToAzure {
    try 
    { Get-AzureADTenantDetail } 
    catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] 
    { Connect-AzAccount -TenantId xxxxxx }
}
#Funkcja odpowiedzialna za wyświetlanie menu
function ShowMenu {
    Clear-Host
    Write-Host -ForegroundColor Yellow "========================== MENU =========================="
    Write-Host ""
    Write-Host -ForegroundColor Yellow "        == Obecnie jesteś zalogowany na konto: ==         "
    if ($null -eq $($(Get-AzAccessToken -ErrorAction SilentlyContinue).UserId)) {
        Write-Host -ForegroundColor Red "           == Brak zalogowanego konta Azure ==         "
    }
    else {
        Write-Host -ForegroundColor Green "             == $($(Get-AzAccessToken).UserId) ==         "
    }
    Write-Host -ForegroundColor Green 
    Write-Host ""
    Write-Host -ForegroundColor Yellow "                 == Obsługa raportów ==                   "
    Write-Host "1: Wciśnij '1' aby otrzymać raport GRUP ZASOBÓW."
    Write-Host "2: Wciśnij '2' aby otrzymać raport LISTA ZASOBÓW."
    Write-Host -ForegroundColor Yellow "                       == Więcej ==                       "
    Write-Host "A: Wciśnij 'A' aby otrzymać informacje o autorze."
    Write-Host "K: Wciśnij 'K' aby zmienić zalogowane konto."
    Write-Host "L: Wciśnij 'L' aby się wylogować."
    Write-Host "Q: Wciśnij 'Q' aby wyjść."
    Write-Host ""
    Write-Host -ForegroundColor Yellow "=========================================================="
}
function LogoutFromAzure {
    Disconnect-AzAccount | Out-Null
    Write-Host "Pomyślnie wylogowano"
}

#Funkcja ShowAuthor wyświetla informacje o autorze tego skrypty
function ShowAuthor {
    Write-Host    "ASC"
    Write-Host    ""
    Write-Host    "Author:"
    Write-Host    "Grzegorz Sekuła"
    Write-Host    "Grupa: MZ01AC1"
    Write-Host    "Nr indeksu: 17313"
}
function reportResourceGroups() {
    Write-Host "Raport GRUP ZASOBÓW"
    Write-Host ""
    Get-AzResourceGroup
    Write-Host "Wciśnij dowolny klawisz aby kontynuować..."
    Read-Host
}
function reportResources() {
    Write-Host "Raport LISTA ZASOBÓW"
    Write-Host ""
    Get-AzResource
    Write-Host "Wciśnij dowolny klawisz aby kontynuować..."
    Read-Host
}
function menu {
    #Wyświetlenie menu i oczekiwanie na decyzję. Po wybraniu odpowiedniej opcji jest wywoływana odpowiednia funkcja
    do {
        ShowMenu
        $selection = Read-Host "Proszę dokonać wyboru"
        switch ($selection) {
            '1' {
                Clear-Host
                reportResourceGroups
            }
            '2' {
                Clear-Host
                reportResources
            }
            'a' {
                Clear-Host
                ShowAuthor
            }
            'k' {
                Clear-Host
                LoginToAzure
            }
            'l' {
                Clear-Host
                LogoutFromAzure
            }
            'q' {

            }
            Default {
                q
                Clear-Host
                "Nie ma takiej opcji"
            }
        }
        pause
    }
    until ($selection -eq 'q')
}

prepare_modules
connect_to_azure | Out-Null
menu
