includeFile "\\HSB-SVR-0238-V\d$\AP-AUTO\assets\Scripts\Helper.vbs"

Set clsHelper = New Helper
Set regEx = New RegExp
regEx.IgnoreCase = True   
regEx.Global = True
clsHelper.SetRegexOptions = regEx

WScript.StdOut.Write clsHelper.RegExReplace(WScript.Arguments.Item(0), WScript.Arguments.Item(1), WScript.Arguments.Item(2))

Sub includeFile(fSpec)
    With CreateObject("Scripting.FileSystemObject")
       executeGlobal .openTextFile(fSpec).readAll()
    End With
End Sub