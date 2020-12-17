Dim fso

Set stdOut = WScript.StdOut
Set fso = WScript.CreateObject("Scripting.Filesystemobject")
Set folder = fso.GetFolder(WScript.Arguments.Item(0))

If fso.FolderExists(folder) Then
	If WScript.Arguments.Count > 1 And WScript.Arguments.Item(1) = "*" Then
		cnt = IIf((folder.Files.Count > 0), folder.Files.Count, RecursiveCount(folder.SubFolders))
		stdOut.WriteLine(cnt)
	Else
		stdOut.WriteLine(folder.Files.Count)
	End If
End If

Function RecursiveCount(folders)
	Dim cnt: cnt = 0
	For Each subfolder In folders
		For Each file In subfolder.Files
			If LCase(fso.GetExtensionName(file.Name)) = "csv" Then
				cnt = cnt + 1
			End If
		Next
		If cnt > 0 Then
			Exit For
		End If
  	Next
	RecursiveCount = cnt
End Function

Function IIf(bClause, sTrue, sFalse)
    If CBool(bClause) Then
        IIf = sTrue
    Else 
        IIf = sFalse
    End If
End Function

Set fso = Nothing