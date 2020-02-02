*!*	Author: Luiz H. Bosse / Ivan Sansão
*!*	Creation: 08/06/2016

**** ATENÇÃO *** As funções dentro desse arquivo não podem ter dependências de outros arquivos do FoxPro.

***********
Function ok
***********
	* Retorna verdadeiro caso o valor passado for válido.
	* Observação: Número é tratado como boolean.
	Parameters Arg
	
	local argType
	argType = Vartype(arg)

	Do Case
	Case IsNull(Arg) && Essa tem que ser por primeiro!
		return .F.
	Case argType = "N"
		return Arg > 0		
	Case argType = "L"		
		return Arg
	Case argType = "C"
		return !Empty(Arg)
	Case argType = "D"		
		return !Empty(Arg)		
	Case argType = "T"
		return !Empty(Arg)
	EndCase
	
	return .F.	

endFunc

***************
Function Valido
***************
	* Objetivo: Analizar o valor verdade que é passado.
	* Pars: <Valor verdade> 	
	* 			- (Para numérico): Valor diferente de zero retorna verdadeiro.
	* 			- (Para caracter): String em branco retorna verdadeiro.
	* 			- (Para data): Data em branco retorna verdadeiro.	
	* 			- (Para Lógico (VFP)): Valor nativo retorna valor nativo.
	*		[<Assumir número como valor boleano?>]
	* Retorno: .T. Caso for verdadeiro, .F. caso for falso.
	
	Parameters Arg, assumirNumBoleano

	Local rVer
	rVer = .F.
	
	Do Case
	
		Case IsNull(Arg)
			rVer = .F.
		Case Type( "Arg" ) == "N"	
		
			* Se assumir número como valor boleano.
			If assumirNumBoleano
			
				* Se número for positivo maior que zero.
				If Arg > 0
					* Retorna verdadeiro
					rVer = .T.
				EndIf
				
			Else					
				If Arg # 0
					rVer = .T.
				EndIf	
				
			EndIf
			
		Case Type( "Arg" ) == "C"
			rVer = !Empty(Arg)
		Case Type( "Arg" ) == "D"		
			rVer = !Empty(Arg)		
		Case Type( "Arg" ) == "T"
			rVer = !Empty(Arg)		
		Case Type( "Arg" ) == "L"
			
			If IsNull( Arg )
				rVer = .F.
			Else
				rVer = Arg
			EndIf	
					
	EndCase
	
	Return( rVer )

EndFunc

***************
Function concat
***************
	Parameters cp1,cp2,cp3,cp4,cp5,cp6,cp7,cp8,cp9,cp10,cp11,cp12,cp13,cp14,cp15,cp16,cp17,cp18,cp19,cp20,cp21,cp22,cp23,cp24,cp25,cp26,cp27,cp28,cp29,cp30,cp31,cp32,cp33,cp34,cp35,cp36,cp37,cp38,cp39,cp40,cp41,cp42,cp43,cp44,cp45,cp46,cp47,cp48,cp49,cp50,cp51,cp52,cp53,cp54,cp55,cp56,cp57,cp58,cp59,cp60,cp61,cp62,cp63,cp64,cp65,cp66,cp67,cp68,cp69,cp70,cp71,cp72,cp73,cp74,cp75,cp76,cp77,cp78,cp79,cp80,cp81,cp82,cp83,cp84,cp85,cp86,cp87,cp88,cp89,cp90,cp91,cp92,cp93,cp94,cp95,cp96,cp97,cp98,cp99,cp100,cp101,cp102,cp103,cp104,cp105,cp106,cp107,cp108,cp109,cp110,cp111,cp112,cp113,cp114,cp115,cp116,cp117,cp118,cp119,cp120,cp121,cp122,cp123,cp124,cp125,cp126,cp127,cp128,cp129,cp130,cp131,cp132,cp133,cp134,cp135,cp136,cp137,cp138,cp139,cp140,cp141,cp142,cp143,cp144,cp145,cp146,cp147,cp148,cp149,cp150,cp151,cp152,cp153,cp154,cp155,cp156,cp157,cp158,cp159,cp160,cp161,cp162,cp163,cp164,cp165,cp166,cp167,cp168,cp169,cp170,cp171,cp172,cp173,cp174,cp175,cp176,cp177,cp178,cp179,cp180,cp181,cp182,cp183,cp184,cp185,cp186,cp187,cp188,cp189,cp190,cp191,cp192,cp193,cp194,cp195,cp196,cp197,cp198,cp199,cp200,cp201,cp202,cp203,cp204,cp205,cp206,cp207,cp208,cp209,cp210,cp211,cp212,cp213,cp214,cp215,cp216,cp217,cp218,cp219,cp220,cp221,cp222,cp223,cp224,cp225,cp226,cp227,cp228,cp229,cp230,cp231,cp232,cp233,cp234,cp235,cp236,cp237,cp238,cp239,cp240,cp241,cp242,cp243,cp244,cp245,cp246,cp247,cp248,cp249,cp250,cp251,cp252,cp253,cp254,cp255

	local iConcat, concatenado
	m.concatenado = ""
	
	for m.iConcat = 1 to Pcount()
		m.concatenado = m.concatenado +Transform(Evaluate("cp"+Alltrim(Str(m.iConcat))))
	endFor
	
	return m.concatenado		
