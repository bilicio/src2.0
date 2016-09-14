package classes.antidoto
{
	import flash.data.SQLConnection;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import classes.antidoto.propagaEvento;
	
	//import starling.events.Event;

	public class SQL extends Sprite
	{
		private var conn:SQLConnection;
		private var createData:SQLStatement;
		private var getData: SQLTableSchema;
		private var dbFile:File;
		
		private var _database:String;
		private var _mode:String;
		private var _options:Object;
		
		private var lenght:Number = -1;
		
		private const vars:Array = new Array('xml','table','value','index');
		
		private var receivedVars:Array;
		
		private var result:Array;
		private var data:Array;
		
		private var sqlPool:Array;
		private var loopTables:Number;
		
		private var tables:SQLSchemaResult;
		private var tableName:String;
		
		private var table:String;
		private var columns:String;
		private var values:String;
		
		private var _folder:String;
		
		//public function SQL(mode,database,table,index=null,value=null)
		public function SQL(mode, folder, database, options:Object)
		{
			//for (var a:Object in options){
				//_options.push(a);
					//lenght++;
					//trace(options.xml);
					_options = options;
					//_folder = folder == ''? File.separator : File.separator+_folder+File.separator;
					//_options[lenght][0] = a;
			//}
					if(folder !== ''){
						var dir:File = File.documentsDirectory.resolvePath(folder); 
						dir.createDirectory(); 
						
						_folder = File.separator+folder+File.separator;
						
						trace('create dir');
						
					}else{
						_folder = File.separator;
					}
					
			
			//lenght = 0;
			
		/*	for each(var b:Object in options){
				lenght++;
				_options[lenght][1] = b;
			}*/
			
			_mode = mode;
			_database = database;
			//_table = table;
			//_value = value;
			//_index = index;
			
			
			
			openDatabase();
		}
		
		//--------------------------------------------------------------- | Verifica se Existe/Cria a Database
		private function openDatabase():void{
			dbFile = new File(File.documentsDirectory.nativePath + _folder + _database);
			//dbFile.preventBackup = true;
			//trace(File.documentsDirectory.nativePath + _folder + _database);
			dbFile.addEventListener(Event.COMPLETE, deleted)
			//dbFile = File.createTempDirectory().resolvePath("equipa.db");

			conn = new SQLConnection();
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLEvent.COMMIT, inserted);
			conn.addEventListener(SQLEvent.CLOSE, closeSQL);

			conn.openAsync(dbFile);

		}
		
		//--------------------------------------------------------------- | Abre conexão com a tabela
		protected function openHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLErrorEvent.ERROR, errorHandler);
			conn.removeEventListener(SQLEvent.OPEN, openHandler);
			
			conn.addEventListener(SQLEvent.BEGIN, analyzeTable);
			conn.begin();
			
		}
		
		//--------------------------------------------------------------- | Visualizar nome de Database e Colunas
		private function analyzeTable(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.BEGIN, analyzeTable);
			
			if(_mode == 'CREATE' || _mode == 'DROPTABLE' ){
				modifyDatabase();
			}else{
				conn.loadSchema();
				conn.addEventListener(SQLEvent.SCHEMA, viewSchema);
			}
		}
		
		//--------------------------------------------------------------- | Visualiza estrutura da tabela
		protected function viewSchema(event:SQLEvent):*
		{	
			//trace(tmp.getSchemaResult().tables[0].name);
			conn.removeEventListener(SQLEvent.SCHEMA, viewSchema);
			
			tables = conn.getSchemaResult();
			
			var chosedTable:SQLTableSchema;
			
			if(_options.table == 'all'){
				modifyDatabase();
				return;
			}
			
			for(var a:Number = 0; a<tables.tables.length; a++){
				if(tables.tables[a].name == _options.table){
					chosedTable = tables.tables[a];
				}
			}
			//trace(result.tables[0].name);
			
			var table:SQLTableSchema = chosedTable;
			
			//trace("\tTable: "+_table)
			
			columns = new String();
			for (var i:Number=1; i<table.columns.length; i++) {
				//trace("\tColumn "+i+" - "+table.columns[i].name);
				columns += table.columns[i].name +  (i != table.columns.length-1?",":"");
			}
			
			modifyDatabase();
		}
		
		//--------------------------------------------------------------- | Modificar Tabelas
		private function modifyDatabase():void
		{

			switch(_mode){
				case 'CREATE':
					createTable();
				break;
				case 'DELETE':
					deleteRow();
				break;
				case 'INSERT':
					insertRow();
				break;
				case 'UPDATE':
					updateRow();
				break;
				case 'SELECT':
					selectTable();
				break;
				case 'DROPTABLE':
					dropTable();
				break;

			}

		}
		
		//--------------------------------------------------------------- | Criar Tabelas
		private function createTable():void
		{
			
			trace('database criada');
			
			sqlPool = new Array();
			
			for(var i:Number = 0; i<_options.xml.children().length(); i++){
				table = new String();
				columns = new String();
				
				table = _options.xml.children()[i].localName();
				//trace("super: "+_table.children()[i].localName());
				
				
				for(var a:Number=0; a<_options.xml.children()[i].children().length(); a++){
					columns += _options.xml.children()[i].children()[a].localName() + " " +  _options.xml.children()[i].children()[a]   +  (a != _options.xml.children()[i].children().length()-1?",":"");
					//trace("node: "+_table.children()[i].children()[a].localName());
				}
				
				//trace(table + " - " + columns);
				createData = new SQLStatement();
				createData.sqlConnection = conn;
				createData.text = "CREATE TABLE IF NOT EXISTS "+table+" ("+columns+")";
				//trace("CREATE TABLE IF NOT EXISTS "+table+" ("+columns+")");
				
				sqlPool.push(createData);
			}

			pool();
			
		}
		
		//--------------------------------------------------------------- | Poll de commandos SQL
		private function pool():void{
			sqlPool[0].addEventListener(SQLEvent.RESULT, poolled);
			sqlPool[0].execute();
			
		}
		
		private function poolled(evt:SQLEvent):void{
			//trace("Pool-Before "+sqlPool);
			
			sqlPool[0].removeEventListener(SQLEvent.RESULT, poolled);
			sqlPool.splice(0,1);
			
			//trace("Pool-After "+sqlPool);
			
			if(sqlPool.length>0){
				pool();
			}else{
				conn.commit();
			}
		}

		
		//--------------------------------------------------------------- | Apaga Linha
		private function deleteRow():void
		{
			// TODO Auto Generated method stub
			
		}
		
		//--------------------------------------------------------------- | Insere Linha
		private function insertRow():void{
			
			createData = new SQLStatement();
			createData.sqlConnection = conn;
			
			values = "";
			
			for (var i:Number=0; i<_options.value.length; i++) {
				//trace("\tColumn "+i+" - "+table.columns[i].name);
				values += "'" + _options.value[i] + "'"  + (i != _options.value.length-1?",":"");
			}
			
			trace("INSERT INTO "+_options.table+" ("+columns+") " +"VALUES ("+values+")");
			
			createData.text = "INSERT INTO "+_options.table+" ("+columns+") " +"VALUES ("+values+")";
			
			createData.addEventListener(SQLEvent.RESULT, resultHandler);
			
			createData.execute();
			
		}
		
		//--------------------------------------------------------------- | Modifica Linha
		private function updateRow():void
		{
			// TODO Auto Generated method stub
			
		}
		
		//--------------------------------------------------------------- | Seleciona dados da Tabela
		public function selectTable():void{
			
			//tables.tables[0]
			//trace('tabelas:' + tables.tables.length);
			if(_options.table == 'all'){
				loopTables = 0;
				findItem();
			
			}else{
				createData = new SQLStatement();
				createData.sqlConnection = conn;
				
				if(_options.index == null){
					createData.text = "SELECT * FROM " + _options.table;
				}else{
					createData.text = "SELECT * FROM " + _options.table + " WHERE " + _options.index + " = '" + _options.value + "'";
				}
				
				createData.addEventListener(SQLEvent.RESULT, resultHandler);
				//createData.text = "SELECT id,locado FROM cpu";
				//createData.text = "INSERT INTO cpu (marca , processador , ram , hd , barcode , foto , estado , descricao) " +"VALUES ('HP','HP','HP','HP','HP','HP','HP','HP')";
				createData.execute();
			}
			
		}
		
		private function findItem():void
		{
			createData = new SQLStatement();
			createData.sqlConnection = conn;
			createData.text = "SELECT * FROM " + tables.tables[loopTables].name + " WHERE " + _options.index + " = '" + _options.value + "'";
			createData.addEventListener(SQLEvent.RESULT, resultadoParcial);
			//createData.text = "SELECT id,locado FROM cpu";
			//trace("SELECT * FROM " + tables.tables[loopTables].name + " WHERE " + _options.index + " = " + _options.value);
			//createData.text = "INSERT INTO cpu (marca , processador , ram , hd , barcode , foto , estado , descricao) " +"VALUES ('HP','HP','HP','HP','HP','HP','HP','HP')";
			createData.execute();
		}
		
		protected function resultadoParcial(event:SQLEvent):void
		{
			result = createData.getResult().data;
			if(result == null){
				if(loopTables != tables.tables.length-1){
				//	trace('nada');
					loopTables++;
					findItem();
				}else{
					conn.commit();
				}
				
			}else{
				//trace(result[0]);
				tableName = tables.tables[loopTables].name;
				conn.commit();
			}
			
		}
		
		//--------------------------------------------------------------- | Apaga DATABASE
		private function dropTable():void
		{
			conn.close();

			dbFile.deleteFileAsync();			
		
		}
		
		private function deleted(event:Event):void
		{
			trace('database deletada');
			dbFile.removeEventListener(Event.COMPLETE, deleted);
			
			//--------------------------------------------------------------- | Cria Novamente a DATABASE
			_mode = 'CREATE';
			openDatabase();
			
		}
		
		//--------------------------------------------------------------- | Avisa ERRO
		protected function errorHandler(event:SQLErrorEvent):void
		{
			trace(event.toString());
			
			/*if(event.toString().indexOf('open') != -1){
				createTable();
			}*/
		}

		//--------------------------------------------------------------- | Verifica Dados Inseridos/Modificados
		protected function resultHandler(event:SQLEvent):void
		{
			//var result:SQLResult = createData.getResult();
			//trace('resultado: '+result);
			//result = createData.getResult();
			
			result = createData.getResult().data;
			
			//trace("sql result: " + result[1].locado + " length: " + result.length);
			
						
			//for each (var entry:Object in result.data) {
				//data.push(entry.locado);
				//trace("sql result: " + entry);
		//	}
			
			createData.removeEventListener(SQLEvent.RESULT, resultHandler);
			conn.commit();
			
			//trace('Executed')
		}
		
		//--------------------------------------------------------------- | Fecha conexão com a Database
		protected function inserted(event:Event):void
		{
			conn.removeEventListener(SQLEvent.COMMIT, inserted);
			conn.close();
			
			//trace('Commited')
			
		}
		
		//--------------------------------------------------------------- | Fecha Database
		protected function closeSQL(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.CLOSE, closeSQL);
			conn = null;
			
			values = "";
			columns = "";
			
			if(tableName == null){
				tableName = '';
			}
			//trace('Closed')
			
			var pe:propagaEvento = new propagaEvento(propagaEvento.DATABASE, {parsed:result, table:tableName});
			//this.dispatchEvent(new propagaEvento(propagaEvento.DATABASE, {parsed:result, table:tableName}));
			this.dispatchEvent(pe);
			
		}		
	}
}