package classes.antidoto.componentes
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import starling.display.Sprite;
	
	/*
	var file:String = File.applicationDirectory.resolvePath("data.dat").url;
	var teste:FileDecryptEncrypt = new FileDecryptEncrypt('decrypt', file); 
	var file:String = File.applicationDirectory.resolvePath("xml/app.xml").url;
	var teste:XmlDecryptEncrypt = new XmlDecryptEncrypt('encrypt', file, 'data.dat'); 
	*/
	
	public class FileDecryptEncrypt extends Sprite
	{

		private var key:String = 'c2c7b9b74b7a0ff890712e34d5510045';
		private var iV:String = 'cd37e8aa510decbff6eb9a07a4c82803';
		
		private var kdata:ByteArray;
		
		private var data:ByteArray;
		
		private var bits:Number = 128;
		
		private var _file:String;
		private var _option:String;
		private var _destination:String;
		
		private var name:String = 'aes'+"-"+'cbc';
		
		private var pad:IPad = new PKCS5;
		private var mode:ICipher;
		private var ivmode:IVMode;

		private var currentInput:ByteArray;
		
		public function FileDecryptEncrypt(option:String, file:String, destination:String = '')
		{
			_destination = destination;
			_file = file;
			_option = option;
			
			loadFile();
		}
		
		private function loadFile():void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loading);
			loader.load(new URLRequest(_file));
		}
		
		private function loading(evt:Event):void{
			kdata = Hex.toArray(key)

			if(_option == 'decrypt'){
				data = Base64.decodeToByteArray(evt.target.data);
			}else{
				data = Hex.toArray(Hex.fromString(evt.target.data));
			}
			
			mode = Crypto.getCipher(name, kdata, pad);
			ivmode = mode as IVMode;
			
			if (mode is IVMode) {
				ivmode.IV = Hex.toArray(iV);
			}
			
			pad.setBlockSize(mode.getBlockSize());
			
			if(_option == 'decrypt'){
				decrypt();
			}else{
				encrypt();
			}
		}
		
		private function generateKey():String{
			var r:Random = new Random;
			var b:ByteArray = new ByteArray
			r.nextBytes(b, bits/8);
			return Hex.fromArray(b);
		}
		
		private function decrypt():void{
			
			mode.decrypt(data);
			
			currentInput = data;
			
			var txt:String;
			var format:String = String('text');
			txt = Hex.toString(Hex.fromArray(currentInput)); 
			
			if(_destination != ''){
				saveFileDecrypted(txt);
			}else{
				trace('DECRYPTED -> ' + txt);
			}

		}

		private function encrypt():void{
			mode.encrypt(data);
			
			currentInput = data;
			
			var txt:String;
			var format:String = String('b64');
			txt = Base64.encodeByteArray(currentInput);
			
			if(_destination != ''){
				saveFileEncrypted(txt)
			}else{
				trace('ENCRYPTED -> ' + txt);
			}

		}
		
		private function saveFileEncrypted(text):void{
			var pathToFile:String = File.applicationDirectory.resolvePath(_destination).nativePath;
			var fileToCreate:File = new File(pathToFile);

			var fileStream:FileStream = new FileStream();
			fileStream.open(fileToCreate, FileMode.WRITE);
			
			fileStream.writeUTFBytes(text);

			fileStream.close();
		}
		
		private function saveFileDecrypted(text):void{
			var pathToFile:String = File.applicationDirectory.resolvePath(_destination).nativePath;
			var fileToCreate:File = new File(pathToFile);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(fileToCreate, FileMode.WRITE);
			
			fileStream.writeUTFBytes(text);
			
			fileStream.close();
		}

		override public function dispose():void{

			
		}
	}
}


