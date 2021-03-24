Class Helper
	Private c_OverwriteExisting
	Private c_IOMode
	Private c_Hidden
	Private m_objFSO
	Private m_objFile
	Private m_objCsvFile
	Private m_objDestFolder
	Private m_objRegEx
	Private m_strAPState
	Private m_strBaseName
	Private m_strExtension
	Private m_strCsvName

	Private Sub Class_Initialize() 
		'const
		c_OverwriteExisting = True
		c_IOMode = 8
		c_Hidden = 2
		'initialize obj
		Set m_objFSO = CreateObject("Scripting.FileSystemObject")
		Set m_objRegEx = New RegExp
   	End Sub
   	
   	Private Sub Class_Terminate()
   		Set m_objFSO = Nothing
   		Set m_objFile = Nothing
   		Set m_objCsvFile = Nothing
   		Set m_objDestFolder = Nothing
   		Set m_objRegEx = Nothing
	End Sub 
	
	'private getter
	Private Property Get dtTimeStamp
		Dim t : t = Now
		dtTimeStamp = Year(t) & Right("0" & Month(t),2) & Right("0" & Day(t),2) & _ 
					  "_" & Right("0" & Hour(t),2) & Right("0" & Minute(t),2) & Right("0" & Second(t),2) 
	End Property
	
	'public setter
	Public Property Let SetSrcFile(file)
    	Set m_objFile = m_objFSO.GetFile(file)
   	End Property

	Public Property Let SetDestFolder(folder)
    	Set m_objDestFolder = m_objFSO.GetFolder(folder)
   	End Property
   	
   	Public Property Let SetRegexOptions(regEx)
   		m_objRegEx.Pattern = regEx.Pattern  
	   	m_objRegEx.IgnoreCase = regEx.IgnoreCase   
	   	m_objRegEx.Global = regEx.Global  
   	End Property
   	
   	Public Property Let SetContext(state)
   		m_strAPState = state
   	End Property
   	
   	'private setter
   	Private Property Let SetBaseName(filePath)
   		m_strBaseName = m_objFSO.GetBaseName(filePath)
   	End Property
   	
   	Private Property Let SetExtension(fileName)
   		m_strExtension = LCase(m_objFSO.GetExtensionName(fileName))
   	End Property
	
	Private Property Let SetCsvFile(file)
   		Set m_objCsvFile = m_objFSO.GetFile(file)
   		m_strCsvName = CreateFilename
   	End Property
	
	'public method
	Public Sub PrepFile
		SetBaseName = m_objFile
		SetExtension = m_objFile.Name
		If m_strExtension = "csv" Then
			strName = RegExReplace(m_strBaseName, "", "(.*\W_)*(\.[pdf]+)*")
			CopyArchive m_objFile.Path, strName & "." & m_strExtension, strName & "_" & dtTimeStamp & "." & m_strExtension
			CreateCsv strName
			WScript.StdOut.Write m_strCsvName
		End If
	End Sub
	
	Public Sub CleanUp()
		SetBaseName = m_objFile
		SetExtension = m_objFile.Name
		SetDestFolder = m_objFSO.GetParentFolderName(m_objFile)
		m_objFSO.MoveFile m_objFile, m_objDestFolder & "\Archive\" & m_strBaseName & "_" & dtTimeStamp & "." & m_strExtension
	End Sub
	
	Public Function RegExReplace(strSource, strReplaceTxt, strPattern)
		m_objRegEx.Pattern = strPattern   
	   	RegExReplace = m_objRegEx.Replace(strSource, strReplaceTxt)
	End Function
	
	Public Function RegExMatch(strSource, strPattern)
		m_objRegEx.Pattern = strPattern
		Set Matches = m_objRegEx.Execute(strSource)
		'get match value
		For Each Match in Matches
			RetStr = Match.Value
		Next
		RegExMatch = RetStr
	End Function
	
	'private method
	Private Sub CopyArchive(strSource, strName, strArcName)
		m_objFSO.CopyFile strSource, m_objDestFolder & "\" & strName, c_OverwriteExisting
		strParentFolder = m_objFSO.GetParentFolderName(strSource)
		m_objFSO.MoveFile strSource, strParentFolder & "\Archive\" & strArcName
	End Sub
	
	Private Sub CreateCsv(strName)
		InitSchema m_objDestFolder & "\Schema.ini"
		'create csv+replace
		SetCsvFile = m_objDestFolder & "\" & strName & "." & m_strExtension
		m_objFSO.MoveFile m_objCsvFile, m_objDestFolder & "\" & m_strCsvName
		'create csv+schema
		Set objSchema = m_objFSO.OpenTextFile(m_objDestFolder & "\Schema.ini", c_IOMode, True)
	    objSchema.WriteLine(CreateSchema(m_strCsvName))
	    objSchema.Close()
		Set objSchema = Nothing
	End Sub
	
	Private Sub InitSchema(strSchema)
		If Not m_objFSO.FileExists(strSchema) Then
			m_objFSO.CreateTextFile strSchema, True
			Set outFile = m_objFSO.GetFile(strSchema)
			outFile.Attributes = c_Hidden
	    End If     
	End Sub
	
	'transform to 8.3 naming
	Private Function CreateFilename()
		strBaseName = m_objFSO.GetBaseName(m_objCsvFile.Name)
		blnCondition = InStr(strBaseName, ".") Or ((Len(strBaseName) - Len(Replace(strBaseName, " ", ""))) = 0)
	    CreateFilename = IIf(blnCondition, RegExReplace(m_objCsvFile.ShortName, "csv", "(csv)"), m_objCsvFile.Name)
	End Function
	
	Private Function CreateSchema(strFileName)
	 	title = "[" & strFileName & "]"
	
	    options = "ColNameHeader=True" & vbCrLf _
	              & "Format=CSVDelimited" & vbCrLf _
	              & "DateTimeFormat=dd/MM/yyyy" 
	    
	    CreateSchema = title & vbCrLf & options & vbCrLf & SetSchemaBody & vbCrLf
	End Function
	
	Private Function SetSchemaBody()
		Dim body
		If m_strAPState = "PO" Then
			body = "Col1=""InvDt"" DateTime" & vbCrLf _ 
				& "Col2=""InvNo"" Text" & vbCrLf _
	           	& "Col3=""PONo"" Text" & vbCrLf _
				& "Col4=""InvTot"" Text" & vbCrLf _
			   	& "Col5=""DONo"" Text" & vbCrLf _
	           	& "Col6=""ItemDesc"" Text" & vbCrLf _
	           	& "Col7=""Qty"" Short" & vbCrLf _
	           	& "Col8=""ItemNo"" Text" & vbCrLf _
	           	& "Col9=""ItemPrice"" Text" & vbCrLf _
	       	   	& "Col10=""Result"" Text"
		ElseIf m_strAPState = "XPO" Then
			body = "Col1=""InvDt"" DateTime" & vbCrLf _ 
				& "Col2=""InvNo"" Text" & vbCrLf _
	           	& "Col3=""VendorName"" Text" & vbCrLf _
				& "Col4=""InvTot"" Text" & vbCrLf _
			   	& "Col5=""Tax"" Text" & vbCrLf _
	           	& "Col6=""Result"" Text"
		End If
		SetSchemaBody = body
	End Function

	Private Function IIf(bClause, sTrue, sFalse)
	    If CBool(bClause) Then
	        IIf = sTrue
	    Else 
	        IIf = sFalse
	    End If
	End Function
End Class