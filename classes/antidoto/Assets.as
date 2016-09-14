package classes.antidoto
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipEvent;
	import org.as3commons.zip.ZipFile;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

    public class Assets extends Sprite
    {

		//[Embed(source="/../../assets/fonts/MavenPro-Medium.ttf", embedAsCFF="false", fontFamily="MavenPro")]
		//private static const font_maven:Class;
		
		//[Embed(source="/../../assets/fonts/MavenPro-Black.ttf", embedAsCFF="false", fontFamily="MavenPro", fontWeight = "bold")]
		//private static const font_maven_bold:Class;
		
		public static var am:AssetManager = new AssetManager();
		
		//public static var lib:ZipLibrary = new ZipLibrary();
		private var urlImages:URLRequest;
		
		public static var zip:Zip = new Zip();
		public static var byte:ByteArray;
		
		public static var zipe:ZipFile;
		
		private var updater:UpdaterFSZIP;
		
		public function Assets(){
			
			//urlImages = new URLRequest(File.documentsDirectory.resolvePath("GrupoProtege/protege/protege.zip").url);
			urlImages = new URLRequest(File.applicationDirectory.resolvePath("app.zip").url);
			
			//------------------------------------------------------- Baixa Atracoes
			//var file0:File = File.documentsDirectory.resolvePath("GrupoProtege/protege/xml/protege.xml");
			var file0:File = File.applicationDirectory.resolvePath("xml/app.xml");
			var fileStream0:FileStream = new FileStream();
			fileStream0.open(file0, FileMode.READ);
			fileStream0.close();
			
			am.enqueueWithName(file0.url, 'settings');
			
			/*//------------------------------------------------------- Baixa TextureAltasMarkers
			var file4:File = File.documentsDirectory.resolvePath("queiroz_galvao/img/mapMarkers.png");
			var fileStream4:FileStream = new FileStream();
			fileStream4.open(file4, FileMode.READ);
			fileStream4.close();
			
			am.enqueue(file4.url);
			
			var file5:File = File.documentsDirectory.resolvePath("queiroz_galvao/xml/mapMarkers.xml");
			var fileStream5:FileStream = new FileStream();
			fileStream5.open(file5, FileMode.READ);
			fileStream5.close();
			
			am.enqueue(file5.url);*/
			
			//------------------------------------------------------- Baixa Banner
			/*var file6:File = File.documentsDirectory.resolvePath("queiroz_galvao/img/cabecalho.png");
			
			
			if(file6.exists){
				var fileStream6:FileStream = new FileStream();
				fileStream6.open(file6, FileMode.READ);
				fileStream6.close();
				am.enqueueWithName(file6.url, 'cabecalho');
			}else{
				trace('não tem banner');
			}
			
			var file7:File = File.documentsDirectory.resolvePath("queiroz_galvao/img/footer.png");
			
			
			if(file7.exists){
				var fileStream7:FileStream = new FileStream();
				fileStream7.open(file7, FileMode.READ);
				fileStream7.close();
				am.enqueueWithName(file7.url, 'footer');
			}else{
				trace('não tem footer');
			}
			
			var file8:File = File.documentsDirectory.resolvePath("queiroz_galvao/img/back.png");
			
			
			if(file8.exists){
				var fileStream8:FileStream = new FileStream();
				fileStream8.open(file8, FileMode.READ);
				fileStream8.close();
				am.enqueueWithName(file8.url, 'back');
			}else{
				trace('não tem footer');
			}
			*/
			
			//------------------------------------------------------- Termina Filestream
			
			am.enqueue(Assets);
			
			am.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio); //track the progress with this ratio
				if (ratio == 1.0){
					trace("All assets loaded!")
					//dispatchEvent(new starling.events.Event('Assets.LOADED'));
					getZipReady();
				}
			}); 
		}
		
		protected function falhaEmCarregamentoDeImagem(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		public static function removeAndRearmTextures():void{
			trace('REARMING');
			
			am.removeXml("empreendimentos", true);
			
			var file0:File = File.documentsDirectory.resolvePath("marykay/xml/marykay.xml");
			var fileStream0:FileStream = new FileStream();
			fileStream0.open(file0, FileMode.READ);
			fileStream0.close();
			
			//am.purgeQueue();
			
			am.enqueueWithName(file0.url, 'empreendimentos');
			
			am.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio); //track the progress with this ratio
				if (ratio == 1.0){
					trace("New Atracoes Loaded")
					//dispatchEvent(new Event('Assets.LOADED'));
				}
			}); 
		}
		
		public function get assets():AssetManager
		{
			return am;
		}
		
		private function getZipReady(evt:UpdaterEvent = null):void{
			//trace('OK');
			
			try{
				updater.removeEventListener(UpdaterEvent.ZIPDOWNLOADED, getZipReady);
			}catch(err){};
			
			/*lib = new ZipLibrary();
			lib.formatAsBitmapData(".jpg");
			lib.formatAsBitmapData(".png");*/

			//lib.addEventListener(flash.events.Event.COMPLETE,onLoad);
			zip.addEventListener(flash.events.Event.COMPLETE, terminou);
			//zip.addEventListener(ZipEvent.FILE_LOADED, fileLoaded);
			//zip.addEventListener(flash.events.IOErrorEvent.IO_ERROR, erro);
			//zip.load(urlImages);
			
			zip.load(urlImages);
			//lib.addZip(zip);
		}
		
		protected function fileLoaded(event:ZipEvent):void
		{
			//trace('fileLOADED');
			
		}
		
		private function terminou(event:flash.events.Event):void
		{
			//lib.removeEventListener(flash.events.Event.COMPLETE, terminou);
			//trace('ZIP SERIALIZED | LOADED');
			
			
			byte = new ByteArray();
			zip.serialize(byte);
			byte.clear();
			
			dispatchEvent(new starling.events.Event('Assets.LOADED'));
			//trace('zip: ' + zip);
			
		}
		
		public function get zipFile():Zip
		{
			return zip;
		}
		
		public static function getImage(image):*
		{
			zipe = null;
			zipe = new ZipFile();
			//byte = new ByteArray();
			
			//trace('IMAGEM: ' + image);
			//var image2:BitmapData =  lib.getBitmapData(image);
			//var bitm2:Bitmap = new Bitmap(image2);
			// Texture.fromBitmap(bitm2);
				
			zipe = zip.getFileByName(image);
			//zipe.serialize(byte,false);
			
			
		//	return  Texture.fromBitmap(bitm2);
			try{
				return  zipe.content
			}catch(err){trace('NAO TEM ESSA IMAGEM')};
				
			
			
			
		}
		
		protected function onLoad(event:flash.events.Event):void
		{
			// TODO Auto-generated method stub
			trace('ZIP LOADED');
		}
		
		protected function erro(event:flash.events.Event):void
		{			// TODO Auto-generated method stub
			trace('ERRO LOAD ZIP');
			updater = new UpdaterFSZIP();
			updater.addEventListener(UpdaterEvent.ZIPDOWNLOADED, getZipReady);
			updater.downloadMapa();
		}
	}
}