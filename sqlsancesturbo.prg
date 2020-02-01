Parameters cmdSql, curResult

Try



		local handConexaoST
		handConexaoST = SqlStringConnect("driver=MySQL ODBC 5.1 Driver;server=localhost;port=3306;DATABASE=sancesfortester;uid=sances;pwd=laranjauva")

		_screen.addProperty("handConexaoST", handConexaoST)

		if ok(_screen.handConexaoST)
			SQLEXEC(_screen.handConexaoST, cmdSql, curResult)
		endif

	finally
		if ok(_screen.handConexaoST)
			SqlDisconnect(_screen.handConexaoST)
		endIf
	endTry