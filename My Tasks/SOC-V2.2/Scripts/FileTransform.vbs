Option Explicit 

' 1=Read
' 2=write
' 8=Append
Const IOMode = 8
' Normal=0
' ReadOnly=1
' Hidden=2
Const CHidden = 2

Dim objFSO
Dim objSchema
Dim basePath, baseCsvWfPath, baseCsvPoPath

Set objFSO = CreateObject("Scripting.FileSystemObject")

basePath = objFSO.GetAbsolutePathName(WScript.Arguments.Item(0))
baseCsvWfPath = basePath & "\wf"
baseCsvPoPath = basePath & "\po"

' prepare infrastructure
Prepare
' process files
Init objFSO.GetFolder(basePath)

Sub Prepare()
    ' build folder
    InitFolder basePath
    InitFolder baseCsvWfPath
    InitFolder baseCsvPoPath
    ' build schema
    InitSchema baseCsvWfPath & "\Schema.ini"
    InitSchema baseCsvPoPath & "\Schema.ini"
End Sub

Sub Init(objFolder)
    Dim objFile

    For Each objFile In objFolder.Files
        If LCase(objFSO.GetExtensionName(objFile.Name)) = "xlsx" Then
            InitWF objFile
        ElseIf LCase(objFSO.GetExtensionName(objFile.Name)) = "csv" Then
            InitPO objfile
        End If
    Next
End Sub

Sub InitFolder(objFolder)
    If Not objFSO.FolderExists(objFolder) Then
        objFSO.CreateFolder objFolder
    End If
End Sub

Sub InitSchema(objSchema)
	If Not objFSO.FileExists(objSchema) Then
		objFSO.CreateTextFile objSchema, True
		
		Dim outFile
		Set outFile = objFSO.GetFile(objSchema)
		outFile.Attributes = CHidden
    End If     
End Sub

Sub InitWF(objFile)
    Dim fileName : fileName = CreateFilename(objFile)
    ' tranform wf to csv
    CreateCsv fileName
    ' create schema
    Set objSchema = objFSO.OpenTextFile(baseCsvWfPath & "\Schema.ini", IOMode, True)
    objSchema.WriteLine(CreateWfSchema(objFSO.GetBaseName(fileName) & ".csv"))
    objSchema.Close()
	Set objSchema = Nothing
End Sub

Sub InitPO(objFile)
    Dim fileName : fileName = CreateFilename(objFile)
    ' copy valid csv
    objFSO.MoveFile objFile, baseCsvPoPath & "\" & fileName
    ' create schema
    Set objSchema = objFSO.OpenTextFile(baseCsvPoPath & "\Schema.ini", IOMode, True)
    objSchema.WriteLine(CreatePoSchema(fileName))
    objSchema.Close()
	Set objSchema = Nothing
End Sub

Sub CreateCsv(fileName)
    Const CsvFormat = 6
	Const UseLocal = True

    Dim objExcel, objBook
    Dim srcFile, destFile

    Set objExcel = CreateObject("Excel.Application")

    objExcel.DisplayAlerts = False
    objExcel.Visible = False

    srcFile = basePath & "\" & fileName
    destFile = baseCsvWfPath & "\" & objFSO.GetBaseName(fileName) & ".csv"

    Set objBook = objExcel.Workbooks.Open(srcFile)

	Call objBook.SaveAs(destFile, CsvFormat, 0, 0, 0, 0, 0, 0, 0, 0, 0, UseLocal) 

	objFSO.DeleteFile srcFile
    
	objBook.Close False
    objExcel.Quit
End Sub

