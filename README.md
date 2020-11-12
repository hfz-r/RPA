
# Introduction
This document contains all essential information for the user to make full use of the Bot or Digital worker. This manual includes a description of the functions and capabilities and step-by-step procedures for setup & configuration of the Bot.

## Overview
SOC-V2 is a successor to the SO-Creation Part 3 Bot, introduced more effective approach while working with ERP. This bot covered a limitation existed in the previous version as described by below table:

|  | Previous | Current |
|--|--|--|
|configurable| hard-coded in variables | "single source of truth" text-file config  |
|logging & monitoring|built-in general log and deliver via email|watch events, records the states and store/deliver via email |
|error handling|stop process and alerting with email|retries on *n* times, close unexpected popup box|
|dynamic logic|existed SO can`t be edit (no function)|capable to determine new/existed SO and do action|
|smarter object clone|not implement|implemented ([benefits](https://docs.automationanywhere.com/bundle/enterprise-v11.3/page/enterprise/topics/aae-client/metabots/getting-started/aae-client-metabot-designer-overview.html))|
|processing speed|reduced due to highly depended on *delay* and readiness state|integration with database and scripting maximized the throughput|
|presentable|output content on plain-text|output content presented with rich HTML email template |

Generally, existed process flow was untouched and maintained.  

## Visual Flow
![v-flow](https://i.ibb.co/YWQ0DKj/visual-flow.png)

# Getting Started
## Skill Matrix
**The functionality of the Bot has been divided into set of skills.**

Below is an overview of how the task bots and metabots map to these skills:
| Skill | Task Files | MetaBot Files|
|--|--|--|
| A bot entry point and an interface for variables initialization | D365-P3V2-Init.atmx | No MetaBots |
| An abstract interface that orchestrate the core logic | D365-P3V2.atmx |WebScrapper-D365.mbot|
|An error handler |D365-P3V2-Err.atmx|No MetaBots|
|Contained all ERP assets and logic|N/A|WebScrapper-D365.mbot|

## Installation Hierarchy
Below is the sample folder structure based on this repository and its `config.txt`.  
```
<AA Application Path>
│   README.md
│   config.txt    
│
└───My Tasks
│   └───SOC-V2
|		└───assets
|		└───Scripts
│       │   D365-P3V2.atmx
│       │   D365-P3V2-Err.atmx
|		|	D365-P3V2-Init.atmx
│   
└───My MetaBots
|   │   WebScrapper-D365.mbot
|

