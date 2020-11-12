Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objConnection = CreateObject("ADODB.Connection")
Set objRecordSet = CreateObject("ADODB.Recordset")

basePath = objFSO.GetAbsolutePathName(Wscript.Arguments.Item(0))
csvPath = Wscript.Arguments.Item(1)
custRef = Wscript.Arguments.Item(2)
poNo = Wscript.Arguments.Item(3)

objConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;" & _
                   "Data Source=" & basePath & ";" & _
                   "Extended Properties=""text;HDR=YES;IMEX=1;FMT=Delimited"""

query = "SELECT COUNT(*) AS cnt " & _
		"FROM [" & csvPath & "] " & _
		"WHERE [Customer reference] = " & "'" & custRef & "' " & _
		"AND [PO number] = " & "'" & poNo & "' "
		
objRecordset.Open query, objConnection

Do Until objRecordset.EOF
    WScript.StdOut.WriteLine objRecordset.Fields.Item("cnt")
    objRecordset.MoveNext
Loop