Param(
	[String]$JobName,
	[String]$Id
)

####################
# Import Functions #
####################
Import-Module "$PSScriptRoot\Helpers"

# Get the config from our config file
$config = (Get-Content "$PSScriptRoot\config\config.json") -Join "`n" | ConvertFrom-Json

# Should we log?
if($config.debug_log) {
	Start-Logging "$PSScriptRoot\log\debug.log"
}

# Add Veeam commands
Add-PSSnapin VeeamPSSnapin

# Get the session
$session = Get-VBRBackupSession | ?{($_.OrigJobName -eq $JobName) -and ($Id -eq $_.Id.ToString())}

# Wait for the session to finish up
while ($session.IsCompleted -eq $false) {
	Write-LogMessage 'Info' 'Session not finished Sleeping...'
	Start-Sleep -m 200
	$session = Get-VBRBackupSession | ?{($_.OrigJobName -eq $JobName) -and ($Id -eq $_.Id.ToString())}
}

# Save same session info
$Status = $session.Result
$JobName = $session.Name.ToString().Trim()
$JobType = $session.JobTypeString.Trim()

# Switch on the session status
switch ($Status) {
    None {$emoji = ':thought_balloon: '}
    Warning {$emoji = ':warning: '}
    Success {$emoji = ':green_heart: '}
    Failed {$emoji = ':fire: '}
    Default {$emoji = ''}
}

# Build the details string
$details  = "Backup Size - " + [String]$session.BackupStats.BackupSize + " / Data Size - " + [String]$session.BackupStats.DataSize + " / Dedup Ratio - " + [String]$session.BackupStats.DedupRatio + " / Compress Ratio - " + [String]$session.BackupStats.CompressRatio

# Build the payload
$slackJSON = @{}
$slackJSON.channel = $config.channel
$slackJSON.username = $config.service_name
$slackJSON.icon_url = $config.icon_url
$slackJSON.text = $emoji + '*Job:* ' + $JobName + "`n" + $emoji + '*Status:* ' + $Status + "`n" + $emoji + '*Details:* '  + $details

# Build the web request
$webReq=@{
    Uri = $config.webhook
    ContentType = 'application/json'
    Method = 'Post'
    body = ConvertTo-Json $slackJSON
}

# Send it to service
$request = Invoke-WebRequest -UseBasicParsing @webReq
