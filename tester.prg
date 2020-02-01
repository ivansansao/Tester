* Create by: Ivan Sansão
* Date: 2017-02-18

Parameters autoPlay as Boolean

Set Procedure To alone.prg Additive 

If !IsAdmin()
	Messagebox("Você deve executar o Tester como administrador.",64,"Administrador", 5000)
	Return .F.
EndIf

if NumberRunning("tester.exe") > 1
	MessageBox("Tester já está rodando!",64,"Tester",5000)
	return .F.
endIf

_screen.AddProperty("autoPlay", Upper(Transform(autoPlay)) = ".T.")

_screen.Icon = "tester.ico"

DECLARE Sleep IN kernel32 INTEGER dwMilliseconds

#define ERROR_WAITWINDOW_TIMOUT 1
#define ERROR_EXECTEST_TIMOUT 2
#define ERROR_PROGRAM_IS_OPENED 3
#define ERROR_QUERY 4

Set Console Off
Set Exact On
Set Ansi On
Set Date To British
Set Century On
Set Hours To 24
Set Keycomp To Windows
Set Safety Off
Set Deleted On
Set Scoreboard Off
Set Escape Off
Set Notify Off
Set Null On
Set Nulldisplay To ""
Set Memowidth To 255
Set Multilocks On
Set Debug On
Set Point To '.'
Set Confirm On
Set Talk off
Set Decimals To 2


ExecTestConfigura()
CreateEnvs()
ConectarBancoDeDados()
GeraFPW()

Set Classlib To string Additive 

Do form main.scx

Read events

**************************	
Function ExecTestConfigura
**************************

	Public arq_buffer_run
	arq_buffer_run = "C:\sances\sancesturbo\buffer_run.txt"

	Public arq_buffer_return
	arq_buffer_return = "C:\sances\sancesturbo\buffer_return.txt"

	Public arq_buffer_activewindow
	arq_buffer_activewindow = "C:\sances\sancesturbo\buffer_activewindow.txt"

	Public arq_buffer_testerclient_run
	arq_buffer_testerclient_run = "C:\sances\sancesturbo\buffer_testerclient_run.txt"
	
	Public arq_buffer_testerclient_return
	arq_buffer_testerclient_return = "C:\sances\sancesturbo\buffer_testerclient_return.txt"
	
	Public arq_msgfundo_error
	arq_msgfundo_error = "C:\sances\sancesturbo\msgfundo_error.txt"	

	MyStrToFile("", arq_buffer_run)
	MyStrToFile("", arq_buffer_return)
	MyStrToFile("", arq_buffer_activewindow)
	MyStrToFile("", arq_buffer_testerclient_run)
	MyStrToFile("", arq_buffer_testerclient_return)
	MyStrToFile("", arq_msgfundo_error)
	
	* Contém o nome do programa a ser testado.
	Public nomProgramaCliente
	
	* Contém o caminho de onde fica o programa a ser testado.
	Public pasProgramaCliente
	
	* Contém parâmetros do programa testado.
	Public parProgramaCliente

	* Contém o nome da janela de modo teste do programa cliente.
	Public janelaModoTesteCliente

ENDFUNC

***********
FUNCTION ge
***********
	PARAMETERS conteudo, lClear

	Local PathPasta
	PathPasta = tex(Sys(2003))

	Local arqExecucao
	arqExecucao = tex(Concat(PathPasta,"\execucao.txt"))
	
	IF lClear
		STRTOFILE("",arqExecucao)
	ELSE
		STRTOFILE(TRANSFORM(conteudo) + (CHR(13)+ CHR(10)),arqExecucao,1)
	EndIf

ENDFUNC

