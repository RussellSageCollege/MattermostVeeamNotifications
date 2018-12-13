# Depreciated

This project has been depreciated in favor of [MelonSmasher/VeeamChatNotifications](git@github.com:MelonSmasher/VeeamChatNotifications.git) which supports Slack, Mattermost, Teams, and Discord.

# Veeam Backup and Restore Notification for Mattermost

Sends notifications from Veeam Backup & Restore to Mattermost

![Chat Example](https://raw.githubusercontent.com/TheSageColleges/MattermostVeeamNotifications/master/asset/img/screens/sh-2.png)

---

## Setup

Make a scripts directory: `C:\VeeamScripts`

```powershell
# To make the directory run the following command in PowerShell
New-Item C:\VeeamScripts PowerShell -type directory
```

#### Get code

Then clone this repository:

```shell
cd C:\VeeamScripts
git clone https://github.com/TheSageColleges/MattermostVeeamNotifications.git
cd MattermostVeeamNotifications
git checkout v1-stable
```

Or without git:

Download release, there may be later releases take a look and replace the version number with newer release numbers.
Unzip the archive and make sure the folder is called: `MattermostVeeamNotifications`
```powershell
Invoke-WebRequest -Uri https://github.com/TheSageColleges/MattermostVeeamNotifications/archive/v1.0.zip -OutFile C:\VeeamScripts\MattermostVeeamNotifications-v1.0.zip
```

Configure the project:

```shell
# Make a new config file
cp C:\VeeamScripts\MattermostVeeamNotifications\config\config.example.json C:\VeeamScripts\MattermostVeeamNotifications\config\config.json
# Edit your config file. You must replace the webhook field with your own Mattermost url.
notepad.exe C:\VeeamScripts\MattermostVeeamNotifications\config\config.json
```

Finally open Veeam and configure your jobs. Edit them and click on the <img src="https://raw.githubusercontent.com/TheSageColleges/MattermostVeeamNotifications/master/asset/img/screens/sh-3.png" height="20"> button.

Navigate to the "Scripts" tab and paste the following line the script that runs after the job is completed:

```shell
Powershell.exe -File C:\VeeamScripts\MattermostVeeamNotifications\NotificationBootstrap.ps1
```

![screen](https://raw.githubusercontent.com/TheSageColleges/MattermostVeeamNotifications/master/asset/img/screens/sh-1.png)

---

## Example Configuration:

Below is an example configuration file.

```shell
{
	"webhook": "https://mattermost.domain.com/...",
	"channel": "#veeam",
	"service_name": "VeeamBot",
	"icon_url": "https://pbs.twimg.com/profile_images/464400939227435008/1mEYi6d5_400x400.jpeg",
	"debug_log": false
}
```

## Random Notes:

* [Veeam Slack Notifications](https://github.com/TheSageColleges/VeeamSlackNotifications)
