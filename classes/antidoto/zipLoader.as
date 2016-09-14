package classes.antidoto {
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;

	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;
	import org.as3commons.zip.ZipLibrary;
	import org.gestouch.gestures.TransformGesture;

	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import classes.antidoto.propagaEvento;
	
	public class zipLoader extends Sprite{

		private var ldr:Loader;
		private var loaderInfo:LoaderInfo;
		private var bitmapData:BitmapData;
		private var img:*;
		private var _image:String;
		private var texture:Texture ;
		
		private var _width:Number;
		private var _tiled:Boolean;
		private var _transition:String;
		private var _multitouch:Boolean = false;
		
		private var spMask:Sprite;
		
		private var _props:Object;
		private var zip:Zip;
		private var zipe:ZipFile;
		private var byte:ByteArray;
		
		private var xmlTitle:XML;
		
		private var velAnimation:Number = .5;
		
		private var transformGesture:TransformGesture;
		
		private var urlImages:URLRequest;
		
		private var lib:ZipLibrary;
		
		public function zipLoader(arquivoZIP) {
			lib = new ZipLibrary();
			lib.formatAsBitmapData(".jpg");
			lib.formatAsBitmapData(".png");
			lib.formatAsDisplayObject(".swf");
			lib.addEventListener(Event.COMPLETE,onLoad);
			
			var zip:Zip = new Zip();
			zip.load(arquivoZIP);
			lib.addZip(zip);
		}
		
		private function onLoad(evt:Event):void{
			
			
			//trace('LIBE! ' + lib);
			this.dispatchEventWith(propagaEvento.ZIPLOADED, false, {zipFile:lib});
			//var pE:propagaEvento = new propagaEvento(propagaEvento.XMLPRONTO, {parsed:lib});
			//this.dispatchEvent(pE);
			//trace('carregada: ' + _image);
		}
		
		
		public function clear():void{
		
			ldr.unload();
			ldr = null;
			loaderInfo = null;
			bitmapData.dispose();
			bitmapData = null
			//bitmap = null;
			spMask.dispose();
			img.dispose();
			
			zipe = null;
			byte.clear();
			
			xmlTitle = null;
			
		}
		
		public override function dispose():void{
			try{
				texture.dispose();
				texture = null;
			}catch(err){};
			
			try{
				img.dispose();
			}catch(err){};
			
			try{
				_props = null;
			}catch(err){};
			
			try{
				spMask.removeChild(img);
			}catch(err){};
			
			try{
				removeChild(spMask);
			}catch(err){};
			
			zip = null;

			
			//trace('DISPOSED');
		}
	}
}
