
# Overview

Before that, please read previous version ([SOC-V2](http://bj-tfs:8080/tfs/BIACollection/RPA/_git/SOC-V2?path=%2F&version=GBmaster&_a=readme)) 
technical spec for better understandment on the core functions. 

**SOC-V2.2** improve on below area:
- restructuring business logic flow
- Metabot logic
- bug fixing
- AX4 implementation (yes you`ll only need one bot)

Scope of this document covered the details on the new changes. The rest will apply the same concept as its predecessor [SOC-V2](http://bj-tfs:8080/tfs/BIACollection/RPA/_git/SOC-V2?path=%2F&version=GBmaster&_a=readme)

# Getting Started
## Skill Matrix
**The functionality of the Bot has been divided into set of skills.**

Below is an overview of how the task bots and metabots map to these skills:
| Skill | Task Files | MetaBot Files|
|--|--|--|
| A bot entry point and an interface for variables initialization | P3V2.atmx | No MetaBots |
| An abstract interface that orchestrate the core logic | P3V2-Main.atmx |WebScrapper-D365.mbot|
|||WinScrapper-AX4.mbot|
|An error handler |P3V2-Err.atmx|No MetaBots|
|Email engine |P3V2-Email.atmx|No MetaBots|
|Contained all D365 ERP assets and logic|N/A|WebScrapper-D365.mbot|
|Contained all AX4 ERP assets and logic|N/A|WinScrapper-AX4.mbot|

## Installation Hierarchy
Below is the sample folder structure based on this repository and its `config.txt`.  
```
<AA Application Path>
│   README.md
│   config.txt    
│
└───My Tasks
│   └───SOC-V2.2
|		└───assets
|		└───Scripts
│       │   P3V2.atmx
│       │   P3V2-Email.atmx
│       │   P3V2-Err.atmx
|		|	P3V2-Main.atmx
│   
└───My MetaBots
|   │   WebScrapper-D365.mbot
|   │   WinScrapper-AX4.mbot
|

<Any folder>  
│
└───Input Folder
│   └───main
|		└───AX4
|		└───D365
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
			<td><h4>SOC-V2.2</h4></td>
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
			<td><h4>P3V2.atmx</h4></td>
			<td rowspan="4">Contains all the developed platform source code</td>
			<td rowspan="4"></td>
		</tr>
		<tr>
			<td><h4>P3V2-Email.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>P3V2-Err.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>P3V2-Main.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>My MetaBots</h4></td>
			<td rowspan="3">Contains the Developed Metabots needed for the bot execution.</td>
			<td rowspan="3"></td>
		</tr>
		<tr>
			<td><h4>WebScrapper-D365.mbot</h4></td>
		</tr>
		<tr>
			<td><h4>WinScrapper-AX4.mbot</h4></td>
		</tr>
		<tr>
			<td><h4>Input Folder</h4></td>
			<td rowspan="4">Contains input files that the bot needs for execution of the use case.</td>
			<td rowspan="2"><em>pathBase</em></td>
		</tr>
		<tr>
			<td><h4>main</h4></td>
		</tr>
		<tr>
			<td><h4>AX4</h4></td>
			<td>pathAX4Base</td>
		</tr>
		<tr>
			<td><h4>D365</h4></td>
			<td>pathD365Base</td>
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
Change/new variables that been introduced in this version.

|Variable name|Type & deprecated value|Purpose|Example input| 
|--|--|--|--|
|environment|**update** -> dbEnvironment|Database environment switch|UAT|
|closeOnFinish|**new::boolean**|Instruction to close all opened windows on finish|true|
|pathAX4Base|**new::string**|AX4 working folder absolute path|D:\AA-RPA\Auto SO Creation\AX4|
|pathD356Base|**new::string**|D365 working folder absolute path|D:\AA-RPA\Auto SO Creation\D365|
|pathAX4UAT|**new::string**|AX4 UAT executable absolute path|Desktop\Microsoft Dynamics AX UAT.axc|
|pathAX4LIVE|**new::string**|AX4 Live executable absolute path|Desktop\Microsoft Dynamics AX LIVE.axc|
|urlD365UAT|**update** -> urlD365|D365 UAT url|https://ax-d365.hartalega.com.my/namespaces/AXSF/|
|urlD365LIVE|**update** -> urlD365|D365 UAT url|https://ax.d365live.hartalega.com.my/namespaces/AXSF/|