' codes comparison
'
' " " 32  a 97  z 122
' ä 223  ö 228  ß 246  ü 252

#Include "windows.bi"

Type huff
  As Integer h,l,r,u		' freq, left, right, up
End Type

Dim Shared As huff mem(64)
Dim Shared As Integer memn, memmax, nchr
Dim Shared As Integer cnt(256), nb


Declare Sub main
main
End


Sub myPrint (a As String)
	CharToOem a,a
	Print a;
End Sub


Function mylcase (c As String) As String
	Dim As Integer a

	a = Asc(c)
	If a>=65 And a<=90 Then c=LCase(c)
	If c="Ä" Then c="ä"
	If c="Ö" Then c="ö"
	If c="Ü" Then c="ü"
	Return c
End Function


Sub initmem ()
	Dim As Integer n, t

	For n = 1 To 64
		mem(n).h = memmax : mem(n).l = 0 : mem(n).r = 0 : mem(n).u = 0
	Next

	n = 1
	For t = 97 To 122
		mem(n).h = cnt(t) : mem(n).l = t : mem(n).r = 0 : n+=1
	Next
	t =  32 : mem(n).h = cnt(t) : mem(n).l = t : mem(n).r = 0 : n+=1
	t = 223 : mem(n).h = cnt(t) : mem(n).l = t : mem(n).r = 0 : n+=1
	t = 228 : mem(n).h = cnt(t) : mem(n).l = t : mem(n).r = 0 : n+=1
	t = 246 : mem(n).h = cnt(t) : mem(n).l = t : mem(n).r = 0 : n+=1
	t = 252 : mem(n).h = cnt(t) : mem(n).l = t : mem(n).r = 0 : n+=1
	memn = n
	nchr = n-1

	nb = 0
	For n = 1 To memn-1
		nb += mem(n).h
	Next
End Sub


Function index (a As String) As Integer
	Dim As Integer t
	For t = 1 To nchr
		If mem(t).l=Asc(a) Then Return t
	Next
	Return 0
End Function