endFunc


*******************
Function FolderTemp
*******************

	return Addbs(GetEnv("temp"))

endFunc

*****************
Function FileTemp
*****************
	* Retorna o endereço da pasta temporária do usuário + um nome de arquivo aleatório.
	* opcExt
	* opcPrefixo
	* opcSufixo
	Parameters opcExt, opcPrefixo, opcSufixo
	
	local filName
	
	filName = ""
	opcExt = Iif(varType(opcExt) != "C","",opcExt)
	opcPrefixo = Iif(varType(opcPrefixo) != "C","",opcPrefixo)
	opcSufixo = Iif(varType(opcSufixo) != "C","",opcSufixo)
	
	if ok(opcExt)
		opcExt = concat(".",opcExt)
	endIf
	
	if ok(opcSufixo)
		opcSufixo = concat("_",opcSufixo)
	endIf
	
	filName = Concat(FolderTemp(),opcPrefixo,Sys(2015),opcSufixo,opcExt)
	
	return filName

endFunc


****************
Function IsAdmin
****************
	* Informa se o executário está sendo executado como Administrador.

	local loAPI, lcVal
	 
	DECLARE INTEGER IsUserAnAdmin IN Shell32
	
	Try
	      lnResult = IsUserAnAdmin()
	Catch
	      *** OLD OLD Version of Windows assume .T.
	      lnResult = 1
	EndTry
	
	if lnResult = 0
	   return .F.
	endIf
	 
	return .T.
	
EndFunc

********************
Function MyStrToFile
********************
	* Trata o arquivo de forma exclusiva.
	Parameters cConteudo, localNomeArq

	local i
	local sucesso
	local hand
	local w

	for i = 1 to 100

		Try
		
			hand = Fopen(localNomeArq,12)
		
			if hand < 1
				Error "Não consigo abrir o arquivo!"
			endIf
			
			Fchsize(hand, 0)
			
			if len(cConteudo) > 0
				w = Fwrite(hand, cConteudo, Len(cConteudo))
			Else
				w = 1
			endIf

			Fclose(hand)
			
			if w < 1
				Error "Não consigo escrever " +Transform(cConteudo) +" no arquivo: " +Transform(localNomeArq)
			endIf
			
			sucesso = .T.
			
		Catch to error
			
			StrToFile(Transform(Datetime())+":  Tentativa "+Transform(i)+" / 1000" +Transform(ExceptionToString(error))+" cConteudo: "+Transform(cConteudo),"MyStrToFile.erro")
			
			sleep(200)

		EndTry
		
		if sucesso
			Exit
		endIf
		
	next
	
	return sucesso

endFunc