*****************
Function ExecTest
*****************
	Parameters conteudo, nTimeout
	
	ge(conteudo)
	
	local txtReturn
	local suc
	suc = ""
	
	* Se não foi informado o timeout 
	if !ok(nTimeout)
	
		* Assume padrão.
		nTimeout = 150
		
	endIf
	
	MyStrToFile("", arq_buffer_return)
	MyStrToFile(conteudo, arq_buffer_run)

	suc = "TIMEOUT"
	
	for i = 1 to nTimeout

		txtReturn = MyFileToStr(arq_buffer_return)

		if Len(txtReturn) > 0

			* Limpa o arquivo de retorno
			MyStrToFile("", arq_buffer_return)

			suc = txtReturn

			exit

		endIf

		sleep(200)

	next

	***
	*** Verifica se ocorreram excessões na hora da execução	
	Do case

	* Timeout na execução do comando
	Case suc == "TIMEOUT"

		local err as Exception
		err = CreateObject("exception")
	 	err.ErrorNo = 2
		err.Message = concat("TIMEOUT AO EXECUTAR O COMANDO: ", conteudo)

		* Lança a excessão
		Throw err

	* Se o retorno for DONE		
	Case suc == "DONE"
	 	*Não faz nada

	* Se ocorrer qualquer outro erro
	Otherwise

		local err as Exception
		err = CreateObject("exception")
		err.ErrorNo = 3
		err.Message = concat("NÃO FOI POSSÍVEL EXECUTAR O TESTE. ERRO: ", suc)

		* Lança a excessão
	    Throw err

	ENDCASE

	return suc

endFunc

**********************
Function WaitForWindow
**********************
	* 
	* Nome do arquivo do form(Ex: pessoafgui)
	* Sample: You can test if WaitForWindow("Customers") == "TIMEOUT"
	Parameters formName, nTimewait
	
	ge(formName)

	local ret
	local i
	LOCAL bodyFile
	
	formName = Lower(Alltrim(Transform(formName)))
	nTimewait = Val(Transform(nTimewait))

	* Padrão para poder tratar um possível "timeout"
	ret = "TIMEOUT"

	if nTimewait < 200
		* Diego em 17-08-2018 - Criei uma variavel de ambiente que permite alterar o tempo padrão de time-out
		nTimewait = Val(Transform(GetEnv("TESTER_TIMER_EXECUCAO")))
	endIf

	* Tentativas de detectar a presença da janela solicitada. 
	*
	* Note que o For divide o tempo em pedacinhos menores de 100 milisegundos
	* para que possa ser detectado algo antes de acabar o tempo final.

	for i = 1 to nTimewait / 100
	
		bodyFile = Transform(MyFileToStr(arq_buffer_activewindow))
		bodyFile = STRTRAN(bodyFile,CHR(09),"")
		bodyFile = STRTRAN(bodyFile,CHR(10),"")
		bodyFile = STRTRAN(bodyFile,CHR(13),"")
		bodyFile = Lower(Alltrim(bodyFile))
		
		* Se a janela solicitada for a janela ativa da aplicação.
		If bodyFile == formName

			* Relato um sucesso.
			ret = "DONE"
			Exit

		endIf

		* Espero um pouquinho.
		sleep(100)

	endFor

	if ret == "TIMEOUT"

		local tok as Exception
		tok = CreateObject("exception")
		tok.ErrorNo = 1
		tok.Message = Concat("Não foi detectada a presença da janela: ",formName)

		*ERROR ERROR_WAITWINDOW_TIMOUT, "Não foi possível localizar a janela: " +formName

		Throw tok

	endIf

	* Não tem retorno porque o mesmo é capturado via Throw!
	return

endFunc

