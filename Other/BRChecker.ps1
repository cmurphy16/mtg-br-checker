function Test-Urls {
    param(
        $Urls
    )

    ForEach ($Url in $Urls) {
        Write-Host "Checking: $($Url)"
        try {
            $Response = (Invoke-WebRequest -Uri "$Url").StatusCode
            if ($Response -eq 200) {
                Write-Host "$($Response): It's up!"
                return $Url
            }
        }
        catch {
            Write-Host "Not up yet."
        }
        Start-Sleep -Seconds 1
    }
    return $null
}

$BRDate = (Get-Date -Format "MMMM-d-yyyy").ToLower()
$BaseUrl = "https://magic.wizards.com/en/news/announcements"
$Urls = @(
    "$($BaseUrl)/banned-and-restricted-$($BRDate)",
    "$($BaseUrl)/$($BRDate)-banned-and-restricted",
    "$($BaseUrl)/banned-and-restricted-announcement-$($BRDate)",
    "$($BaseUrl)/$($BRDate)-banned-and-restricted-announcement"
)

$FoundUrl = $null
While (-not $FoundUrl) {
    $FoundUrl = Test-Urls -Urls $Urls
}
Start-Process "$($FoundUrl)"
Set-Clipboard "$($FoundUrl)"
