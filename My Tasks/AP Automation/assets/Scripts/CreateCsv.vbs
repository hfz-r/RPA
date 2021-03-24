includeFile "\\HSB-SVR-0238-V\d$\AP-AUTO\assets\Scripts\Helper.vbs"

Set clsHelper = New Helper
clsHelper.SetSrcFile = WScript.Arguments.Item(0)
clsHelper.SetDestFolder = WScript.Arguments.Item(1)
clsHelper.SetContext = WScript.Arguments.Item(2)

Set regEx = New RegExp
regEx.IgnoreCase = True   
regEx.Global = True  
clsHelper.SetRegexOptions = regEx

clsHelper.PrepFile

Sub includeFile(fSpec)
    With CreateObject("Scripting.FileSystemObject")
       executeGlobal .openTextFile(fSpec).readAll()
    End With
End Sub