*************************
Function GravaLogExecucao
*************************

	* codtir = A|R (Aprovado | Reprovado)

	Parameters idCasoTeste, mensagem, codtir

	ge(mensagem)
	
	m.mensagem = tex(m.mensagem)

	codtir = tex(Iif(!ok(codtir),"r",codtir))

	Local PathProg 
	local logExecucao
	local codCaso

	PathProg = tex(Sys(2003))

	m.logExecucao = ""
	m.codCaso = Substr(idCasoTeste,At("_",idCasoTeste)+1,99)

	m.logExecucao = Concat(m.PathProg,"\tester.log")

	*	MyStrToFile(concat(m.logExecucao, tex(idCasoTeste),": " ,tex(mensagem),Chr(13) +Chr(10)), m.logExecucao)

	StrToFile(Concat(tex(idCasoteste),": ",mensagem,Chr(13)+Chr(10)),m.logExecucao,1)

	** 
	** GRAVA NO HELPDESK
	**

	local codPlano
	local codVersao

	codPlano = tex(GetEnv("TESTER_CONNECTION_PLANOTESTE"))
	codVersao = Config(20003)

	if ok(codCaso) and ok(codPlano) and ok(codVersao)

		sql = concat("delete from qltestecaso where codpla_tes = ",aspas(codPlano)," and codprv_tes = ",aspas(codVersao)," and codcas_tes = ",aspas(codCaso))	
		query(sql)

		text to sql noShow textMerge
			Insert into qltestecaso (codpla_tes, codcas_tes, iniexe_tes, codprv_tes, codtir_tes, obs_tes)
			values ("<<codPlano>>","<<codCaso>>",now(),"<<codVersao>>","<<codtir>>","<<sqlFormataString(mensagem)>>")
		EndText

		query(sql)

	endIf

endFunc

**********************
Function ExecTestReset
**********************
	**
	** Objetivo: Resetar o teste a cada execução do teste
	**

	ge("ExecTestReset")

	local suc
	suc = .F.

	* Limpa os arquivos de buffer antes de iniciar o processo
	MyStrToFile("", arq_buffer_run)
	MyStrToFile("", arq_buffer_return)
	MyStrToFile("", arq_buffer_activewindow)
	MyStrToFile("", arq_buffer_testerclient_run)
	MyStrToFile("", arq_buffer_testerclient_return)
	MyStrToFile("", arq_msgfundo_error)

	* Envia um comando para resetar o teste
	MyStrToFile("RESET", arq_buffer_testerclient_run)

	for i = 1 to 100

		txtReturn = MyFileToStr(arq_buffer_testerclient_return)

		* O programa cliente vai escrever algo no arquivo se ele conseguir resetar as janelas.
		if Len(txtReturn) > 0

			* Limpa o arquivo de retorno
			MyStrToFile("", arq_buffer_testerclient_return)

			suc = .T.

			exit

		endIf

		sleep(200)

	next

	if !suc
		ReiniciarPrograma()

	endif

endFunc

**************************
Function ReiniciarPrograma
**************************

	FecharPrograma(nomProgramaCliente)

	AbrirPrograma(pasProgramaCliente, nomProgramaCliente, parProgramaCliente)

	* Aguarda até 50 segundo o programa estar pronto para testes.
	WaitForWindow(janelaModoTesteCliente,50000)

endFunc


***********************
Function FecharPrograma
***********************

	Parameters cPrograma
	 
	local Executador as "WScript.Shell"

	Executador = CREATEOBJECT("WScript.Shell")
	Executador.Run(concat("taskkill /f /im ",cPrograma), 0, .T.)
	
	return .T.
	
endFunc



