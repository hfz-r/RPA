Set objFSO = CreateObject("Scripting.FileSystemObject")

file = objFSO.GetAbsolutePathName(Wscript.Arguments.Item(0))
baseFile = objFSO.GetBaseName(file)
fileExt = LCase(objFSO.GetExtensionName(file))
parentDir = objFSO.GetParentFolderName(file)
archiveDir = parentDir & "\Archive"

If Not objFSO.FolderExists(archiveDir) Then
	objFSO.CreateFolder(archiveDir)
End If

objFSO.MoveFile file, archiveDir & "\" & baseFile & "_" & timeStamp & "." & fileExt

Function timeStamp()
    Dim t : t = Now
    timeStamp = Year(t) & _
    Right("0" & Month(t),2) & _
    Right("0" & Day(t),2)  & "_" & _  
    Right("0" & Hour(t),2) & _
    Right("0" & Minute(t),2) & _    
    Right("0" & Second(t),2) 
End Function