Function CreateWfSchema(fileName)
    Dim title, options, body

    title = "[" & fileName & "]"

    options = "ColNameHeader=True" & vbCrLf _
              & "Format=CSVDelimited" & vbCrLf _
              & "DateTimeFormat=dd/MM/yyyy" 
              
    body = "Col1=""System"" Text" & vbCrLf _
           & "Col2=""Customer Name"" Text" & vbCrLf _
           & "Col3=""AX4 Customer account"" Text" & vbCrLf _
           & "Col4=""D365 Customer account"" Text" & vbCrLf _
           & "Col5=""Customer Requested Ship date"" DateTime" & vbCrLf _
           & "Col6=""PO Document Date"" DateTime" & vbCrLf _
           & "Col7=""PO Received Date"" DateTime" & vbCrLf _
           & "Col8=""PO number"" Text" & vbCrLf _
           & "Col9=""Customer reference"" Text" & vbCrLf _
           & "Col10=""Mode of delivery"" Text" & vbCrLf _
           & "Col11=""Delivery Terms"" Text" & vbCrLf _
           & "Col12=""Container Type"" Text" & vbCrLf _
           & "Col13=""Shipping Agent"" Text" & vbCrLf _
           & "Col14=""AX4_Customer Instruction"" Text" & vbCrLf _
           & "Col15=""D365_Customer Instruction"" Text" & vbCrLf _
           & "Col16=""Shipping / Source port"" Text" & vbCrLf _
           & "Col17=""Destination port"" Text" & vbCrLf _
           & "Col18=""AX4 FG Code"" Text" & vbCrLf _
           & "Col19=""D365 FG Code"" Text" & vbCrLf _
           & "Col20=""Size"" Text" & vbCrLf _
           & "Col21=""Quantity"" Short" & vbCrLf _
           & "Col22=""Unit"" Text"
    
    CreateWfSchema = title & vbCrLf & options & vbCrLf & body & vbCrLf
End Function 

Function CreatePoSchema(fileName)
    Dim title, options, body

    title = "[" & fileName & "]"

    options = "ColNameHeader=True" & vbCrLf _
              & "Format=CSVDelimited" & vbCrLf _
              & "DateTimeFormat=dd/MM/yyyy" 

    body = "Col1=""Purchase_Order_Date"" DateTime" & vbCrLf _
           & "Col2=""PO number"" Text" & vbCrLf _
           & "Col3=""Company_name"" Text" & vbCrLf _
           & "Col4=""Requested_Shipped_Date"" DateTime" & vbCrLf _
           & "Col5=""item_description"" Text" & vbCrLf _
           & "Col6=""Custom Quantity"" Short" & vbCrLf _
           & "Col7=""Item_Number"" Text" & vbCrLf _
           & "Col8=""Unit_of_Measure"" Text" & vbCrLf _
           & "Col9=""Custom Size"" Text" & vbCrLf _
           & "Col10=""Material_No"" Text" & vbCrLf _
           & "Col11=""Result"" Text" & vbCrLf _
           & BodySelector

    CreatePoSchema = title & vbCrLf & options & vbCrLf & body & vbCrLf
End Function

Function BodySelector()
	Dim baseName, AX4body, D365body
		
	AX4body = "Col12=""AX4 Customer account"" Text" & vbCrLf _
		   & "Col13=""Customer reference"" Text" & vbCrLf _
           & "Col14=""AX4 FG Code"" Text" & vbCrLf _
           & "Col15=""Size"" Text" & vbCrLf _
           & "Col16=""Actual Unit"" Text" & vbCrLf _
           & "Col17=""Base Quantity"" Short" & vbCrLf _
           & "Col18=""Gloves Inner box No"" Short" & vbCrLf _
           & "Col19=""Inner box in Case No"" Short" & vbCrLf _
           & "Col20=""Quantity"" Short" & vbCrLf _
           & "Col21=""Prefix of PO number"" Short"
	
	D365body = "Col12=""Customer reference"" Text" & vbCrLf _
           & "Col13=""D365 FG Code"" Text" & vbCrLf _
           & "Col14=""Size"" Text" & vbCrLf _
           & "Col15=""Actual Unit"" Text" & vbCrLf _
           & "Col16=""Base Quantity"" Short" & vbCrLf _
           & "Col17=""Gloves Inner box No"" Short" & vbCrLf _
           & "Col18=""Inner box in Case No"" Short" & vbCrLf _
           & "Col19=""Quantity"" Short" & vbCrLf _
           & "Col20=""Prefix of PO number"" Short"
	
	baseName = objFSO.GetBaseName(WScript.Arguments.Item(0))

	If baseName = "AX4" Then
		BodySelector = AX4body
	ElseIf baseName = "D365" Then
		BodySelector = D365body
	Else
		WScript.Echo("Unknown System")
	End If
End Function

Function CreateFilename(objFile)
    ' construct file name; "name.20.csv"/"name_123.csv" transform to 8.3 naming
	Dim condition : condition = InStr(objFSO.GetBaseName(objFile.Name), ".") Or _ 
		((Len(objFSO.GetBaseName(objFile.Name)) - Len(Replace(objFSO.GetBaseName(objFile.Name), " ", ""))) = 0)
    
    CreateFilename = IIf(condition, objFile.ShortName, objFile.Name)
End Function

Function IIf(bClause, sTrue, sFalse)
    If CBool(bClause) Then
        IIf = sTrue
    Else 
        IIf = sFalse
    End If
End Function