***************
Function concat
***************
	Parameters cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20, cp21, cp22, cp23, cp24, cp25, cp26, cp27, cp28, cp29, cp30, cp31, cp32, cp33, cp34, cp35, cp36, cp37, cp38, cp39, cp40, cp41, cp42, cp43, cp44, cp45, cp46, cp47, cp48, cp49, cp50, cp51, cp52, cp53, cp54, cp55, cp56, cp57, cp58, cp59, cp60, cp61, cp62, cp63, cp64, cp65, cp66, cp67, cp68, cp69, cp70, cp71, cp72, cp73, cp74, cp75, cp76, cp77, cp78, cp79, cp80, cp81, cp82, cp83, cp84, cp85, cp86, cp87, cp88, cp89, cp90, cp91, cp92, cp93, cp94, cp95, cp96, cp97, cp98, cp99, cp100, cp101, cp102, cp103, cp104, cp105, cp106, cp107, cp108, cp109, cp110, cp111, cp112, cp113, cp114, cp115, cp116, cp117, cp118, cp119, cp120, cp121, cp122, cp123, cp124, cp125, cp126, cp127, cp128, cp129, cp130, cp131, cp132, cp133, cp134, cp135, cp136, cp137, cp138, cp139, cp140, cp141, cp142, cp143, cp144, cp145, cp146, cp147, cp148, cp149, cp150, cp151, cp152, cp153, cp154, cp155, cp156, cp157, cp158, cp159, cp160, cp161, cp162, cp163, cp164, cp165, cp166, cp167, cp168, cp169, cp170, cp171, cp172, cp173, cp174, cp175, cp176, cp177, cp178, cp179, cp180, cp181, cp182, cp183, cp184, cp185, cp186, cp187, cp188, cp189, cp190, cp191, cp192, cp193, cp194, cp195, cp196, cp197, cp198, cp199, cp200, cp201, cp202, cp203, cp204, cp205, cp206, cp207, cp208, cp209, cp210, cp211, cp212, cp213, cp214, cp215, cp216, cp217, cp218, cp219, cp220, cp221, cp222, cp223, cp224, cp225, cp226, cp227, cp228, cp229, cp230, cp231, cp232, cp233, cp234, cp235, cp236, cp237, cp238, cp239, cp240, cp241, cp242, cp243, cp244, cp245, cp246, cp247, cp248, cp249, cp250, cp251, cp252, cp253, cp254, cp255

	local iConcat, concatenado
	m.concatenado = ""

	for m.iConcat = 1 to Pcount()
		m.concatenado = m.concatenado + Transform(Evaluate("cp" + Alltrim(Str(m.iConcat))))
	endFor

	return m.concatenado
endFunc

************
Function Tex
************
	* Objetivo: Converter qualquer tipo de dado para string,
	*			inclusive valores nulos.
	* Parâmetro: Expressão, [Tamanho], [Casas Decimais]
	* Retorno: Texto ajustado.
	
	Parameters Exp, Tam, Cas
	
	Local rs	
	rs = ''
	
	Do Case
	
		Case Type("Exp") == Upper("g") && tentativa do general field
	
		Case Type("Exp") == Upper("n")
		
			If Empty(Cas)			
				rs = Transform(Exp)
			Else
				rs = Alltrim(Str(Exp,Iif(Type("Tam") == 'N',Tam,15),Iif(Type("Cas") == 'N', Cas,0)))
			EndIf
			
		Case Type("Exp") == Upper("c")
			
			rs = Alltrim(Exp)

		Case Type("Exp") == Upper("d")
			
			rs = Alltrim(Dtoc(Exp))

		Case Type("Exp") == Upper("t")
		
			rs = Alltrim(ttoc(Exp))
			
	EndCase
	
	* Tranforma para string vazia se a expressão para retorno for nula.
	rs = Nvl(rs,"")

	Return(rs)
	
endFunc

***********
Function ok
***********
	* Retorna verdadeiro caso o valor passado for válido.
	* Observação: Número é tratado como boolean.
	Parameters e
	
	return valido(e,.t.)

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

endFunc

**********************
Function NumberRunning
**********************
	* Informa se um programa ou processo está aberto.
	Parameters programa

	local Servico, Processo

	Servico = getObject("winmgmts:\\.\root\cimv2")	 	 
	Processo = Servico.ExecQuery(concat("SELECT * FROM Win32_Process where name = '",programa,"'"))

	return Processo.Count
  
endFunc