********************
Function MyFileToStr
********************
	Parameters localNomeArq

	local i
	local txtStr
	local hand
	local w
	local nSize 
	local sucesso
	txtStr = ""

	for i = 1 to 100

		Try
		
			hand = Fopen(localNomeArq,12)
			
			if hand < 1
				Error "Não consigo abrir o arquivo!"
			endIf
			
			nSize = Fseek(hand,0,2) 
			
			Fseek(hand,0,0)
			
			txtStr = Fread(hand,nSize)
			
			Fclose(hand)
			
			sucesso = .T.
			
		Catch to error
				
			StrToFile(Transform(Datetime())+":  Tentativa "+Transform(i)+" / 1000" +Transform(ExceptionToString(error))+" localNomeArq: "+Transform(localNomeArq),"MyFileToStr.erro")
			
			sleep(200)

		EndTry
		
		if sucesso
			Exit
		endIf
		
	next

	return txtStr

endFunc

**************************
Function ExceptionToString
**************************	
	Parameters excecao as Exception

	local txtExcecao	
	txtExcecao = Concat("Mensage: ",excecao.Message," Line: ",excecao.LineNo, " Line contents: ",excecao.LineContents, " Procedure: ",excecao.Procedure, " Comment: ", excecao.Comment, " Details: ",excecao.Details)
		
	return txtExcecao
	
endFunc

**************
Function Excel
**************
	Parameters cFullPath as String, plan as Opcional, curName as Opcional, cSql as Opcional
	
	local hand
	local strConn
	local strConn2	
	local retornoSql
	local array aErrorArray[1]
	local txtErro
	local d
	txtErro = ""
	
	if !ok(plan)
		plan = Strtran(JustFname(cFullPath),concat(".",JustExt(cFullPath)),"")
	endIf
	
	if !ok(curName)
		curName = Strtran(JustFname(cFullPath),concat(".",JustExt(cFullPath)),"")
	endIf
	
	curName  = Chrtran(curName," ","_")
	
	for d = 1 to 4
		
		Do case
			Case d = 1
				strConn = Concat("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};Dbq=",cFullPath,";ReadOnly=0;")
			Case d = 2
				strConn = Concat("Driver={Microsoft Excel Driver (*.xls)};Dbq=",cFullPath,";ReadOnly=0;")
			Case d = 3
				strConn = Concat("Driver={Microsoft Excel-Treiber (*.xls)};Dbq=",cFullPath,";ReadOnly=0;")
			Case d = 4
				strConn = Concat("Driver={Driver do Microsoft Excel(*.xls)};Dbq=",cFullPath,";ReadOnly=0;")
		endCase

		hand = SQLStringConnect(strConn,.t.)
		
		if hand > 0
			Exit
		endIf
		
	endFor
		
	if hand < 0
			
		AERROR(aErrorArray)				
		ERROR concat(strConn,Chr(13),GetInfoErro(@aErrorArray))

	endIf
	
	if !ok(cSql)
		cSql = concat([select * from "],plan,[$"])
	endIf

	Try
	
		if Used(curName)
			Use in (curName)
		endIf

		retornoSql = SQLExec(hand,cSql,curName)
		
		if retornoSql < 1

			AERROR(aErrorArray)				
			ERROR concat(cSql,Chr(13),GetInfoErro(@aErrorArray))
		
		endIf

	finally
	
		if ok(hand)
			SQLDisconnect(hand)
		endIf	

	EndTry	

endFunc

********************
Function GetInfoErro
********************
	
	Parameters aErrorArray
	
	Local cMsgErr, Tip
	cMsgErr = ''
	   
	for n = 1 TO 7
		cMsgErr = concat(cMsgErr,Chr(13)+Chr(10),Padl(n,2,"0"),": ",Alltrim(transform(aErrorArray(n))))
	endFor
	
	return cMsgErr
	
endFunc

*********************
Function ClearZeroEsq
*********************
	Parameters txt
	
	txt = ltrim(txt)
	
	Do While LEFT(txt,1) = "0"
		txt = Substr(txt,2,len(txt))
	EndDo
	
	Return txt
	
endFunc

*************
Function RTOX
*************
	* Record to XML
	Parameters crName

	Local i
	local cXml
	local cField
	local valField
	cXml = ""
	
	Select (crName)

	For i = 1 to fcount(crName)

		cField = alltrim(transform(field(i)))
		valField = eval(cField)

		If !Empty(valField) AND  !IsNull(valField)
			cXml = cXml +"<" +cField +">" + alltrim(transform(valField)) + "</"+cField+">"
		EndIf

	endFor
	
	return cXml

