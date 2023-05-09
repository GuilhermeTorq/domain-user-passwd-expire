# Coding languague: English | EN
# User displayed language: Portuguese | PT
# Script created: 12/04/2023
# Script updated: 09/05/2023

function sendNotification($username, $mail, $date, $days)
{
    $emailBody = "`n`n!Aviso de alerta!`n`nPassword de utilizador vai expirar a $date ($days dias)`n`nUtilizador: $username`nEmail: $mail`n`nAtenciosamente,`nServidor`n`n"

    $from = "user@domain.com"
    $to = $mail
    $subject = "A sua password de utilizador vai expirar em $days dias!"
    $smtpServer = "mysmtp.com"
    $smtpPort = "25"

    $script = "& Send-MailMessage -From `"$from`" -to `"$to`" -Subject `"$subject`" -Body `"$emailBody`" -SmtpServer `"$smtpServer`" -port `"$smtpPort`""

    write-host $script
    #Invoke-Expression $script -encoding utf8

    write-host "`n::::::::::::::::::::::::`n"
    Clear-Variable -Name "emailBody", "username", "mail", "date", "days"
}

Clear Host

#Grab filtered users password expiration date and name
<#
$userInfo = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "mail", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "DisplayName","Mail",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
#>

# The lines 34 & 35 are only for a simulation, delete 34 & 35 when ready and uncomment line 28 and 31 ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
$filePath = "userdata.txt"
$userInfo =  Get-Content $filePath

$currentTime = Get-Date -Format "dd/MM/yyyy"

#Removes unnecessary spaces between words, and replaces it for only one space
$userInfo = $userInfo -replace '\s+', ' '

foreach($line in $userInfo)
{
    if($line -match '\d\d\/\d\d/\d\d\d\d' -OR $line -match '\d\/\d\d/\d\d\d\d' -OR $line -match '\d\/\d/\d\d\d\d' -OR $line -match '\d\d\/\d/\d\d\d\d')
    {
        $extractedDate = $line.split(" ")[2]
        $duration = New-TimeSpan -Start $currentTime -End $extractedDate

        switch ($duration.Days)
        {
            0 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "0" }
            1 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "1" }
            5 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "5"  }
            10 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "10"  }
            Default { $null; break }
        }
        if($username)
        {
            sendNotification $username $mail $date $days
            $varCheck = $true
            Clear-Variable -Name "username", "mail", "date", "days", "duration"
        }
    }
}

if(!$varCheck)
{
    Write-Host "`nScript Terminado... Não existe nenhuma password a expirar nos proximos 10, 5, 1, 0 dias exatamente!`n"
    exit
}

Write-Host "`nScript Terminado..."
Clear-Variable -Name "extractedDate", "currentTime", "userInfo", "username", "mail", "date", "days", "varCheck"