**********************
Function AbrirPrograma
**********************
	Parameters caminho, cPrograma, cPars
	
	if NumberRunning(cPrograma) > 0
	
		*local tok as Exception
		*tok = CreateObject("exception")
		*tok.ErrorNo = 3 && ERROR_PROGRAM_IS_OPENED
		*tok.Message = Concat("Programa já está aberto: ",cPrograma)
		*Throw tok
	
		return .F.
		
	endIf
	 
	local Executador as "WScript.Shell"
	local oldDir
	
	Executador = CREATEOBJECT("WScript.Shell")
	oldDir = Executador.CurrentDirectory
	Executador.CurrentDirectory = caminho
	Executador.Run(concat(Addbs(caminho),cPrograma," ",cPars), 0, .f.)
	
	Executador.CurrentDirectory = oldDir
	
	* Aguarda até 10 segundos para o processo ser criado pelo windows.
	for i = 1 to 10
		if NumberRunning(cPrograma) > 0
			Exit
		endIf
		sleep(1000)
	endFor 

endFunc

***************
Function equals
***************
	* Objetivo: Informa se a expressão 1 é igual a expressão 2.
	* Parâmetro(s): <expressão1>, <expressão2>, <caseSensitive BOOLEAN>
	* Retorno: boolean

	Parameters expressao1, expressao2, caseSensitive
	
	* Caso a expressão 1 e 2 serem nulas.
	If IsNull(expressao1) and IsNull(expressao2)
	
		* Retorna com sucesso.
		Return .T.
	
	Else
	
		* Se uma das duas expressões for nula.
		If !(IsNull(expressao1) or IsNull(expressao2))
		
			local type1
			local type2
			type1 = Type('expressao1')
			type2 = Type('expressao2')
		
			* Se as expressões forem do mesmo tipo.
			If type1 = type2
			
				if type1 = "C" and !caseSensitive
				
					* Retorna a comparação entre as expressões.
					Return Alltrim(Lower(expressao1)) == Alltrim(Lower(expressao2))
				
				else
			
					* Retorna a comparação entre as expressões.
					Return expressao1 == expressao2
					
				endIf
				
			else
				* O tipo é diferente.
				
				* Verifica se o conteúdo é igual e retorna.
				if Alltrim(Transform(expressao1)) == Alltrim(Transform(expressao2))
					return .t.
				endIf
			
			EndIf	
			
		EndIf
	
	EndIf
	
	* Retorna sem sucesso.
	Return .F.
		
endFunc

************
Function box
************
	* Mostra uma caixa de mensagem com informações.
	Parameters msg, tit
	
	msg = Transform(msg)
	tit = Transform(tit)
	tit = Iif(ok(tit),tit,"Mensagem")

	messageBox(msg,64,"")

endFunc