<Any folder>  
│
└───Input Folder
│   └───main
│   
└───Log Folder
│   └───Snapshot
|   │   log-fail.txt
|   │   log-success.txt
|
```

<table>
	<tbody>
		<tr>
			<td>Folder Structure</td>
			<td>Description</td>
			<td>Config Map</td>
		</tr>
		<tr>
			<td><h4>&lt;AA Application Path&gt;</h4></td>
			<td>Location where AA files are stored on your machine</td>
			<td></td>
		</tr>
		<tr>
			<td><h4>My Tasks</h4></td>
			<td>Default directory where Bot Files are saved.</td>
			<td rowspan="2"><em>pathTaskBot</em></td>
		</tr>
		<tr>
			<td><h4>SOC-V2</h4></td>
			<td>Base folder contains files and folders needed for the bot execution.</td>
		</tr>
		<tr>
			<td><h4>assets</h4></td>
			<td>Contains static files that was used in bot.</td>
			<td><em>pathAssets</em></td>
		</tr>
		<tr>
			<td><h4>Scripts</h4></td>
			<td>Contains client side active scripting that was used by bot execution.</td>
			<td><em>"sc*" prefixes</em></td>
		</tr>
		<tr>
			<td><h4>D365-P3V2.atmx</h4></td>
			<td rowspan="3">Contains all the developed platform source code</td>
			<td rowspan="3"></td>
		</tr>
		<tr>
			<td><h4>D365-P3V2-Err.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>D365-P3V2-Init.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>My MetaBots</h4></td>
			<td rowspan="2">Contains the Developed Metabots needed for the bot execution.</td>
			<td rowspan="2"></td>
		</tr>
		<tr>
			<td><h4>WebScrapper-D365.mbot</h4></td>
		</tr>
		<tr>
			<td><h4>Input Folder</h4></td>
			<td rowspan="2">Contains input files that the bot needs for execution of the use case.</td>
			<td rowspan="2"><em>pathBase</em></td>
		</tr>
		<tr>
			<td><h4>main</h4></td>
		</tr>
		<tr>
			<td><h4>Log Folder</h4></td>
			<td rowspan="4">Contains logs and snapshots of screens if something goes wrong with the bot during execution</td>
			<td><em>pathLog</em></td>
		</tr>
		<tr>
			<td><h4>Snapshot</h4></td>
			<td><em>folderSnapshot</em></td>
		</tr>
		<tr>
			<td><h4>log-fail.txt</h4></td>
			<td><em>failLog</em></td>
		</tr>
		<tr>
			<td><h4>log-success.txt</h4></td>
			<td><em>successLog</em></td>
		</tr>
	</tbody>
</table>

## Quick Start
### 1. Setup
No additional setup is required.

### 2. Configuration
The bot required valid parameters to be parse down the sub-task before start execution. An exception will be triggered if incorrect value has been detected. Configuration file can be configured at:
> **AA Application Path** > config.txt

Below is the how the configuration file looks:
![cfg](https://i.ibb.co/9Y5Q0zS/Screenshot-2020-11-11-153007.png)

Below is a table that summaries what the variable name is, what it does, and an example of the input & output:
|Variable name|Type|Required|Purpose|Example input| 
|--|:--:|:--:|--|--|
|emailReceiver|text|yes|A list of recipient emails for notification|abc@email.com|
|emailSender|text|yes|Sender email|alert@hartalega.com|
|isValidateHeader|boolean|no|A flag to allow bot re-validate SO header on "Edit" mode|true|
|maxHeaderTries|number|yes|SO header retry indicator|3|
|maxLineTries|number|yes|SO line retry indicator|2|
|maxCustInstrucTries|number|yes|SO customer instruction retry indicator|2|
|dbEnvironment|text|yes|Database environment switch|LIVE|
|dbConnection|text|yes|MS-SQL connection string|[example](https://www.connectionstrings.com/sql-server/)|
|failLog|text|yes|Failure logging filename|log-fail.txt|
|successLog|text|yes|Success logging filename|log-success.txt|
|folderBase|text|yes|Working folder name|D365|
folderSnapshot|text|yes|Snapshot folder name|Snapshot|
|pathBase|text|yes|Working folder absolute path|D:\AA-RPA\Auto SO Creation|
|pathLog|text|yes|Log folder absolute path|D:\Log|
|pathAssets|text|yes|Bot`s assets folder relative path|Automation Anywhere\My Tasks\SOC-V2\assets|
|pathTaskBot|text|yes|Bot folder relative path|Automation Anywhere\My Tasks\SOC-V2| 
|scArchive|text|yes|Archive script relative path|Automation Anywhere\My Tasks\SOC-V2\Scripts\Archive.vbs|
|scFileTransform|text|yes|File converter script relative path|Automation Anywhere\My Tasks\SOC-V2\Scripts\FileTransform.vbs|
|scFileCount|text|yes|File counter script relative path|Automation Anywhere\My Tasks\SOC-V2\Scripts\FileCount.vbs|
|scFlattenDate|text|yes|Date formatted relative path|Automation Anywhere\My Tasks\SOC-V2\Scripts\FlattenDate.vbs|
|scRowColorSelector|text|yes|Email template script relative path|Automation Anywhere\My Tasks\SOC-V2\Scripts\RowColorSelector.vbs|
|scSOLineCount|text|yes|SO line records counter script relative path|Automation Anywhere\My Tasks\SOC-V2\Scripts\SOLineCount.vbs|
|urlD365|url|yes|Dynamic D365 url|https://ax.d365live.hartalega.com.my/namespaces/AXSF/|
|urlD365Auth|url|yes|Dynamic D365 auth. gateway|https://adfs.hartalega.com.my/adfs/oauth2/authorize/|

# Logs
In case of Success/Errors, Error Logs & Screenshots are generated within **Logs Folder**.
```
<Any folder>  
|
└───Log Folder
│   └───Snapshot
|   │   log-fail.txt
|   │   log-success.txt
|
```
Success Log will contain the below information -
 - Generated timestamp
 - Success description
 - Processed SO details

Error Logs will contain the below information -
 - Generated timestamp
 - Error description
 - Failed SO details

**Example of Log Files:**
![err-fld](https://i.ibb.co/5Wgdv46/err.png)
![ok](https://i.ibb.co/my96M5r/ok.png)
![xok](https://i.ibb.co/m0256tq/xok.png)

**Example of Screenshot Generated Error File (Snapshot)** 
![snap](https://i.ibb.co/njWKwxb/snap.png)
![snap](https://i.ibb.co/pXSrWSB/error-111120201843.png)

# Troubleshooting

Migration folder structure mapping based on `config.txt`

|Type|Previous version|Current version|
|:--|:--|:--|
| Task bot |`Users\<User>\Documents\<AA Application Path>\Automation Anywhere\<My Tasks>\Publish\Part 3`|`Users\<User>\Documents\<AA Application Path>\Automation Anywhere\<My Tasks>\SOC-V2`|
|Metabot|N/A|`Users\<User>\Documents\<AA Application Path>\Automation Anywhere\<My MetaBots>`|
|Working folder|`\\NGC-FILESERVER\AA-RPA\Auto SO Creation\D365`|`<Any folder>\Input Folder\main`|
|Log folder|N/A|`<Any folder>\Log Folder`|

