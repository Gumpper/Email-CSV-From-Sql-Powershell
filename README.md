# Email-CSV-From-Sql-Powershell
Using PowerShell and a SQL script to send CSV reports to an email address

I user a schedualr to automate the sending of emails

the command line 
powershell.exe -file C:\scripts-nog\SendMailFunction.ps1 -To email@this.com  -Cc email@something.com -Bcc bbc@news.com -script EstimatesAndJobDailyCounts

*note on the -script <file> do not include .sql this is assumed within the script and the name of the script is use in the subject and the body of the email and also is used to name the .csv file generated.
