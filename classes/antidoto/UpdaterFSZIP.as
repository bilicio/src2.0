package classes.antidoto
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import feathers.controls.Label;
	import feathers.core.PopUpManager;
	
	import org.as3commons.zip.Zip;
	//import org.as3commons.zip.ZipFile;
	
	//import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	//import pl.mateuszmackowiak.nativeANE.dialogs.NativeProgressDialog;
	//import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	
	[Event(name="checagem_completa", type="classes.antidoto.UpdaterEvent")]
	[Event(name="checagem_iniciada", type="classes.antidoto.UpdaterEvent")]
	[Event(name="update_completo", type="classes.antidoto.UpdaterEvent")]
	[Event(name="conexao_indisponivel", type="classes.antidoto.UpdaterEvent")]
	[Event(name="assets_carregados", type="classes.antidoto.UpdaterEvent")]
	
	public class UpdaterFSZIP extends EventDispatcher
	{	
		private const RAIZ_SERVIDOR_IMG:String = "http://dev.antidotodesign.com.br/queiroz_galvao/update/img/";
	
		private const UPDATE_URL_DICAS:String = "http://dev.antidotodesign.com.br/queiroz_galvao/update-dicas/?ver=" + (Math.random() * 1000);
		private const UPDATE_URL_CLIMA:String = "http://dev.antidotodesign.com.br/queiroz_galvao/clima?ver=" + (Math.random() * 1000);
		//private const UPDATE_URL_DICAS:String = "http://dev.antidotodesign.com.br/familia_scania/update/dicas.xml";
		//private const UPDATE_URL_CLIMA:String = "http://dev.antidotodesign.com.br/familia_scania/update/weather.xml";
		
		private var UPDATE_URL_ATRACOES:String;

		private var diretorioRaiz:File = File.documentsDirectory.resolvePath("queiroz_galvao");
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
		
		private var labelInfo:Label;
		
		//private var progressPopup:NativeProgressDialog;
		
		private var progressFile:Number = 0;
		
		
		public function UpdaterFSZIP(target:IEventDispatcher=null)
		{
			minhasInfosFuncs = new MInhasInfosFuncs();
			minhasInfosFuncs.checasSeOXMLdoUserExisteECriaSeNaoExistir();
		}
		
		public function verificaSeEaPrimeiraInicializacaoOuSeEstaFaltandoCoisasEssenciais():Boolean
		{
			if (!diretorioRaiz.exists){
				return true;
			}else{
				if (!diretorioRaiz.resolvePath("xml/empreendimentos.xml").exists){
					return true;
				}
			}
			return false;
		}
		
		public function ChecarVersao():void
		{

			UPDATE_URL_ATRACOES = "http://dev.antidotodesign.com.br/queiroz_galvao/update-atracoes/?ver=" + (Math.random() * 1000);
			//UPDATE_URL_ATRACOES = "http://dev.antidotodesign.com.br/familia_scania/update/atracoes.php?ver=" + (Math.random() * 1000);

			atualizacaoArray = [
				{local: diretorioRaiz.resolvePath("xml/empreendimentos.xml"),online:UPDATE_URL_ATRACOES}
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
				diretorioRaiz.resolvePath("xml").createDirectory();
			}else{
				if (!diretorioRaiz.resolvePath("xml").exists){
					diretorioRaiz.resolvePath("xml").createDirectory();
					diretorioRaiz.resolvePath("xml").preventBackup = true;
				}
			}
		}
		
		public function VerificaAtualizacao():void
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, alertaUsuario);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, falhaDeInternet);
			urlLoader.load(new URLRequest( "http://dev.antidotodesign.com.br/queiroz_galvao/update-atracoes/?ver=" + (Math.random() * 1000)));
		}
		
		protected function alertaUsuario(evt:Event):void
		{
			xmlDoServer = new XML(evt.target.data);
			trace('ALERTA');
			var fileStream:FileStream = new FileStream();
				fileStream.open(diretorioRaiz.resolvePath("xml/empreendimentos.xml"), FileMode.READ);
			var localTempXML:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable).toString());
		
			
			if (localTempXML.@ver != xmlDoServer.@ver){
				try{
				/*NativeAlertDialog.showAlert('Novo conteúdo disponível, atualizar?', 'Atualização',  Vector.<String>(['Sim','Não']), 
					function someAnswerFunction(event:NativeDialogEvent):void{
						
						//trace('index: ' + event.index);
						if(event.index == '0'){
							ChecarVersao();
						}
					});*/
				}catch(err){trace('Novo conteúdo disponível - Atualizando');ChecarVersao();};
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
				var fileStream:FileStream = new FileStream();
				fileStream.open(arquivoLocal, FileMode.READ);
				
				var localTempXML:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable).toString());
				if (localTempXML.@ver == xmlDoServer.@ver){
					fileStream.close();
					cont++
					if(cont == 4){	
						dispatchEvent(new UpdaterEvent(UpdaterEvent.CHECAGEM_COMPLETA));
						//sincronizarImagens(); // ***************************************************** TESTE
					}
				}else{
					fileStream.close();
					
					CopiaXMlDoServerParaOLocal(xmlDoServer,arquivoLocal);
					if (xmlDoServer.atracao[0] != undefined){
						dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_INICIADO));
						//sincronizarImagens();
					}
					
				}
								
			}else{
				CopiaXMlDoServerParaOLocal(xmlDoServer, arquivoLocal);
			}
		}
		
		private function CopiaXMlDoServerParaOLocal(serverXML:XML, localXML:File):void
		{
			//trace('doSErver');
			try{
				var fileStream:FileStream = new FileStream();
				fileStream.open(localXML, FileMode.WRITE);
				fileStream.writeUTFBytes(serverXML.toString());
				fileStream.close();
				//if (serverXML.atracao[0] != undefined){
				sincronizarImagens();
				//}
			}catch(err){};
			
		}
		
		private var myZip:Zip;
		private var arquivo:File;
		
		private function sincronizarImagens():void
		{
			
		/*	try{
			var p:NativeProgressDialog = new NativeProgressDialog();
			
	
				//p.iosTheme = 7;
			
				p.addEventListener(NativeDialogEvent.CLOSED, onCloseDialog);
				p.addEventListener(NativeDialogEvent.CANCELED, trace);
				p.addEventListener(NativeDialogEvent.OPENED, trace);
				p.max = 100;
				//p.secondaryProgress = 45;
				p.title = "Download dos Arquivos";
				p.message ="Atualizando";
				//p.shake();
				
				p.showProgressbar();
			
			progressPopup = p;
			
			}catch(err){};*/
			//progressPopup = p;
			
			
		/*	labelInfo = new Label;
			labelInfo.nameList.add('default');
			labelInfo.text = 'Fazendo o Download dos arquivos.\nIsso pode levar alguns minutos aguarde...';
			PopUpManager.addPopUp(labelInfo);*/
			

			arquivo = File.documentsDirectory.resolvePath("queiroz_galvao/qg.zip");
			arquivo.preventBackup = true;
			
			trace('Downloading');
			
			myZip = new Zip(arquivo.url);
			myZip.addEventListener(ProgressEvent.PROGRESS, progresso);
			myZip.addEventListener(IOErrorEvent.IO_ERROR, erro);
			myZip.addEventListener(Event.COMPLETE, terminou);
			myZip.addEventListener(HTTPStatusEvent.HTTP_STATUS, status);
			myZip.load(new URLRequest('http://dev.antidotodesign.com.br/queiroz_galvao/update/zip/qg.zip'));
				
			
			
		}
		
		//private function onCloseDialog(event:NativeDialogEvent):void
	//	{
			//var m:iNativeDialog = iNativeDialog(event.target);
			/*try{
				progressPopup.removeEventListener(NativeDialogEvent.CLOSED, onCloseDialog);
				progressPopup.removeEventListener(NativeDialogEvent.CANCELED,trace);
				progressPopup.removeEventListener(NativeDialogEvent.OPENED,trace);
				progressPopup.dispose();
			}catch(err){};*/
		//}
		
		protected function status(event:HTTPStatusEvent):void
		{
			trace('status: ' + event.status);
		}
		
		private var saveCont:Number = 0;
		protected function terminou(event:Event):void
		{
			
			/*saveCont = 0;
			
			var byte:ByteArray = new ByteArray();
			myZip.serialize(byte);
			
			
			syncXMLFileStream = new FileStream();
			syncXMLFileStream.open(atualizacaoArray[3].local, FileMode.READ);
			syncXML = new XML(syncXMLFileStream.readUTFBytes(syncXMLFileStream.bytesAvailable));
			syncXMLFileStream.close();
			
			for (var a:int = 0; a < syncXML.img_avulsa.length(); a++){
				var fileImage2:ZipFile = myZip.getFileByName(syncXML.img_avulsa[a]);
				arquivo = File.documentsDirectory.resolvePath("queiroz_galvao/img/" + syncXML.img_avulsa[a]);
				
				try{
					var saveFile2:FileStream = new FileStream();
						saveFile2.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
						//saveFile2.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, imagensCopiadas);
						//saveFile2.addEventListener(Event.COMPLETE, copiada)
						//saveFile2.addEventListener(Event.CLOSE, onEventClose);
						saveFile2.openAsync(arquivo, FileMode.UPDATE);
						saveFile2.writeBytes(fileImage2.content, 0, fileImage2.content.bytesAvailable);
						saveFile2.close();
						
						//saveCont++;
				}catch(err){trace('erro: ' + err.target);saveCont--;};
				
			}
			
			for (var i:int = 0; i < syncXML.atracao.length(); i++){
				var fileImage:ZipFile = myZip.getFileByName(syncXML.atracao[i].@img);
				arquivo = File.documentsDirectory.resolvePath("queiroz_galvao/img/" + syncXML.atracao[i].@img);
				
				try{
					var saveFile:FileStream = new FileStream();
						saveFile.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
						//saveFile.addEventListener(Event.COMPLETE, imagensCopiadas)
						//saveFile.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, imagensCopiadas);
						//saveFile.addEventListener(Event.CLOSE, onEventClose);
						saveFile.open(arquivo, FileMode.UPDATE);
						saveFile.writeBytes(fileImage.content, 0, fileImage.content.bytesAvailable);
						saveFile.close();
						
						saveCont++;
						
				}catch(err){trace('erro: ' + err.target);saveCont--;};
				
			}
			
			*/

			trace('acabou imagens');

			onEventClose();

		}
		
		private function onEventClose(event:Event = null):void
		{
			//trace(saveCont + " | " + cont);
			//if(saveCont == cont){
				//saveCont = 0;
				//cont = 0;
				//dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
				
				trace('TERMINO');
				//File.documentsDirectory.resolvePath("familia_scania/mapa.zip")
				/*if (!File.cacheDirectory.resolvePath("mapa.zip").exists){
					urlLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, mapaDownload);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, falhaDeInternet);
					urlLoader.load(new URLRequest('http://dev.antidotodesign.com.br/queiroz_galvao/update/zip/mapa.xml'));
				}else{*/
					//dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
					/*try{
						progressPopup.hide(1);
						//PopUpManager.removePopUp(labelInfo);
					}catch(e:Error){};*/
					
					//onCloseDialog();
					terminouMapa();
					//dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
				//}
			//}
			
		}
		
		public function downloadMapa():void{
		/*	try{
				NativeAlertDialog.showAlert('Você esta sem o mapa, deseja baixá-lo?', 'MAPA',  Vector.<String>(['Sim','Não']), 
					function someAnswerFunction(event:NativeDialogEvent):void{
						
						//trace('index: ' + event.index);
						if(event.index == '0'){
							forceDownloadMapa()
						}
					});
			}catch(err){trace('Novo conteúdo disponível - Atualizando');ChecarVersao();};*/
		}
		
		private function forceDownloadMapa():void
		{
				
			/*var p:NativeProgressDialog = new NativeProgressDialog();

				p.addEventListener(NativeDialogEvent.CLOSED, onCloseDialog);
				p.addEventListener(NativeDialogEvent.CANCELED, trace);
				p.addEventListener(NativeDialogEvent.OPENED, trace);
				p.max = 100;
				//p.secondaryProgress = 45;
				p.title = "Download do Mapa";
				p.message ="Baixando";
				//p.shake();
				
				p.showProgressbar();
			
			progressPopup = p;*/
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, mapaDownload);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, falhaDeInternet);
			urlLoader.load(new URLRequest('http://dev.antidotodesign.com.br/queiroz_galvao/update/zip/mapa.xml'));

			
		}
		
	/*	private function imagensCopiadas(evt:OutputProgressEvent):void
		{
			if (evt.bytesPending == 0) { cont++; }
			//trace(cont + " | " + saveCont);
			
			// TODO Auto-generated method stub
			//if(event.bytesPending == 0){}
			
		}*/
		
		private var mapaXml:XML;
		private var myZip2:Zip;
		private var arquivo2:File;
		
		private function mapaDownload(evt:Event = null):void
		{
			var fileStream:FileStream = new FileStream();
			//fileStream.open(File.documentsDirectory.resolvePath("familia_scania/xml/mapa.xml"), FileMode.READ);
			mapaXml = new XML(evt.target.data);
			
			arquivo2 = File.cacheDirectory.resolvePath("queiroz_galvao/mapa.zip");
			
			myZip2 = new Zip(arquivo2.url);
			myZip2.addEventListener(ProgressEvent.PROGRESS, progresso2);
			myZip2.addEventListener(IOErrorEvent.IO_ERROR, erro2);
			myZip2.addEventListener(Event.COMPLETE, terminouMapa);
			myZip2.addEventListener(HTTPStatusEvent.HTTP_STATUS, status);
			myZip2.load(new URLRequest('http://dev.antidotodesign.com.br/queiroz_galvao/update/zip/mapa.zip'));

			
		}
		
		private var numTimes:Number = 0;
		private function terminouMapa():void
		{
			//if(numTimes == 0){
				var byte:ByteArray = new ByteArray();
				myZip.serialize(byte);
				
				
				//var fileImage:ZipFile = myZip2.getFileByName(mapaXml.children()[a].@pasta+'/'+mapaXml.children()[a].children()[b].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].children()[d].@nome);
				var saveFileMapa:FileStream = new FileStream();
					saveFileMapa.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
					//saveFileMapa.addEventListener(Event.COMPLETE, copiada)
					saveFileMapa.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, mapaCopiado);
					//saveFileMapa.open(arquivo2, FileMode.UPDATE);
					saveFileMapa.openAsync(arquivo, FileMode.UPDATE);
					saveFileMapa.writeBytes(byte, 0, byte.bytesAvailable);
					saveFileMapa.close();
				
					
					try{
						PopUpManager.removePopUp(labelInfo);
					}catch(e:Error){};
				
				/*for (var a:int = 0; a < mapaXml.children().length(); a++){
					if(mapaXml.children()[a].localName() == "folder"){
						//trace(mapaXml.children()[a].@pasta);
						diretorioRaiz.resolvePath(mapaXml.children()[a].@pasta).createDirectory();
					}else{
						//trace(mapaXml.children()[a].@nome);
					}
					
					for (var b:int = 0; b < mapaXml.children()[a].children().length(); b++){
						if(mapaXml.children()[a].children()[b].localName() == "folder"){
							//trace(mapaXml.children()[a].children()[b].@pasta);
							diretorioRaiz.resolvePath(mapaXml.children()[a].@pasta+'/'+mapaXml.children()[a].children()[b].@pasta).createDirectory();
						}else{
							//trace(mapaXml.children()[a].children()[b].@nome);
						}
						
						for (var c:int = 0; c < mapaXml.children()[a].children()[b].children().length(); c++){
							if(mapaXml.children()[a].children()[b].children()[c].localName() == "folder"){
								//trace(mapaXml.children()[a].children()[b].children()[c].@pasta);
								diretorioRaiz.resolvePath(mapaXml.children()[a].@pasta+'/'+mapaXml.children()[a].children()[b].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].@pasta).createDirectory();
							}else{
								//trace(mapaXml.children()[a].children()[b].children()[c].@nome);
							}
						
							for (var d:int = 0; d < mapaXml.children()[a].children()[b].children()[c].children().length(); d++){
								if(mapaXml.children()[a].children()[b].children()[c].children()[d].localName() == "folder"){
									//trace(mapaXml.children()[a].children()[b].children()[c].children()[d].@pasta);
								}else{
									//trace('lenght: ' + mapaXml.children()[a].children()[b].children()[c])
									//trace(mapaXml.children()[a].children()[b].children()[c].children()[d].@nome);
									
									arquivo2 = diretorioRaiz.resolvePath(mapaXml.children()[a].@pasta+'/'+mapaXml.children()[a].children()[b].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].children()[d].@nome)
									//arquivo = File.documentsDirectory.resolvePath("familia_scania/"+mapaXml.children()[a].children()[b].children()[c].children()[d].@nome);
									
									try{
										var fileImage:ZipFile = myZip2.getFileByName(mapaXml.children()[a].@pasta+'/'+mapaXml.children()[a].children()[b].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].@pasta+'/'+mapaXml.children()[a].children()[b].children()[c].children()[d].@nome);
										var saveFileMapa:FileStream = new FileStream();
											saveFileMapa.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
											//saveFileMapa.addEventListener(Event.COMPLETE, copiada)
											saveFileMapa.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, mapaCopiado);
											//saveFileMapa.open(arquivo2, FileMode.UPDATE);
											saveFileMapa.openAsync(arquivo2, FileMode.UPDATE);
											saveFileMapa.writeUTFBytes(fileImage.content.toString());
											saveFileMapa.close();
											numTimes++
									}catch(err){numTimes--};
								}
								
							}	
							
							
						}*/
						
						
						
						
					//}
					//trace(mapaXml.length());
					//trace('length: ' + mapaXml.length());
					/*var fileImage:ZipFile = myZip.getFileByName(syncXML.atracao[i].@img);
					arquivo = File.documentsDirectory.resolvePath("familia_scania/img/" + syncXML.atracao[i].@img);
					
					try{
						var saveFile:FileStream = new FileStream();
						//saveFile.addEventListener(IOErrorEvent.IO_ERROR, falhaEmCarregamentoDeImagem);
						saveFile.addEventListener(Event.COMPLETE, copiada)
						saveFile.open(arquivo, FileMode.WRITE);
						saveFile.writeBytes(fileImage.content, 0, fileImage.content.bytesAvailable);
						saveFile.close();
					}catch(err){};*/
					
				//}
			//}
				
			//numTimes++
			
			//myZip.loadBytes(byte);
			
			/*trace('tamanho: ' + myZip.getFileCount());
			
			
			var saveZip:FileStream = new FileStream();
			saveZip.open(arquivo, FileMode.WRITE);
			saveZip.writeBytes(byte, 0, byte.bytesAvailable);
			saveZip.close();*/
			//dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
			
			trace('FINISHED');
		}
		
		private var contMapa:Number = 0;
		/*private function copiada(evt:Event):void
		{
			contMapa++;
			trace('copiada: -> ' + contMapa);
			//if (evt.bytesPending == 0) { contMapa++; trace('copiada: -> ' + contMapa);}
			//trace('copiada: -> ' + cont++);
			// TODO Auto-generated method stub
			//if(event.bytesPending == 0){}
			
			if(numTimes == contMapa){
				trace('acabou mapa')
			}
			
		}*/
		private function mapaCopiado(evt:OutputProgressEvent):void
		{
			//trace('ZIP MAPA CRIADO 0');
			if (evt.bytesPending == 0) {
				trace('ZIP MAPA CRIADO');
				//arquivo2.preventBackup = true;
				//progressPopup.hide(1);
				dispatchEvent(new UpdaterEvent(UpdaterEvent.UPDATE_COMPLETO));
				//dispatchEvent(new UpdaterEvent(UpdaterEvent.ZIPDOWNLOADED));
			}
			
			/*if(numTimes == contMapa){
				trace('acabou mapa')
			}*/
			
		}
		
		protected function erro(event:IOErrorEvent):void
		{
			trace('ERRO');
			
			/*try{
				//PopUpManager.removePopUp(labelInfo);
				progressPopup.hide(1);
				//onCloseDialog();
			}catch(e:Error){};*/

			var xmlAtracoesFile:File = File.documentsDirectory.resolvePath("queiroz_galvao/xml/empreendimentos.xml");
			if (xmlAtracoesFile.exists){
				var tempFileStream:FileStream = new FileStream();
				tempFileStream.open(xmlAtracoesFile,FileMode.READ);
				var tempXML:XML = new XML(tempFileStream.readUTFBytes(tempFileStream.bytesAvailable));
				tempFileStream.close();
				tempXML.@ver = "force_update";
				tempFileStream.open(xmlAtracoesFile, FileMode.WRITE);
				tempFileStream.writeUTFBytes(tempXML);
				tempFileStream.close();
			}
			
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.CONEXAO_INDISPONIVEL));
			
		}
		
		protected function erro2(event:IOErrorEvent):void
		{
			
			/*try{
				//PopUpManager.removePopUp(labelInfo);
				progressPopup.hide(1);
				//onCloseDialog();
			}catch(e:Error){};
			
			trace('ERRO');
			myZip2.close();
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.CONEXAO_INDISPONIVEL));
			//arquivo2.deleteFile();*/
			
		}
		
		protected function progresso(event:ProgressEvent):void
		{
			progressFile = Math.round((100*event.bytesLoaded) / event.bytesTotal);
			trace('Atualizando ' + progressFile + '%');
			
			/*try{
				//progressPopup.setTitle("OK");
				progressPopup.setMessage('Atualizando ' + progressFile + '%');
				
				//progressPopup.setMessage("atualizando " + Math.round((100*event.bytesLoaded) / event.bytesTotal) + "%");
				progressPopup.setProgress(progressFile);
			}catch(e:Error){};*/
			
			//labelInfo.text = 'Download dos Arquivos\nAtualizando: '+Math.round((100*event.bytesLoaded) / event.bytesTotal).toString() + '%';
			//trace('target: ' + event. + " currentTarget: " + event.currentTarget.name);
			
		}
		
		protected function progresso2(event:ProgressEvent):void
		{
			/*progressFile = Math.round((100*event.bytesLoaded) / event.bytesTotal);
			progressPopup.setMessage("Baixando Mapa " + progressFile + "%");
			progressPopup.setProgress(progressFile);*/
			//labelInfo.text = 'Download do Mapa\nBaixando: '+Math.round((100*event.bytesLoaded) / event.bytesTotal).toString() + '%';
			//trace('target: ' + event. + " currentTarget: " + event.currentTarget.name);
			
		}

		
		private function falhaDeInternet(evt:Event):void
		{
			//trace('FALHA INERNET');
			this.dispatchEvent(new UpdaterEvent(UpdaterEvent.CONEXAO_INDISPONIVEL));
		}
		
		protected function falhaEmCarregamentoDeImagem(event:IOErrorEvent):void
		{
			//trace("falha em carregamento de imagem " + event.currentTarget);
			/*try{
				//byteArraysArrayPesadaPraca.push({arquivo:null, byteArray:null});
			}catch(err){};*/
		}
		
	}
}