endFunc

*************
Function FTOX
*************
	* Field To XML.
	Parameters fieldName, charsRemove
	
	local cXml
	local valField
	local cField
	
	valField = Alltrim(Transform(Evaluate(fieldName)))
	
	if varType(charsRemove) = "C"
		valField = Alltrim(Chrtran(valField,charsRemove,""))
	endIf
	
	If Empty(valField) Or IsNull(valField)
		cXml = ""
	else
		cXml = "<" +fieldName +">" + valField + "</"+fieldName+">"
	EndIf
	
	return cXml
	
endFunc

***************
Function FTOTAG
***************
	* Field To TAG (A segunda tag é abreviada, isso é usado para economizar espaço)
	Parameters fieldName, charsRemove
	
	local cXml
	local valField
	local cField
	
	valField = Alltrim(Transform(Evaluate(fieldName)))
	
	if varType(charsRemove) = "C"
		valField = Alltrim(Chrtran(valField,charsRemove,""))
	endIf
	
	If Empty(valField) Or IsNull(valField)
		cXml = ""
	else
		cXml = Alltrim(fieldName) +":" + Strtran(valField,":","") + ":"
	EndIf
	
	return cXml
	
endFunc

****************
Function SQL_CSV
****************
	*
	* Ler arquivos CSV via SQL.
	* Exemplo: SQL_CSV("C:\dados\","select * from conta.csv","conta")
	*
	Parameters pasta, csvSql, xCursor
	
	pasta = Addbs(pasta)
	
	if Empty(xCursor)
		xCursor = "csvQuery"
	endIf
	
	local csvString
	local csvHand
	local csvRet

	csvString = [Driver={Microsoft Text-Treiber (*.txt; *.csv)};Dbq=] + pasta + [;Extensions=asc,csv,tab,txt;]

	csvHand = sqlStringConnect(csvString)
	
	if csvHand > 0

		csvRet = sqlexec(csvHand ,csvSql ,xCursor)
		
		SQLDisconnect(csvHand)
		
	else
		csvRet = csvHand
	endIf

	return csvRet
	
endFunc

******************
Function HtmlToCsv
******************
	Parameters arqHtml, ap

	local loH2t
	local lnSuccess
	local lcHtml
	local lcPlainText
	local ent
	local xdel
	local cr
	cr = "¨"
	
	if vartype(ap) != "C"
		ap = ["]
	endIf
	
	
	xdel = ","

	loH2t = CreateObject('Chilkat_9_5_0.HtmlToText')

	lnSuccess = loH2t.UnlockComponent("CESARG.CB10716_QokesYRY4R7G")
	
	IF (lnSuccess <> 1) THEN
	    error loH2t.LastErrorText
	endIf

	lcHtml = fileToStr(arqHtml)

	If chr(13)+chr(10) $ lcHtml
		ent = chr(13)+chr(10)
	Else
		ent = chr(10)
	EndIf

	lcHtml = strtran(lcHtml,cr,"")

	Do While "</tr> " $ lcHtml
		lcHtml = strtran(lcHtml,"</tr> ", "</tr>")
	EndDo
	Do While " </tr>" $ lcHtml
		lcHtml = strtran(lcHtml," </tr>", "</tr>")
	EndDo
	Do While "</tr>"+ent $ lcHtml
		lcHtml = strtran(lcHtml,"</tr>"+ent, "</tr>")
	EndDo
	Do While ent+"</tr>" $ lcHtml
		lcHtml = strtran(lcHtml,ent+"</tr>", "</tr>")
	EndDo

	Do While "<tr> " $ lcHtml
		lcHtml = strtran(lcHtml,"<tr> ", "<tr>")
	EndDo
	Do While " <tr>" $ lcHtml
		lcHtml = strtran(lcHtml," <tr>", "<tr>")
	EndDo
	Do While "<tr>"+ent $ lcHtml
		lcHtml = strtran(lcHtml,"<tr>"+ent, "<tr>")
	EndDo
	Do While ent+"<tr>" $ lcHtml
		lcHtml = strtran(lcHtml,ent+"<tr>", "<tr>")
	EndDo

	ent = chr(13)+chr(10)

	lcHtml = strtran(lcHtml,"</tr>","</tr>¨")

	Do While " </td>" $ lcHtml
		lcHtml = strtran(lcHtml," </td>","</td>")
	EndDo

	lcHtml = strtran(lcHtml,"></td>",">&nbsp; </td>")

	lcPlainText = loH2t.ToText(lcHtml)
	lcPlainText = strtran(lcPlainText,ent+"¨","¨")
	lcPlainText = strtran(lcPlainText,xdel,"<delSave>")
	lcPlainText = strtran(lcPlainText,ap,"")
	lcPlainText = strtran(lcPlainText,ent,xdel)
	lcPlainText = strtran(lcPlainText,xdel+cr, cr)
	lcPlainText = strtran(lcPlainText,xdel+cr, cr)
	lcPlainText = strtran(lcPlainText,cr,ap+ent+ap)
	lcPlainText = strtran(lcPlainText,xdel,ap+xdel+ap)
	lcPlainText = ap + lcPlainText
	lcPlainText = Substr(lcPlainText, 1, len(lcPlainText)-len(ap))
	lcPlainText = strtran(lcPlainText,"<delSave>",xdel)
	
	return lcPlainText

endFunc

*********************
Function HtmlToCursor
*********************
	Parameters arqHtml, curName, ap
	
	local txtCsv
	local tmpCsv
	
	txtCsv = HtmlToCsv(arqHtml, ap)
	folTemp = Addbs(FolderTemp())
	tmpCsv = Sys(2015)
	
	if Empty(curName)
		curName = Chrtran(Strtran(JustFname(arqHtml),"."+JustExt(arqHtml),"")," ","_")
	endIf
	
	StrToFile(txtCsv,folTemp +tmpCsv + ".csv")
	
	SQL_CSV(folTemp,CONCAT("SELECT * FROM ",tmpCsv,".csv"),curName)
	
endFunc

************
Function cat
************
	Parameters catTxt, ignoreEnter, goEnd
	
	goEnd = .T.
	
	catTxt = Transform(catTxt)
	
	if type("_screen.activeform.Pf1.Page1.edtConsole.Value") != "U"
			
		IF ALLTRIM(LOWER(catTxt)) = 'clear'
			_screen.activeform.Pf1.Page1.edtConsole.Value = ''
		ELSE		
			if !ignoreEnter
				if Len(_screen.activeform.Pf1.Page1.edtConsole.Value) > 0
					catTxt = Chr(13)+catTxt
				endIf
			ENDIF
			_screen.activeform.Pf1.Page1.edtConsole.Value = Transform(_screen.activeform.Pf1.Page1.edtConsole.Value) + catTxt
		ENDIF
		if goEnd
			_screen.activeform.Pf1.Page1.edtConsole.selstart = Len(_screen.activeform.Pf1.Page1.edtConsole.text)
		endIf
		_screen.activeform.Pf1.Page1.edtConsole.refresh()
		
		_screen.activeform.draw()
			
	endIf

endFunc

*****************
FUNCTION fileRead 
*****************
	* Similar ao FileToStr porém por não retorna nem lança erros.
	* Retorna o conteúdo do arquivo ou string vazia.
	* Autor: Ivan Sansão 06/02/2019
	
	PARAMETERS frFileName
	
	LOCAL frContent
	frContent = ''
	
	TRY 
		frContent = FILETOSTR(frFileName)
	CATCH
		frContent = ''
	ENDTRY

	RETURN frContent	

ENDFUNC

*****************
FUNCTION hasExcel
*****************

	LOCAL has
	
	TRY 
		oXLApp = CreateObject("Excel.Application")
		has = .T.
	CATCH
	ENDTRY	
	
	RETURN has
	
ENDFUNC

***************
FUNCTION casdec
***************
	* Retorna a quantidade de casas decimais de um número.
	PARAMETERS numAval

	if vartype(numAval) == 'N'
	
		numAval = PADL(numAval,50)
		if at(set("POINT"), numAval) = 0 
			RETURN 0
		else
			RETURN len(substr(numAval, at(set("POINT"), numAval)+1))
		ENDIF

	endif

	return 0
	
ENDFUNC

********************
Function EsperaAbrir
********************
	parameters formName, tentativas
	
	local tela
	
	IF EMPTY(tentativas)
		tentativas = 500
	ENDIF

	for i = 1 to tentativas
		if lower(_screen.activeform.name) = lower(formName)
			tela = _screen.activeform
			exit
		else
			sleep(100)
		endif
	endFor
	
	return tela

ENDFUNC
*****************
function greatest
*****************
	* Ivan
	* Retorna o maior número.
	parameters cp1,cp2,cp3,cp4,cp5,cp6,cp7,cp8,cp9,cp10,cp11,cp12,cp13,cp14,cp15,cp16,cp17,cp18,cp19,cp20,cp21,cp22,cp23,cp24,cp25,cp26,cp27,cp28,cp29,cp30,cp31,cp32,cp33,cp34,cp35,cp36,cp37,cp38,cp39,cp40,cp41,cp42,cp43,cp44,cp45,cp46,cp47,cp48,cp49,cp50

	local i
	local maior
	local arg
	maior = 0.00
	for i = 1 to pcount()
		arg = eval('cp'+alltrim(str(i)))
		if arg > maior
			maior = arg
		endif
	next
	return maior

endFunc

**************
function least
**************
	* Ivan
	* Retorna o menor número.
	parameters cp1,cp2,cp3,cp4,cp5,cp6,cp7,cp8,cp9,cp10,cp11,cp12,cp13,cp14,cp15,cp16,cp17,cp18,cp19,cp20,cp21,cp22,cp23,cp24,cp25,cp26,cp27,cp28,cp29,cp30,cp31,cp32,cp33,cp34,cp35,cp36,cp37,cp38,cp39,cp40,cp41,cp42,cp43,cp44,cp45,cp46,cp47,cp48,cp49,cp50

	local i
	local menor
	local arg
	menor = cp1
	for i = 1 to pcount()
		arg = eval('cp'+alltrim(str(i)))		
		if arg < menor
			menor = arg
		endif		
	next
	return menor

endFunc

*************
Func response
*************
	* Retorna um objeto com Id e mensagem.
	Parameters respId, respMsg
	
	local res
	m.res = CreateObject("empty")
	AddProperty(m.res,"id",respId)
	AddProperty(m.res,"msg",respMsg)
	
	return m.res

EndFunc

*****************
Function firstDay
*****************
	* Retorna qual é o primeiro dia do mês com data formatada.
	* Ivan - 29/04/2019
	Parameters ladMes, ladAno	
	return Ctod("01/"+Padl(ladMes,2,"0")+"/"+Transform(ladAno))
endFunc

****************
Function lastDay
****************
	* Retorna qual é o último dia do mês.
	* Ivan - 29/04/2019
	Parameters ladMes, ladAno	
	return GoMonth(CtoD(Concat("31/01/",ladAno)), ladMes-1)
endFunc


***********
Function ob
***********
	* Ivan Sansão 01/05/2019
	*
	* Retorna um objeto com atributos e valores conforme passados na sequência por parâmetro.
	* 
	* Pode ser usado (exemplo) assim:
	*	ob('codigo', 1, 'valor', 10.50)
	* Ou assim:
	*	ob('codigo: 1, valor: 10.50')
	*
	Parameters  cp1,cp2,cp3,cp4,cp5,cp6,cp7,cp8,cp9,cp10,cp11,cp12,cp13,cp14,cp15,cp16,cp17,cp18,cp19,cp20,cp21,cp22,cp23,cp24,cp25,cp26,cp27,cp28,cp29,cp30,cp31,cp32,cp33,cp34,cp35,cp36,cp37,cp38,cp39,cp40,cp41,cp42,cp43,cp44,cp45,cp46,cp47,cp48,cp49,cp50,cp51,cp52,cp53,cp54,cp55,cp56,cp57,cp58,cp59,cp60,cp61,cp62,cp63,cp64,cp65,cp66,cp67,cp68,cp69,cp70,cp71,cp72,cp73,cp74,cp75,cp76,cp77,cp78,cp79,cp80,cp81,cp82,cp83,cp84,cp85,cp86,cp87,cp88,cp89,cp90,cp91,cp92,cp93,cp94,cp95,cp96,cp97,cp98,cp99,cp100,cp101,cp102,cp103,cp104,cp105,cp106,cp107,cp108,cp109,cp110,cp111,cp112,cp113,cp114,cp115,cp116,cp117,cp118,cp119,cp120,cp121,cp122,cp123,cp124,cp125,cp126,cp127,cp128,cp129,cp130,cp131,cp132,cp133,cp134,cp135,cp136,cp137,cp138,cp139,cp140,cp141,cp142,cp143,cp144,cp145,cp146,cp147,cp148,cp149,cp150,cp151,cp152,cp153,cp154,cp155,cp156,cp157,cp158,cp159,cp160,cp161,cp162,cp163,cp164,cp165,cp166,cp167,cp168,cp169,cp170,cp171,cp172,cp173,cp174,cp175,cp176,cp177,cp178,cp179,cp180,cp181,cp182,cp183,cp184,cp185,cp186,cp187,cp188,cp189,cp190,cp191,cp192,cp193,cp194,cp195,cp196,cp197,cp198,cp199,cp200,cp201,cp202,cp203,cp204,cp205,cp206,cp207,cp208,cp209,cp210,cp211,cp212,cp213,cp214,cp215,cp216,cp217,cp218,cp219,cp220,cp221,cp222,cp223,cp224,cp225,cp226,cp227,cp228,cp229,cp230,cp231,cp232,cp233,cp234,cp235,cp236,cp237,cp238,cp239,cp240,cp241,cp242,cp243,cp244,cp245,cp246,cp247,cp248,cp249,cp250,cp251,cp252,cp253,cp254

	local i
	local obRet
	local obValue
	m.obRet = CreateObject('custom')
	
	if ':' $ Evaluate("m.cp1")
	
		m.cp1 = ','+m.cp1+','

		for i = 1 to Occurs(':',m.cp1)
			obValue = StrExtract(m.cp1,':',',',i)
			AddProperty(m.obRet,StrExtract(m.cp1,',',':',i), Iif(Empty(obValue),'',Evaluate(obValue)) )
		next
	
	else

		for i = 1 to Pcount() step 2
			AddProperty(m.obRet,Evaluate("cp"+Alltrim(Str(m.i))),Evaluate("cp"+Alltrim(Str(m.i+1))))
		next
		
	endIf

	return m.obRet
	
endFunc

*************************
Function sqlFormataString
*************************
	* Objetivo: Formatar as Strings para os caracteres especiais
	* Parâmetro: String
	* Retorno: String formatada.
	
	Parameters StringSql

	StringSql = Strtran(StringSql,"\","\\")

	StringSql = Strtran(StringSql,"\'","'")
	StringSql = Strtran(StringSql,'\"','"')

	StringSql = Strtran(StringSql,"'","\'")
	StringSql = Strtran(StringSql,'"','\"')
	
	Return(StringSql)
	
endFunc

************
function gex
************
	* Creation: Ivan - 14/11/2019
	* Exemplo: 
	*
	* ? gex('pedidos: 3378, 9987', '[\d]+')  && Retorna: 3378 9987
	*
	parameters cexp, pattern, cdel

	local res
	local allMatches
	local ob

	res = ''

	if vartype(cdel) != 'C'
		cdel = ' '
	endif

	if type('_screen.regex') != 'O'
		_screen.addProperty('regex',CreateObject("VBScript.RegExp"))
		_screen.regex.IgnoreCase = .t.
		_screen.regex.Global = .t.
		_screen.regex.Multiline = .t.
	endIf
		
	_screen.regex.pattern = pattern
	allMatches = _screen.regex.execute(cexp)

	IF allMatches.count > 0

		FOR EACH ob IN allMatches
			if empty(res)
				res = res + substr(cexp,ob.FirstIndex+1, ob.Length)
			else
				res = res + cdel + substr(cexp,ob.FirstIndex+1, ob.Length)
			endif 
		Next

	endIf

	return res
endFunc