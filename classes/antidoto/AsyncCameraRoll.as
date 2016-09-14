package classes.antidoto
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class AsyncCameraRoll extends EventDispatcher
	{
		private var _mediaPromisse:MediaPromise;
		
		private var dataSource:IDataInput; 
		private var eventSource:IEventDispatcher;
		
		public var bitmapData:BitmapData;
		public var molduraBitmapData:BitmapData;
		
		private var urlRequestDaMoldura:URLRequest;
		
		private var cameraRoll:CameraRoll;
		
		public var xmlGaleria:XML;
		
		public var urlDoArquivoCarregadoComCamRollNativo:String;
		
		private var loader:Loader;
		private var urlLoader:URLLoader;
		
		private var mFileReference:FileReference;
		
		public function get mediaPromisse():MediaPromise
		{
			return _mediaPromisse;
		}
		
		public function set mediaPromisse(value:MediaPromise):void
		{
			if (value == _mediaPromisse){
				return;
			}
			_mediaPromisse = value;
		}
		
		public function AsyncCameraRoll()
		{
			try{
				cameraRoll = null;
			}catch(err){};
		}
		
		public function abreRollDaCamera():void
		{
			cameraRoll = new CameraRoll();
			cameraRoll.addEventListener(MediaEvent.SELECT, fotoNativaSelecionada);
			cameraRoll.addEventListener(Event.CANCEL, fotoNativaCancelada);
			cameraRoll.browseForImage();
			
		}
		
		protected function fotoNativaCancelada(event:Event):void
		{
			dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.SELECAO_CANCELADA));
		}
		
		protected function fotoNativaSelecionada(event:MediaEvent):void
		{
			urlDoArquivoCarregadoComCamRollNativo = event.data.file.url;
			dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.SELECAO_NATIVA_CONCLUIDA));
		}
		
		public function retornaArquivo():void
		{
			if (_mediaPromisse == null){
				return;
			}
			
			dataSource = _mediaPromisse.open();
			eventSource = dataSource as IEventDispatcher;
			eventSource.addEventListener(Event.COMPLETE, leituraDaMediaCompleta);
			//leituraDaMediaCompleta();
			
		}
		
		protected function leituraDaMediaCompleta(event:Event):void
		{
			eventSource.removeEventListener(Event.COMPLETE, leituraDaMediaCompleta);
			
			var imageBytes:ByteArray = new ByteArray();
			
			dataSource.readBytes( imageBytes );
			
			
			
			var fileStream:FileStream = new FileStream();
			
			
			fileStream.open(File.documentsDirectory.resolvePath("lollapalooza/usuarios/foto.jpg"), FileMode.WRITE);
			fileStream.writeBytes(imageBytes,0,imageBytes.length);
			fileStream.close();
			
			/*mFileReference = new FileReference();
			mFileReference.addEventListener( Event.SELECT, uploadFile );
			mFileReference.browse();*/
			
			var sendHeader:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			
			var sendReq:URLRequest = new URLRequest("http://192.168.0.16/lollapalooza/uploadNovo.php");
			sendReq.requestHeaders.push(sendHeader);
			sendReq.method = URLRequestMethod.POST;
			sendReq.data = imageBytes;
			
			var sendLoader:URLLoader;
			sendLoader = new URLLoader();
			sendLoader.addEventListener(Event.COMPLETE, onUploadComplete);
			sendLoader.load(sendReq);
			
			/*var filename:String = "arquivo";	
			var urlRequest:URLRequest = new URLRequest("http://localhost/lollapalooza/upload.php");
			urlRequest.method = URLRequestMethod.POST;
			
			mFileReference.addEventListener(ProgressEvent.PROGRESS, onProgress);	
			mFileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadComplete);			
			
			mFileReference.upload(urlRequest);*/
			
			trace('ENVIANDO');
			
			//dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.CARREGADO));
		}
		
		protected function uploadFile( e:Event ):void
		{
			//mFileReference.upload( new URLRequest( "http://localhost/lollapalooza/upload.php"  ) );
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			var percentUploaded:Number=event.bytesLoaded/event.bytesTotal*100;
			trace("loaded: "+percentUploaded+"%");
			//progressBar.setProgress(percentLoaded, 100);
		}

		
		protected function onUploadComplete(event:Event):void
		{
			// Optional callback to track progress of uploading
		//	mFileReference.removeEventListener(ProgressEvent.PROGRESS, onProgress);	
			//mFileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onUploadComplete);
			
			trace("Enviada")

		}
		
		/*public function salvarImagemCameraRoll(bd):void{
			cameraRoll.addBitmapData(bd);
		}*/
		
		public function pedeBMdataDoPassaporte():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleto);
			loader.load(new URLRequest(File.documentsDirectory.resolvePath("lollapalooza/usuarios/foto.jpg").url));
		}
		
		public function carregaBitmapDataPelaURI(w:Number,h:Number,uri:String):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleto);
			loader.load(new URLRequest(uri));
		}
		
		protected function loaderCompleto(event:Event):void
		{	
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleto);
			
			var origanalWid:Number = LoaderInfo(event.target).content.width;
			var originalHei:Number = LoaderInfo(event.target).content.height;
			var aspRat:Number;
			
			aspRat = origanalWid / originalHei;
			
			var matrisScale:Matrix = new Matrix();
			matrisScale.scale(1024 / origanalWid, (1024 / aspRat) / originalHei);
			
			bitmapData = new BitmapData(1024,1024 / aspRat,true,0x00FFFFFF);
			bitmapData.draw(LoaderInfo(event.target).content,matrisScale);
			this.dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.BITMAPDATA_PRONTO));
		}		
		
		public function carregaDuasImagensEcolocaUmaPorCimaDaOutra(outraURI:String,umaURI:String):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, outraLoaderComplete);
			
			urlRequestDaMoldura = new URLRequest(umaURI);
			
			loader.load(new URLRequest(outraURI));
		}
		
		protected function outraLoaderComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, outraLoaderComplete);
			
			var origanalWid:Number = LoaderInfo(event.target).content.width;
			var originalHei:Number = LoaderInfo(event.target).content.height;
			var aspRat:Number;
			
			aspRat = origanalWid / originalHei;
			
			var matrisScale:Matrix = new Matrix();
			matrisScale.scale(1024 / origanalWid, (1024 / aspRat) / originalHei);
			
			bitmapData = new BitmapData(1024,630);
			bitmapData.draw(LoaderInfo(event.target).content,matrisScale);
				
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, umaLoaderComplete);			
			loader.load(urlRequestDaMoldura);
			
		}		
		
		protected function umaLoaderComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, umaLoaderComplete);
			
			molduraBitmapData = new BitmapData(1024,630,true,0x00FFFFFF);
			molduraBitmapData.draw(LoaderInfo(event.target).content);
			
			bitmapData.draw(molduraBitmapData);
			
			dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.MOLDURA_APLICADA));
		}
		
		public function carregaXMLGaleriaFotos():void
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlGalCarregado);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erroNaGaleria);
			urlLoader.load(new URLRequest("http://dev.antidotodesign.com.br/familia_scania/galeria/galeria.xml?" + Math.random() * 1000));
		}
		
		protected function erroNaGaleria(event:IOErrorEvent):void
		{
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, erroNaGaleria);
			dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.ERRO_NA_GALERIA));
		}
		
		protected function xmlGalCarregado(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, xmlGalCarregado);
			xmlGaleria = new XML(event.target.data);
			dispatchEvent(new AsyncCameraRollEvent(AsyncCameraRollEvent.GALERIA_XML_CARREGADO));			
		}
		
	}
}