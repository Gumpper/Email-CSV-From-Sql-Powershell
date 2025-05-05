############## SQL Connection
$SQLHost = 'SQL Server IP or name'
$Dbase = 'Data base name'
$SQLUser = 'SQL User'
$SQLPassword = 'SQL User Password'

############# Email Server Settings
$secpasswd = ConvertTo-SecureString "<gmail generated app password>" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("me@gottobeme.com", $secpasswd)
$From = "me@gottobeme.com"
$user = "me@gottobeme.com"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"

############# Other Settings
$Runlocation = 'C:\scripts-nog'