# Define parameters for dynamic input
param (
    [Parameter()]
    [string[]]$To,    # Optional Recipient email addresses
    [Parameter()]
    [string[]]$Cc,    # Optional CC email addresses
    [Parameter()]
    [string[]]$Bcc,   # Optional BCC email addresses
    [Parameter(Mandatory = $true)]
    [string]$Script   # SQL script name (without file extension)
)
# Check if the SqlServer module is installed
if (Get-Module -ListAvailable -Name SqlServer) {
    Write-Output "The SqlServer module is installed."

# Include the settings file
. ".\settings.ps1"

# Validate and set the SQL script path
$SQLScript = Join-Path $Runlocation "$Script.sql"

# Ensure at least one recipient is provided
if (-not $To -and -not $Cc -and -not $Bcc) {
    throw "Error: At least one recipient (To, Cc, or Bcc) must be specified."
}

# Default $To to $From if it's null or empty
if (![string]::IsNullOrEmpty($To)) {
    # $To is already provided, no changes needed
} else {
    Write-Output "No 'To' recipient provided; defaulting to sender ($From)."
    $To = @($From)
}

# Navigate to the working directory
Set-Location -Path $Runlocation

# Define the parameters for Invoke-Sqlcmd
$SqlCmdParams = @{
    InputFile             = $SQLScript
    ServerInstance        = $SQLHost
    Database              = $Dbase
    Username              = $SQLUser
    Password              = $SQLPassword
    QueryTimeout          = 0
    TrustServerCertificate = $true
}

# Execute the SQL command using splatting and export results
try {
    Invoke-Sqlcmd @SqlCmdParams | Export-Csv -Path ".\$Script.csv" -NoTypeInformation
    Write-Output "SQL query executed successfully, results exported to '.\$Script.csv'."
} catch {
    throw "Error executing SQL query: $_"
}

# Define email details
$Attachment = ".\$Script.csv"
$Subject = "$Script Report"
$Body = "$Script Report"

# Build the Send-MailMessage parameters dynamically
$SendMailParams = @{
    From        = $From
    Subject     = $Subject
    Body        = $Body
    SmtpServer  = $SMTPServer
    Port        = $SMTPPort
    UseSsl      = $true
    Credential  = $cred
    Attachments = $Attachment
}

# Add recipients only if they are specified
if ($To) { $SendMailParams["To"] = $To }
if ($Cc) { $SendMailParams["Cc"] = $Cc }
if ($Bcc) { $SendMailParams["Bcc"] = $Bcc }

# Send the email
try {
    Send-MailMessage @SendMailParams
    Write-Output "Email sent successfully to: $To. CC: $Cc. BCC: $Bcc."
} catch {
    throw "Error sending email: $_"
}

$SendMailParams
} else {
    Write-Output "The SqlServer module is NOT installed. Please install it using 'Install-Module -Name SqlServer'."
    Install-Module -Name SqlServer
}
