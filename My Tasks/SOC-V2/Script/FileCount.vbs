Dim fso
Set fso = WScript.CreateObject("Scripting.Filesystemobject")
Set folder = fso.GetFolder(WScript.Arguments.Item(0))

If fso.FolderExists(folder) Then
	WScript.StdOut.WriteLine(folder.Files.Count)
End If

Set fso = Nothing