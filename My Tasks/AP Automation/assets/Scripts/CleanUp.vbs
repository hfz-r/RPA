includeFile "\\HSB-SVR-0238-V\d$\AP-AUTO\assets\Scripts\Helper.vbs"

Set clsHelper = New Helper
clsHelper.SetSrcFile = WScript.Arguments.Item(0)
clsHelper.CleanUp

Sub includeFile(fSpec)
    With CreateObject("Scripting.FileSystemObject")
       executeGlobal .openTextFile(fSpec).readAll()
    End With
End Sub