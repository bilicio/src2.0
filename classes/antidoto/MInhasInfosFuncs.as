package classes.antidoto
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import classes.antidoto.UpdaterEvent;
	
	import feathers.controls.Label;
	import feathers.core.PopUpManager;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;

	public class MInhasInfosFuncs extends EventDispatcher
	{
		private const XML_USER_FILE:File = File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml");
		private const PIN_CONTENT_FILE:File = File.documentsDirectory.resolvePath("familia_scania/dados_user/pin_content.xml");
		
		private var xmlUserFileStream:FileStream;
		private var xmlUserXML:XML;
		
		private static const VALIDADOR_PINCODE:String = "http://dev.antidotodesign.com.br/familia_scania/pin-check";
		private static const PIN_CONTENT_URL:String = "http://dev.antidotodesign.com.br/familia_scania/pin-content";
		
		
		public function MInhasInfosFuncs(){}
		
		public function checasSeOXMLdoUserExisteECriaSeNaoExistir():Boolean
		{
			if (!XML_USER_FILE.exists){
				var xmlTemplate:XML = new XML("<user_infos><user><nome></nome><email></email><telefone></telefone></user><seguro></seguro><anotacoes></anotacoes><pin></pin><icon></icon><max></max><min></min></user_infos>");
				var fileStream:FileStream = new FileStream();
				try{
					fileStream.open(XML_USER_FILE, FileMode.WRITE);
					fileStream.writeUTFBytes(xmlTemplate.toXMLString());
					fileStream.close();
					return true;
				}catch(err){
					return false;
				}
			}else{
				return true;
			}
		}
		
		private function abreXML():void
		{
			xmlUserFileStream = new FileStream();
			xmlUserFileStream.open(XML_USER_FILE, FileMode.READ);
			xmlUserXML = new XML(xmlUserFileStream.readUTFBytes(xmlUserFileStream.bytesAvailable));
			xmlUserFileStream.close();
		}
		
		public function checarValidadeDoPincode(pincode:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, validadorCompleto);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, semConexao);
			urlLoader.load(new URLRequest(VALIDADOR_PINCODE + "?pin=" + pincode));
		}
		
		protected function semConexao(event:IOErrorEvent):void
		{
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.CONEXAO_INDISPONIVEL));
		}
		
		protected function validadorCompleto(event:Event):void
		{
			if (event.target.data == "valido"){
				this.dispatchEvent(new UpdaterEvent(UpdaterEvent.PINCODE_VALIDADO));
			}else{
				this.dispatchEvent(new UpdaterEvent(UpdaterEvent.PINCODE_INVALIDADO));	
			}
		}
		
		public function inserePinCode(pin:String):void
		{
			abreXML();
			xmlUserXML.pin = pin;
			xmlUserFileStream.open(XML_USER_FILE, FileMode.WRITE);
			xmlUserFileStream.writeUTFBytes(xmlUserXML.toXMLString());
			xmlUserFileStream.close();
			var xmlAtracoesFile:File = File.documentsDirectory.resolvePath("familia_scania/xml/atracoes.xml");
			if (xmlAtracoesFile.exists){
				var tempFileStream:FileStream = new FileStream();
				tempFileStream.open(xmlAtracoesFile,FileMode.READ);
				var tempXML:XML = new XML(tempFileStream.readUTFBytes(tempFileStream.bytesAvailable));
				tempFileStream.close();
				tempXML.@ver = "force_update";
				tempFileStream.open(xmlAtracoesFile, FileMode.WRITE);
				tempFileStream.writeUTFBytes(tempXML);
				tempFileStream.close();
				procurarAtualizacao();
			}
			var pinContentUrlLoader:URLLoader = new URLLoader();
			pinContentUrlLoader.addEventListener(Event.COMPLETE, pinContentLoadingComplete);
			pinContentUrlLoader.load(new URLRequest(PIN_CONTENT_URL));
		}
		
		protected function pinContentLoadingComplete(event:Event):void
		{
			var tempXML:XML = new XML(event.target.data);
			var fileStream:FileStream = new FileStream();
			fileStream.open(PIN_CONTENT_FILE, FileMode.WRITE);
			fileStream.writeUTFBytes(tempXML.toXMLString());
			fileStream.close();
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.CONTEUDO_ESPECIFICO_CARREGADO));
		}
		
		public function retornaPinCode():String
		{
			abreXML();
			if(xmlUserXML.pin != null && xmlUserXML.pin != undefined && xmlUserXML.pin != ""){
				return 	xmlUserXML.pin;			
			}else{
				return null;
			}
		}
		
		public function retornaDadosHotel():Object
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(PIN_CONTENT_FILE, FileMode.READ);
			var tempXml:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			var dadosHotel:Object = new Object();
			dadosHotel.nome = tempXml.hotel.nome;
			dadosHotel.endereco = tempXml.hotel.endereco;
			dadosHotel.telefone = tempXml.hotel.telefone;
			
			return dadosHotel;
		}
		
		public function retornaTelefonesUteis():Array
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(PIN_CONTENT_FILE, FileMode.READ);
			var tempXml:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			var telefonesArray:Array = new Array();
			
			for each(var telUtil:Object in tempXml.telefones_uteis.telefone){
				telefonesArray.push({titulo:telUtil.@titulo, tel:telUtil});
			}
			
			return telefonesArray;
		}
		
		public function salvaInfosDoViajante(nome:String,email:String,telefone:String):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.READ);
			var tempXml:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			tempXml.user.nome = nome;
			tempXml.user.email = email;
			tempXml.user.telefone = telefone;
			fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.WRITE);
			fileStream.writeUTFBytes(tempXml.toXMLString());
			fileStream.close();
		}
		
		public function retornaInfosDoViajante():Object
		{
			abreXML();
			var retorno:Object = new Object();
			retorno.nome = xmlUserXML.user.nome;
			retorno.email = xmlUserXML.user.email;
			retorno.telefone = xmlUserXML.user.telefone;
			return retorno;
		}
		
		public function salvarDadosSeguro(dados:String):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.READ);
			var tempXml:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			tempXml.seguro = dados;
			fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.WRITE);
			fileStream.writeUTFBytes(tempXml.toXMLString());
			fileStream.close();
		}
		public function retornaDadosSeguro():String
		{
			abreXML();
			return String(xmlUserXML.seguro);
		}
		
		public function salvarAnotacoes(anotacao:String):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.READ);
			var tempXml:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			tempXml.anotacoes = anotacao;
			fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.WRITE);
			fileStream.writeUTFBytes(tempXml.toXMLString());
			fileStream.close();
		}
		
		public function retornaAnotacoes():String
		{
			abreXML();
			return String(xmlUserXML.anotacoes);
		}
		
		public function enviaFormulario(email:String, nome:String, telefone:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlLrequest:URLRequest = new URLRequest("http://dev.antidotodesign.com.br/familia_scania/formulario-avaliacao");
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.nome = nome;
			urlVariables.email = email;
			urlVariables.telefone = telefone;
			urlLrequest.method = "POST";
			urlLrequest.data = urlVariables;
			urlLoader.addEventListener(Event.COMPLETE, requestCompleto);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, semConexao);
			urlLoader.load(urlLrequest);
		}
		
		protected function requestCompleto(event:Event):void
		{
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.FORMULARIO_ENVIADO));
		}
		
		private var label:Label;
		private var timerDC:DelayedCall;
		
		private function procurarAtualizacao():void
		{
			/*trace('INICIO');
		
			label = new Label;
			label.text = 'Procurando atualizações. Aguarde.';
			
			PopUpManager.addPopUp(label);*/
			
			var updaterFS:UpdaterFSZIP;
			
			updaterFS = new UpdaterFSZIP();
			updaterFS.addEventListener(UpdaterEvent.UPDATE_INICIADO, updateIniciado);
			updaterFS.addEventListener(UpdaterEvent.CHECAGEM_COMPLETA, checagemCompleta);
			updaterFS.addEventListener(UpdaterEvent.UPDATE_COMPLETO, updateCompleto);
			updaterFS.addEventListener(UpdaterEvent.CONEXAO_INDISPONIVEL, checagemComFalhaPorCausaDaInternet);
			
			updaterFS.ChecarVersao();
			
			
			
		}
		
		protected function updateIniciado(event:UpdaterEvent):void
		{
			//if(!label){
			//	label = new Label;
			//label.text = "Executando atualização. Por favor aguarde.";
			
			//timerDC = new DelayedCall(muitasImagensFalhadas, 20);
			//Starling.juggler.add(timerDC);
			//PopUpManager.addPopUp(label);
			//}
		}
		
		protected function updateCompleto(event:UpdaterEvent):void
		{
			//cont++;
			//removePopup();
			//updaterFS.addEventListener(UpdaterEvent.UPDATE_COMPLETO, updateCompleto);
			
		/*	NativeAlertDialog.showAlert('Atualização', 'Aplicativo atualizado com sucesso.',  Vector.<String>(['OK']), 
				function someAnswerFunction(event:NativeDialogEvent):void{});*/
			
			//label.text = "Aplicativo atualizado com sucesso.";
			
			timerDC = new DelayedCall(removePopup, 2);
			Starling.juggler.add(timerDC);
			
			//trace('CONT: ' + cont);
			
			//if(cont == 1){
			Assets.removeAndRearmTextures();	
			//}
			
			
		}
		
		protected function checagemCompleta(event:UpdaterEvent):void
		{
			//removePopup();
			label.text = "seu aplicativo já está atualizado.";
			
			timerDC = new DelayedCall(removePopup, 1);
			Starling.juggler.add(timerDC);
			
		}
		
		protected function checagemComFalhaPorCausaDaInternet(event:UpdaterEvent):void
		{
			//removePopup();
			/*label.text = "Não foi possível atualizar seu aplicativo.\nPor favor verifique sua conexão com a internet.";
			
			timerDC = new DelayedCall(removePopup, 1);
			Starling.juggler.add(timerDC);*/
			/*NativeAlertDialog.showAlert('Você precisa de um sinal de Internet estável', 'Erro de Conexão',  Vector.<String>(['OK']), 
				function someAnswerFunction(event:NativeDialogEvent):void{});*/
		}
		
		protected function muitasImagensFalhadas():void
		{
			//removePopup();
			if(label){
				label.text = "Erro no download de algumas imagens.\nTente novamente mais tarde.";
				
				timerDC = new DelayedCall(removePopup, 1);
				Starling.juggler.add(timerDC);
			}
		}
		
		
		private function removePopup():void
		{
			try{
				PopUpManager.removePopUp(label);
			}catch(e:Error){};
			
		}
		
	}
}