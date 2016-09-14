package classes.antidoto
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	
	[Event(name="checagem_completa", type="classes.antidoto.UpdaterEvent")]
	[Event(name="checagem_iniciada", type="classes.antidoto.UpdaterEvent")]
	[Event(name="update_completo", type="classes.antidoto.UpdaterEvent")]
	[Event(name="conexao_indisponivel", type="classes.antidoto.UpdaterEvent")]
	[Event(name="assets_carregados", type="classes.antidoto.UpdaterEvent")]
	
	public class UpdaterFS extends EventDispatcher
	{	
		private const RAIZ_SERVIDOR_IMG:String = "http://dev.antidotodesign.com.br/familia_scania/update/img/";
	
		private const UPDATE_URL_DICAS:String = "http://dev.antidotodesign.com.br/familia_scania/update-dicas/?ver=" + (Math.random() * 1000);
		private const UPDATE_URL_CLIMA:String = "http://dev.antidotodesign.com.br/familia_scania/clima?ver=" + (Math.random() * 1000);
		private var UPDATE_URL_ATRACOES:String;

		private var diretorioRaiz:File = File.documentsDirectory.resolvePath("familia_scania");
		private var atualizacaoArray:Array;
		
		private var urlLoader:URLLoader;
		private var fileStream:FileStream;
		private var xmlDoServer:XML;
		
		private var syncXMLFileStream:FileStream;
		private var syncXML:XML;
		private var copiadorDeImagemFS:FileStream;
		
		private var byteArraysArrayPesadaPraca:Array;
		private var syncIMGFileStream:FileStream;
		
		private var horaDeCopiar:Boolean = false;
		
		private var minhasInfosFuncs:MInhasInfosFuncs;
		private var pinCode:String;
		
		private var cont:Number = 0;
		
		public function UpdaterFS(target:IEventDispatcher=null)
		{
			minhasInfosFuncs = new MInhasInfosFuncs();
			minhasInfosFuncs.checasSeOXMLdoUserExisteECriaSeNaoExistir();
		}
		
		public function verificaSeEaPrimeiraInicializacaoOuSeEstaFaltandoCoisasEssenciais():Boolean
		{
			if (!diretorioRaiz.exists){
				return true;
			}else{
				if (!diretorioRaiz.resolvePath("xml/atracoes.xml").exists || !diretorioRaiz.resolvePath("xml/dicas.xml").exists){
					return true;
				}
			}
			return false;
		}
		
		public function ChecarVersao():void
		{
			pinCode = minhasInfosFuncs.retornaPinCode();
			
			trace('checa');
			
			if (pinCode != null){
				UPDATE_URL_ATRACOES = "http://dev.antidotodesign.com.br/familia_scania/update-atracoes/?ver=" + (Math.random() * 1000) + "&pincode=" + pinCode;
			}else{
				UPDATE_URL_ATRACOES = "http://dev.antidotodesign.com.br/familia_scania/update-atracoes/?ver=" + (Math.random() * 1000);
			}
			
			atualizacaoArray = [
				{local:diretorioRaiz.resolvePath("xml/dicas.xml"),online:UPDATE_URL_DICAS},
				{local: diretorioRaiz.resolvePath("xml/atracoes.xml"),online:UPDATE_URL_ATRACOES},
				{local: diretorioRaiz.resolvePath("xml/weather.xml"),online:UPDATE_URL_CLIMA},
				{local: diretorioRaiz.resolvePath("xml/mapMarkers.xml"),online:"http://dev.antidotodesign.com.br/familia_scania/update/assets/mapMarkers.xml"}
			];
			
			checaEstruturaDePastas();
			
			for each(var itemPraAtualizar:Object in atualizacaoArray){
				carregaXMLDoServer(itemPraAtualizar.local, itemPraAtualizar.online);
			}
		}
		
		private function checaEstruturaDePastas():void
		{
			if (!diretorioRaiz.exists){
				diretorioRaiz.createDirectory();
				diretorioRaiz.preventBackup = true;
				diretorioRaiz.resolvePath("img").createDirectory();
				diretorioRaiz.resolvePath("xml").createDirectory();
			}else{
				if (!diretorioRaiz.resolvePath("img").exists){
					diretorioRaiz.resolvePath("img").createDirectory();
				}
				if (!diretorioRaiz.resolvePath("xml").exists){
					diretorioRaiz.resolvePath("xml").createDirectory();
				}
			}
		}
		
		private function carregaXMLDoServer(arquivoLocal:File, arquivoOnline:String):void
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlCarregado(arquivoLocal));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, falhaDeInternet);
			urlLoader.load(new URLRequest(arquivoOnline));
		}
		
		private function xmlCarregado(arquivoLocal:File):Function
		{
			return function(evt:Event):void{
				xmlDoServer = new XML(evt.target.data);
				ChecaArquivoLocalECriaSeNaoExistir(arquivoLocal);
			}
		}
		
		private function ChecaArquivoLocalECriaSeNaoExistir(arquivoLocal:File):void
		{
			
			if (arquivoLocal.exists){
				fileStream = new FileStream();
				fileStream.open(arquivoLocal, FileMode.READ);
				
				var localTempXML:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable).toString());
				if (localTempXML.@ver == xmlDoServer.@ver){
					fileStream.close();
					cont++
					if(cont == 4){	
						dispatchEvent(new UpdaterEvent(UpdaterEvent.CHECAGEM_COMPLETA));
					}
				}else{
					fileStream.close();
					
					CopiaXMlDoServerParaOLocal(xmlDoServer,arquivoLocal);
					if (xmlDoServer.atracao[0] != undefined){
						dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_INICIADO));
						sincronizarImagens();
					}
					
				}
								
			}else{
				CopiaXMlDoServerParaOLocal(xmlDoServer, arquivoLocal);
			}
		}
		
		private function CopiaXMlDoServerParaOLocal(serverXML:XML, localXML:File):void
		{
			fileStream = new FileStream();
			fileStream.open(localXML, FileMode.WRITE);
			fileStream.writeUTFBytes(serverXML.toString());
			fileStream.close();
			if (serverXML.atracao[0] != undefined){
				sincronizarImagens();
			}
			
		}
		
		private function sincronizarImagens():void
		{
			
			syncXMLFileStream = new FileStream();
			syncXMLFileStream.open(atualizacaoArray[1].local, FileMode.READ);
			syncXML = new XML(syncXMLFileStream.readUTFBytes(syncXMLFileStream.bytesAvailable));
			syncXMLFileStream.close();
			
			copiadorDeImagemFS = new FileStream();
			byteArraysArrayPesadaPraca = new Array();
			
			for (var i:int = 0; i < syncXML.atracao.length(); i++){
				trace('carregando: ' + i);
				var syncImgUrlLoader:URLLoader = new URLLoader();
				syncImgUrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				syncImgUrlLoader.addEventListener(Event.COMPLETE, imgCarregada(syncXML.atracao[i].@img));
				syncImgUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
				syncImgUrlLoader.load(new URLRequest( RAIZ_SERVIDOR_IMG + syncXML.atracao[i].@img));
				
			}
			
			for (var f:int = 0; f < syncXML.img_avulsa.length(); f++){
				var syncImgUrlLoaderAvulso:URLLoader = new URLLoader();
				syncImgUrlLoaderAvulso.dataFormat = URLLoaderDataFormat.BINARY;
				syncImgUrlLoaderAvulso.addEventListener(Event.COMPLETE, imgCarregada(syncXML.img_avulsa[f]));
				syncImgUrlLoaderAvulso.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
				syncImgUrlLoaderAvulso.load(new URLRequest( RAIZ_SERVIDOR_IMG + syncXML.img_avulsa[f]));
			}
			
			
		}

		protected function imgCarregada(arquivoDaVez:String):Function
		{
			return function (event:Event):void{
				var arquivo:File = File.documentsDirectory.resolvePath("familia_scania/img/" + arquivoDaVez);
				byteArraysArrayPesadaPraca.push({arquivo:arquivo, byteArray:event.target.data});
				trace('arquivo: ' + arquivoDaVez);
				if (byteArraysArrayPesadaPraca.length == (syncXML.atracao.length() + syncXML.img_avulsa.length())){
					CopiarImagensParaODisco();
				}
			}
		}		
		
		private function CopiarImagensParaODisco():void
		{
			cont = 0;
			
			syncIMGFileStream = new FileStream();
			for each(var imgObj:Object in byteArraysArrayPesadaPraca){
				if (imgObj.arquivo != null){
					try{
						trace('nome:' + (imgObj.arquivo as File).name + ' ultimo: ' + byteArraysArrayPesadaPraca[cont].arquivo.name + ' contagem:'+cont + ' total:' + byteArraysArrayPesadaPraca.length);
						syncIMGFileStream.addEventListener(Event.COMPLETE, imgOK);
						syncIMGFileStream.open(imgObj.arquivo as File, FileMode.WRITE);
						syncIMGFileStream.writeBytes(imgObj.byteArray as ByteArray, 0, (imgObj.byteArray as ByteArray).length);
						syncIMGFileStream.close();

					}catch(err){trace("falha em salvar a imagem " + err.target);}
					cont++
					
				}
			}
			
			if(byteArraysArrayPesadaPraca.length - cont < 4){
				dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
			}
			
		}
		
		protected function imgOK(event:Event):void
		{
			/*cont++;
			trace(cont);
			if(byteArraysArrayPesadaPraca.length - cont < 4){
				dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
			}*/
			
		}
		
		private function falhaDeInternet(evt:Event):void
		{
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.CONEXAO_INDISPONIVEL));
		}
		
		protected function falhaEmCarregamentoDeImagem(event:IOErrorEvent):void
		{
			trace("falha em carregamento de imagem " + event.target);
			byteArraysArrayPesadaPraca.push({arquivo:null, byteArray:null});
		}
		
	}
}