Sub main()
	Dim As String c, code(32)
	Dim As Integer bytes, t, a, n, m, n1, n2, s

	Open "testtext.txt" For Binary Access Read As #1

	c = " "
	Do
		Get #1,,c,,bytes
		If bytes=0 Then Exit Do
		c = mylcase(c)
		a = Asc(c)
		cnt(a) += 1
		t += 1
	Loop
	memmax = t*2
	Close #1

	initmem ()

	Do
		m = memmax : n1 = 0
		For n = 1 To 64
			If mem(n).h<m Then m = mem(n).h : n1 = n
		Next
		m = memmax : n2 = 0
		For n = 1 To 64
			If n<>n1 And mem(n).h<m Then m = mem(n).h : n2 = n
		Next
		'Print n1,n2,mem(n1).h,mem(n2).h
		If n2=0 Then Exit Do

		n = memn
		mem(n).h = mem(n1).h + mem(n2).h
		mem(n).l = n1
		mem(n).r = n2
		mem(n1).h = memmax : mem(n1).u = n
		mem(n2).h = memmax : mem(n2).u = n
		memn += 1
		If memn>64 Then Print "fehler!" : Exit Do
	Loop

	'Print memn,mem(memn-1).h

	a = 0
	For t = 1 To nchr
		c = ""
		n = t
		Do
			m = mem(n).u
			If m=0 Then Exit Do
			If n=mem(m).l Then c = "1"+c
			If n=mem(m).r Then c = "0"+c
			n = m
		Loop

		a += Len(c)*cnt(mem(t).l)
		myPrint Chr(mem(t).l) : Print "  ";c
		code(t) = c
	Next
	Print Using "huffman: ###### ###### #.###";a;nb;a/nb
	Print
	initmem ()


	For t = 1 To nchr
		c = ""
		For n = 0 To 4
			If t And (1 Shl n) Then c += "1" Else c += "0"
		Next
		code(t) = c
	Next

	a = 0
	For t = 1 To nchr
		myPrint Chr(mem(t).l)
		Print "  ";code(t)
		a += Len(code(t))*mem(t).h
	Next
	Print Using "5 bit: ###### ###### #.###";a;nb;a/nb
	Print


	code(index(" ")) = "  "
	code(index("a")) = "...."
	code(index("b")) = ".... ."
	code(index("c")) = ".. . ."
	code(index("d")) = "... . "
	code(index("e")) = ". "
	code(index("f")) = "... .."
	code(index("g")) = ". . .."
	code(index("h")) = ". . . "
	code(index("i")) = ". . "
	code(index("j")) = ".. .. . "
	code(index("k")) = ". ...."
	code(index("l")) = ".. .. "
	code(index("m")) = ". .. ."
	code(index("n")) = ".."
	code(index("o")) = "..... "
	code(index("p")) = ". . . . "
	code(index("q")) = ".. . .. "
	code(index("r")) = "... "
	code(index("s")) = ".. ."
	code(index("t")) = ". .."
	code(index("u")) = ". ... "
	code(index("v")) = ". .. .. "
	code(index("w")) = ".. ..."
	code(index("x")) = ". . .. ."
	code(index("y")) = ". .. . ."
	code(index("z")) = "......"
	code(index("ä")) = "... . . "
	code(index("ö")) = ". . . .."
	code(index("ü")) = ". ... . "
	code(index("ß")) = ". . ... "

	a = 0
	For t = 1 To nchr
		myPrint Chr(mem(t).l)
		Print "  ";code(t)
		a += (Len(code(t))+2)*mem(t).h
	Next
	Print Using "tapcode: ###### ###### #.###";a;nb;a/nb
	Print


	code(index("a")) = ". --- "
	code(index("b")) = "--- . . . "
	code(index("c")) = "--- . --- . "
	code(index("d")) = "--- . . "
	code(index("e")) = ". "
	code(index("f")) = ". . --- . "
	code(index("g")) = "--- --- . "
	code(index("h")) = ". . . . "
	code(index("i")) = ". . "
	code(index("j")) = ". --- --- --- "
	code(index("k")) = "--- . --- "
	code(index("l")) = ". --- . . "
	code(index("m")) = "--- --- "
	code(index("n")) = "--- . "
	code(index("o")) = "--- --- --- "
	code(index("p")) = ". --- --- . "
	code(index("q")) = "--- --- . --- "
	code(index("r")) = ". --- . "
	code(index("s")) = ". . . "
	code(index("t")) = "--- "
	code(index("u")) = ". . --- "
	code(index("v")) = ". . . --- "
	code(index("w")) = ". --- --- "
	code(index("x")) = "--- . . --- "
	code(index("y")) = "--- . --- --- "
	code(index("z")) = "--- --- . . "
	code(index(" ")) = "    "
	code(index("ä")) = code(index("a"))+code(index("e"))
	code(index("ö")) = code(index("o"))+code(index("e"))
	code(index("ü")) = code(index("u"))+code(index("e"))
	code(index("ß")) = code(index("s"))+code(index("s"))

	a = 0
	For t = 1 To nchr
		myPrint Chr(mem(t).l)
		Print "  ";code(t)
		a += (Len(code(t))+2)*mem(t).h
	Next
	Print Using "morse code: ###### ###### #.### #.###";a;nb;a/nb;a/nb/2
	Print


	code(index("a")) = ". . "
	code(index("b")) = ". .. "
	code(index("c")) = ". ... "
	code(index("d")) = ". .... "
	code(index("e")) = ". ..... "
	code(index("f")) = ".. . "
	code(index("g")) = ".. .. "
	code(index("h")) = ".. ... "
	code(index("i")) = ".. .... "
	code(index("j")) = ".. ..... "
	code(index("k")) = code(index("c"))
	code(index("l")) = "... . "
	code(index("m")) = "... .. "
	code(index("n")) = "... ... "
	code(index("o")) = "... .... "
	code(index("p")) = "... ..... "
	code(index("q")) = ".... . "
	code(index("r")) = ".... .. "
	code(index("s")) = ".... ... "
	code(index("t")) = ".... .... "
	code(index("u")) = ".... ..... "
	code(index("v")) = "..... . "
	code(index("w")) = "..... .. "
	code(index("x")) = "..... ... "
	code(index("y")) = "..... .... "
	code(index("z")) = "..... ..... "
	code(index(" ")) = " "
	code(index("ä")) = code(index("a"))+code(index("e"))
	code(index("ö")) = code(index("o"))+code(index("e"))
	code(index("ü")) = code(index("u"))+code(index("e"))
	code(index("ß")) = code(index("s"))+code(index("s"))

	a = 0
	For t = 1 To nchr
		myPrint Chr(mem(t).l)
		Print "  ";code(t)
		a += (Len(code(t))+1)*mem(t).h
	Next
	Print Using "polybius: ###### ###### #.###";a;nb;a/nb
	Print


	code(index(" ")) = " "
	code(index("e")) = ". . "
	code(index("n")) = ". .. "
	code(index("i")) = ".. . "
	code(index("r")) = ". ... "
	code(index("s")) = ".. .. "
	code(index("t")) = "... . "
	code(index("a")) = ". .... "
	code(index("h")) = ".. ... "
	code(index("d")) = "... .. "
	code(index("l")) = ".... . "
	code(index("u")) = ". ..... "
	code(index("c")) = ".. .... "
	code(index("m")) = "... ... "
	code(index("g")) = ".... .. "
	code(index("o")) = "..... . "
	code(index("b")) = ". ...... "
	code(index("f")) = ".. ..... "
	code(index("w")) = "... .... "
	code(index("k")) = ".... ... "
	code(index("z")) = ".... ... "
	code(index("p")) = "..... .. "
	code(index("v")) = "...... . "
	code(index("ä")) = ". ....... "
	code(index("ü")) = ".. ...... "
	code(index("ß")) = "... ..... "
	code(index("ö")) = ".... .... "
	code(index("j")) = "..... ... "
	code(index("x")) = "...... .. "
	code(index("y")) = "....... . "
	code(index("q")) = ". ........ "

	a = 0
	For t = 1 To nchr
		myPrint Chr(mem(t).l)
		Print "  ";code(t)
		a += (Len(code(t))+1)*mem(t).h
	Next
	Print Using "polybius opti: ###### ###### #.###";a;nb;a/nb
	Print


	Sleep
End Sub
