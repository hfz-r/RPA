Const Color = "#f9f9f9"

Dim HtmlClass, HtmlStyle
HtmlClass = "class=" & chr(34) & "{0}" & chr(34)
HtmlStyle = "style=" & chr(34) & "box-sizing:border-box;line-height:0;padding:0;{0}" & chr(34)

If WScript.Arguments.Item(0) Mod 2 = 0 Then
	WScript.StdOut.WriteLine(Replace(HtmlClass, "{0}", "") & " " & Replace(HtmlStyle, "{0}", ""))
Else
	WScript.StdOut.WriteLine(Replace(HtmlClass, "{0}", "grey-bg") & " " & _
		Replace(HtmlStyle, "{0}", "background-color:" & Color & ";") & " " & _
		"bgcolor=" & chr(34) & Color & chr(34))
End If