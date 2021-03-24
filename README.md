# Overview
AP Automation currently was a prototype and may change in time to time. Check out the first proposal document to understand the underlying concept of this project. 

[D365 AP Automation Analysis.docx](http://bj-tfs:8080/tfs/BIACollection/RPA/_git/SOC-V2?path=%2F&version=GBmaster&_a=readme)

**AP Automation** introduced below features:
- Single config file
- Verbose logging
- Fault tolerance
- Speed
- Cross platform resources sharing

## High-level design flow diagram
**IQ Bot resource feeder** 

![iq-bot](https://i.ibb.co/wB1f48T/d365-ap-automation-flow-Page-5.png)

**Main bot**

![main](https://i.ibb.co/ZMcFy9F/d365-ap-automation-flow-Page-4.png)

# Getting Started
## Skill Matrix
**The functionality of the Bot has been divided into set of skills.**

Below is an overview of how the task bots and metabots map to these skills:
| Skill | Task Files | MetaBot Files|
|--|--|--|
| Responsible to forward the resources into IQ Bot engine | AP.FEEDER.atmx | No MetaBots |
| Interface for variables initialization | AP.CONF.atmx | No MetaBots |
| An abstract interface that orchestrate the core logic | AP.atmx |No MetaBots|
| Responsible to handle business logic for a PO type |AP PO.atmx|AP-AUTO-D365.mbot|
| Responsible to handle business logic for a non PO type |AP XPO.atmx|AP-AUTO-D365.mbot|
| Contained all ERP assets and logic|N/A|AP-AUTO-D365.mbot|

## Installation Hierarchy
Below is the sample folder structure based on this repository and its `config-ap.txt`.  

**IQ Bot resource feeder agent. MUST be on machine/server  NGC-SVR-0176-V**  
```
<AA Application Path>
|
└───My Tasks
│   └───AP Feeder
|		└───assets**
│       │   AP.FEEDER.atmx
|

<Any folder>  
│
└───Input Folder
|		└───AP Input**
│   
└───Log Folder**
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
			<td></td>
		</tr>
		<tr>
			<td><h4>AP Feeder</h4></td>
			<td>Base folder contains files and folders needed for the bot execution.
			<td></td></td>
		</tr>
		<tr>
			<td><h4>assets**</h4></td>
			<td><b>Symbolic link</b> from the main bot's assets</td>
			<td></td>
		</tr>
		<tr>
			<td><h4>AP.FEEDER.atmx</h4></td>
			<td>Contains the developed platform source code</td>
			<td></td>
		</tr>
		<tr>
			<td><h4>Input Folder</h4></td>
			<td>Contains input files that the bot needs for execution of the use case.</td>
			<td></td>
		</tr>
		<tr>
			<td><h4>AP Input**</h4></td>
			<td><b>Symbolic link</b> from the AP Automation file server <b>\\NGC-FILESERVER\AA-RPA\AP AUTO</b></td>
			<td></td>
		</tr>
		<tr>
			<td><h4>Log Folder**</h4></td>
			<td><b>Symbolic link</b> from the main bot's log</td>
			<td></td>
		</tr>
	</tbody>
</table>


**Main bot. Can be on any supported machine/server**  
```
<AA Application Path>
│   README.md
│   config-ap.txt    
|	Vendor mapping file.xlsx
│
└───My Tasks
│   └───AP Automation
|		└───assets
│       │   AP PO.atmx
│       │   AP XPO.atmx
|		|	AP.atmx
|		|	AP.CONF.atmx
│   
└───My MetaBots
|   │   AP-AUTO-D365.mbot
|

<Any folder>  
│
└───Input Folder
|		└───AP Input**
|		└───AP Output
|			└───PO
|				└───Extract
|				└───Success**
|			└───XPO
|				└───Extract
|				└───Success**
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
			<td><h4>Vendor mapping file.xlsx</h4></td>
			<td>Mapping file source for the non PO use case.</td>
			<td rowspan="2"><em>c-mapFilePath</em></td>
		</tr>
		<tr>
		<tr>
			<td><h4>My Tasks</h4></td>
			<td>Default directory where Bot Files are saved.</td>
			<td rowspan="2"><em>c-taskBotPath</em></td>
		</tr>
		<tr>
			<td><h4>AP Automation</h4></td>
			<td>Base folder contains files and folders needed for the bot execution.</td>
		</tr>
		<tr>
			<td><h4>assets</h4></td>
			<td>Contains client side scripting and static files that was used by bot execution.</td>
			<td><em>c-assetsFolder</em></td>
		</tr>
		<tr>
			<td><h4>AP PO.atmx</h4></td>
			<td rowspan="4">Contains all the developed platform source code</td>
			<td rowspan="4"></td>
		</tr>
		<tr>
			<td><h4>AP XPO.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>AP.atmx</h4></td>
		</tr>
			<tr>
			<td><h4>AP.CONF.atmx</h4></td>
		</tr>
		<tr>
			<td><h4>My MetaBots</h4></td>
			<td rowspan="2">Contains the developed Metabots needed for the bot execution.</td>
			<td rowspan="2"></td>
		</tr>
		<tr>
			<td><h4>AP-AUTO-D365.mbot</h4></td>
		</tr>
	<tr>
			<td><h4>Input Folder</h4></td>
			<td>Contains input files that the bot needs for execution of the use case.</td>
			<td rowspan="2"></td>
		</tr>
		<tr>
			<td><h4>AP Input**</h4></td>
			<td><b>Symbolic link</b> from the AP Automation file server <b>\\NGC-FILESERVER\AA-RPA\AP AUTO</b></td>
		</tr>
		<tr>
			<td><h4>AP Output</h4></td>
			<td>Contains output files generated by bot</td>
			<td></td>
		</tr>
			<tr>
			<td><h4>PO</h4></td>
			<td rowspan="2">PO specific output</td>
			<td></td>
		</tr>
		<tr>
			<td><h4>Extract</h4></td>
			<td>c-outputDest</td>
		</tr>
			<tr>
			<td><h4>Success**</h4></td>
			<td><b>Symbolic link</b> to the IQ Bot output at <b>\\NGC-SVR-0176-V\..\{INSTANCE}\Success</b></td>
			<td>c-inputSrc</td>
		</tr>
		</tr>
			<tr>
			<td><h4>XPO</h4></td>
			<td rowspan="2">Non PO specific output</td>
			<td></td>
		</tr>
		<tr>
			<td><h4>Extract</h4></td>
			<td>c-outputDest</td>
		</tr>
			<tr>
			<td><h4>Success**</h4></td>
			<td><b>Symbolic link</b> to the IQ Bot output at <b>\\NGC-SVR-0176-V\..\{INSTANCE}\Success</b></td>
			<td>c-inputSrc</td>
		</tr>
		<tr>
			<td><h4>Log Folder</h4></td>
			<td rowspan="4">Contains logs and snapshots of screens if something goes wrong with the bot during execution</td>
			<td><em>c-logFolder</em></td>
		</tr>
		<tr>
			<td><h4>Snapshot</h4></td>
			<td></td>
		</tr>
		<tr>
			<td><h4>log-fail.txt</h4></td>
			<td><em>c-logFail</em></td>
		</tr>
		<tr>
			<td><h4>log-success.txt</h4></td>
			<td><em>c-logSuccess</em></td>
		</tr>
	</tbody>
</table>

### Symbolic linking 
[Definition](https://en.wikipedia.org/wiki/Symbolic_link). 

Basic usage as describe below. Consider to look at the documentation for the advance usage.

```bash
# bash
ln -s [OPTIONS] [source_file] [symbolic_link]

# link with IQ Bot output folder "Success"
ln -s \\NGC-SVR-0176-V\..\{INSTANCE}\Success D:\AP-Output\PO\Success
```

```batch
:: cmd prompt
mklink [OPTIONS] <link> <target>

:: link with IQ Bot output folder "Success"
mklink /d D:\AP-Output\PO\Success \\NGC-SVR-0176-V\..\{INSTANCE}\Success
```

## Quick Start
### 1. Setup
No additional setup is required.

### 2. Configuration
The bot required valid parameters to be parse down the sub-task before start execution. An exception will be triggered if incorrect value has been detected. Configuration file can be configured at:
> **AA Application Path** > config-ap.txt

Below is a table that summaries what the variable name is, what it does, and an example of the input & output:
|Variable name|Type|Required|Purpose|Example input| 
|--|:--:|:--:|--|--|
|c-assetsFolder|text|yes|Assets folder|D:\AP-AUTO\assets|
|c-baseFolder|text|yes|Working based folder that reside required resources|D:\AP-AUTO|
|c-D365AUTHpath|url|yes|D365 authentication gateway|https://adfs.hartalega.com.my/adfs/oauth2/authorize/|
|c-D365LIVEpath|url|yes|D365 Live url|https://ax.d365live.hartalega.com.my/namespaces/AXSF/|
|c-D365UATpath|url|yes|D365 UAT url|https://ax-d365.hartalega.com.my/namespaces/AXSF/|
|c-environment|text|yes|Environment selector|UAT|
|c-inputSrc|text|yes|Input resource from the IQ Bot success folder|AP-Output\{inv}\Success|
|c-logFolder|text|yes|Log folder|D:\LOGS|
|c-logFail|text|yes|Fail log name|log-fail.txt|
|c-logSuccess|text|yes|Success log name|log-success.txt|
|c-mapFilePath|text|yes|Mapping source location|AP-Output\XPO\Vendor mapping file.xlsx|
|c-maxHeaderTry|number|yes|Retry counter for header processing|2|
|c-maxLineTry|number|yes|Retry counter for lineprocessing|3|
|c-outputDest|text|yes|Output resource after processed|AP-Output\{inv}\Extract|
|c-taskBotPath|text|yes|Base task bot location on the machine |Automation Anywhere\My Tasks\Workspace\AP Automation|
|c-scCleanUp|text|yes|Sync resources script between IQ Bot and main bot|Scripts\CleanUp.vbs|
|c-scCreateCsv|text|yes|Copy file from IQ Bot resources, build SQL schema used and backup|Scripts\CreateCsv.vbs|
|c-scFormatDate|text|yes|Date formatting|Scripts\FormatDate.vbs|
|c-scLineCount|text|yes|Count lines records|Scripts\LineCount.vbs|
|c-scRegexReplace|text|yes|Match records substrings and replace accordingly|Scripts\RegExReplace.vbs|

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
 - Processed invoice details

Error Logs will contain the below information -
 - Generated timestamp
 - Error description
 - Failed invoice details
