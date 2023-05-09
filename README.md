# domain-user-passwd-expire
This script send a notification via email to each user that has its domain user password almost expiring, the default days left are in 0, 1, 5, 10 days but you can set to however day you want, it can be anywhere between 0 and 999+ days remaining.

!! You have to change the smtpServer, smtpPort AND the sender email - check how bellow !!

> Coding language: English | EN  
> User displayed language default: Portuguese | PT  
> User displayed language: Basic changes to email body for another language bellow

The script will run the command:
```
$userInfo = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "mail", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "DisplayName","Mail",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, mail
```
Wich will get the name, email and password expire date of the domain users, the file "userdata.txt" that I made available is an example of the output this command gets and works with.  

Before working with that information, it will be cleaned first as to remove unnecessary spaces to dodge errors, so you can edit the expire dates for testing without worring about the format.
The script always checks for the time on the computer/domain it is being run on.

With the informationg grabbed, it will then filter out only the informationg with dates and check how manys days from now to the expire date, if the number is equal to any of the ones in the switch code, it will grab that user information and send an email to him.

### How to add different trigger dates
The following command is what decides the dates
```
switch ($duration.Days)
        {
            0 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "0" }
            1 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "1" }
            5 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "5"  }
            10 { $userName = $line.split(" ")[0]; $mail = $line.split(" ")[1]; $date = $extractedDate; $days = "10"  }
            Default { $null; break }
        }
```
> What you only need to change are the first numbers (0, 1, 5, 10) and the last numbers on each line (0, 1, 5, 10), so if you change any of them, you have to change both.

> Now, if you want to add or remove days, you just have to delete that line OR add another and you only need to change the first and last number

### How to change language on email body and smtp
SMTP:
On lines 13 and 14 change the smtpport and the smtpserver to the one your network administrator gave you. Also check the documentation https://support.smartbear.com/swaggerhub/docs/enterprise/v1/config/smtp.html
[smartbear config/smtp]([https://pages.github.com/](https://support.smartbear.com/swaggerhub/docs/enterprise/v1/config/smtp.html))