*******************
Function CreateEnvs
*******************

	if !ok(GetEnv("TESTER_CONNECTION_AUTO"))

		Wait window Concat("Instalando variáveis de ambiente...",Chr(13),"(Vai demorar 1 minuto mais ou menos)") nowait

		SetEnv("TESTER_CONNECTION_AUTO",".F.")
		SetEnv("TESTER_CONNECTION_DRIVER","MySQL ODBC 5.1 Driver")
		SetEnv("TESTER_CONNECTION_SERVER","localhost")
		SetEnv("TESTER_CONNECTION_USER","root")
		SetEnv("TESTER_CONNECTION_PASSWORD","")
		SetEnv("TESTER_CONNECTION_DATABASE","helpdesk")
		SetEnv("TESTER_CONNECTION_PLANOTESTE","2")
		
		** Diego 17-08-2018 - Criado mais uma variavel de ambiente para armazenar o tempo de time-out da função WaitForWindow
		
		SetEnv("TESTER_TIMER_EXECUCAO","15000")
		
		SetEnv("TESTER_RUN_ON_CASE_ERROR","")
		
		*SetEnv("TESTER_SALVARTELA_PROGRAM","salvar_tela.exe")
		*SetEnv("TESTER_SALVARTELA_FOLDER","\Tester\scriptteste\")
		*SetEnv("TESTER_SALVARTELA_PARS","<caso><day><month><year><hour><min>")		

		Wait clear

	endIf

endFunc

***************
Function SetEnv
***************
	* Seta variável ambiente.
	* Exemplo:
	* SetEnv("editor","myprogram","USER")
	* cUserSystem = USER|SYSTEM
	
	Parameters cName, cValue, cUserSystem

	local she as WScript.Shell
	local env as shell.Environment
		
	cUserSystem = Alltrim(Upper(Transform(cUserSystem)))

	if !InList(cUserSystem,"USER","SYSTEM")
		cUserSystem = "USER"
	endIf
	
	she = CreateObject("WScript.Shell")

	env = she.Environment(cUserSystem)
	env.Item(cName) = cValue

endFunc


Define Class ini as Custom

	arquivo = ""
	
	Function load(cFileName)
	
		this.arquivo = FileToStr(cFileName)
		
	endFunc
	
	Function Get(cVariavel)
	
		local cIni, cFim
		cIni = concat("<",cVariavel,">")
		cFim = concat("</",cVariavel,">")

		return StrExtract(this.arquivo,cIni,cFim)
		
	endFunc

	Function CreateFile
	
		local txt
		text to txt noShow textMerge
			<ip></ip>
		endText
	
	endFunc

endDefine

*****************************
Function ConectarBancoDeDados
*****************************

	local i
	i = 1
	
	Do while .T.
	
		_screen.AddProperty("dbHandle",0)
		_screen.AddProperty("dbString","")
		
		SqlSetProp(0,"DISPLOGIN",3)

		_screen.dbString = 	 "driver=" 		+GetEnv("TESTER_CONNECTION_DRIVER") ;
							+";server=" 	+GetEnv("TESTER_CONNECTION_SERVER") ;
							+";port=" 		+GetEnv("TESTER_CONNECTION_PORT");
							+";DATABASE=" 	+GetEnv("TESTER_CONNECTION_DATABASE");
							+";uid=" 		+GetEnv("TESTER_CONNECTION_USER");
							+";pwd="		+GetEnv("TESTER_CONNECTION_PASSWORD")

		if GetEnv("TESTER_CONNECTION_AUTO") = ".T."
		
			_screen.dbHandle = SqlStringConnect(_screen.dbString)
			
			* MessageBox(concat("Conexão: ",_screen.dbHandle),64,"Teste do banco de dados")
			* SQLExec(_screen.dbHandle,"show databases","showData")
				
			if _screen.dbHandle > 0
				Exit
			else
				MessageBox(Transform("Trying to connect to database... Try ") + Transform(i),64,"TESTER - Database",5000)
			endIf
		
		endIf
		
		 i = i +1
		
	endDo

endFunc

**************
Function query
**************
	Parameters cQuery, cCursor
	
	local nRet
	local i
	
	if !ok(cCursor)
		cCursor = "queryResult"
	endIf
	
	for i = 0 to 1
	
		Try
			nRet = sqlexec(_screen.dbhandle,cQuery,cCursor)
		Catch
			nRet = 0
		EndTry
			
		if nRet > 0
			Exit
		else
		
			AERROR(aErrorArray)  
			
			Local cMsgErr
			local n
			cMsgErr = ''
			   
			cMsgErr = 'The error provided the following information'  && Display message
			cMsgErr = cMsgErr + Chr(13)
			   		   
			for n = 1 TO 7  && Display all elements of the array
				if n != 3
					cMsgErr = concat(cMsgErr,Chr(13),Padl(n,2,"0"),": ",transform(aErrorArray(n)))
				endIf
			endFor
			
			local tok as Exception
			tok = CreateObject("exception")
			tok.ErrorNo = 4 && ERROR_QUERY
			tok.Message = cMsgErr
			
			if IsConnected()
			
				StrToFile(Transform(Datetime())+': ' +cMsgErr+Chr(13),'sqltester.err',1)
				StrToFile(Transform(Datetime())+': ' +'Tentando executar o SQL: ' +Transform(cQuery)+Chr(13),'sqltester.err',1)
				
				Error cMsgErr
				*Throw tok
			else
				ConectarBancoDeDados()
			endIf
			
		endIf
		
	endFor
	
	return nRet

endFunc

********************
Function IsConnected
********************

	local nRet
	nRet = 0
	
	Try
		nRet = sqlexec(_screen.dbhandle,"SELECT 0","testConn")
	Catch
		nRet = 0
	EndTry
	
	if !nRet > 0
		_screen.dbhandle = 0
	endIf
		
	Return nRet > 0
	
endFunc


*********************
Function AbrirArquivo
*********************

	* Aguarda o arquivo liberar.
	Parameters refArquivo, estiloJanela, aguardarRetorno

	local Executador as "WScript.Shell"
	Executador = CREATEOBJECT("WScript.Shell")
	
	If ok(estiloJanela)
		Executador.Run(refArquivo, estiloJanela, aguardarRetorno)
	Else
		Executador.Run(refArquivo, 1, aguardarRetorno)
	EndIf

endFunc

*******************
Function workFolder
*******************

	return Addbs(concat(Sys(5),Sys(2003)))

endFunc




********************
Function GetInfoErro
********************
	
	Parameters aErrorArray
	
	Local cMsgErr, Tip
	cMsgErr = ''
	   
	cMsgErr = 'Ocorreu um erro:'
	cMsgErr = cMsgErr + Chr(13)
	   
	for n = 1 to 7
		cMsgErr = concat(cMsgErr,Chr(13),Padl(n,2,"0"),": ",transform(aErrorArray(n)))	   	  		
	endFor
	
	return cMsgErr
	
endFunc

***************
Function Config
***************
	Parameters nCodigoCon
	
	query(concat("select valor_con from config where numero_con = ",aspas(nCodigoCon)),"_config")
	
	return _config.valor_con

endFunc


**************
Function aspas
**************
	* Retorna o valor informado com aspas.
	Parameters exp_aspas
	return concat(["],Alltrim(transform(exp_aspas)),["])
ENDFUNC

*****************
Function atribuir
*****************
	**
	** Função Atribuir
	** Será utilizada para atribuir um valor a um campo.
	** Parameters: 
	** Campo: EX: thisform.txtCodPes.value
	** Valor: pessoafisica.codigo
	** tipo: C = Character, N = Numérico, D = Data
	** AtribuirMesmoNulo: true ou false
	**
	PARAMETERS campo, valor, tipo ,atribuirMesmoNulo
	
	LOCAL xComando,xValor
	xComando = ""
	xValor = ""
	
*	box(ok(valor))
*	box(atribuirMesmoNulo)
	* Se valor informado é válido ou é para atribuir mesmo nulo
	IF ok(valor) OR atribuirMesmoNulo 
	
		DO CASE
		
		* Se for caracter
		CASE equals(tipo,"C")
			xValor = concat("'",valor,"'")
		* Se for do tipo numérico
		CASE equals(tipo,"N")	
			xValor = valor
			
		* Se for do tipo Date	
		CASE equals(tipo,"D")		
			
			
		* Caracter
		OTHERWISE
			xValor = concat("'",valor,"'")

		ENDCASE

		xComando = concat(campo,' = ',xValor)
	
	else
		
		xComando = "return .t."
					
	ENDIF
		
	RETURN  xComando
	
ENDFUNC


*********************
FUNCTION ResetaTestes
*********************
**
** Limpa o relatório de todos os testes antes de iniciar a execução
**

	local codPlano
	local codVersao

	* codPlano = Config(20002)
	codPlano = GetEnv("TESTER_CONNECTION_PLANOTESTE")
	
	codVersao = Config(20003)
	
	IF ok(codPlano) and ok(codVersao)
	
		sql = concat("delete from qltestecaso where codpla_tes = ",aspas(codPlano)," and codprv_tes = ",aspas(codVersao))	
		query(sql)
		
	ENDIF
	
ENDFUNC


****************
Function GeraFPW
****************

	local lcText

	TEXT TO lcText NOSHOW TEXTMERGE pretext 7
	
		SCREEN=OFF
		CONSOLE=OFF
		TITLE=TESTER
		STACKSIZE=16384

	EndText
	
	if !File("config.fpw")
		StrToFile(lcText, "config.fpw")
	endIf

endFunc
