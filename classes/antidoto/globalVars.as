package classes.antidoto
{
	import com.quetwo.Arduino.ArduinoConnector;
	
	import flash.media.Camera;
	import flash.media.Video;
	
	import org.as3commons.zip.ZipLibrary;

	public class globalVars
	{
		public function globalVars(){}
		
		public static var id:Number;
		public static var xml:XMLList
		public static var zipFile:ZipLibrary;
		public static var cadastro:Object = new Object();
		public static var cadastro2:Object = new Object();
		public static var camera:* = null;
		public static var arduino:ArduinoConnector = null;
		public static var video:Video = null;
		public static var escolha:Array = new Array();
		public var zip:String;
		
		public function get _id():Number{
			return id ;
		}
		
		public function set _id(_id):void{
			id = _id ;
		}
		
		public function get _zipFile():ZipLibrary{
			return zipFile ;
		}
		
		public function set _zipFile(_zipFile):void{
			zipFile = _zipFile ;
		}
		
		public function get _xml():XMLList{
			return xml ;
		}
		
		public function set _xml(_xml):void{
			xml = _xml ;
		}
		
		public function get _cadastro():Object{
			return cadastro ;
		}
		
		public function set _cadastro(_cadastro):void{
			cadastro = _cadastro ;
		}
		
		public function get _cadastro2():Object{
			return cadastro2 ;
		}
		
		public function set _cadastro2(_cadastro2):void{
			cadastro2 = _cadastro2 ;
		}
		
		public function get _camera():*{
			return camera ;
		}
		
		public function set _camera(_camera):void{
			camera = _camera ;
		}
		
		public function get _arduino():ArduinoConnector{
			return arduino ;
		}
		
		public function set _arduino(_arduino):void{
			arduino = _arduino ;
		}
		
		public function get _video():Video{
			return video ;
		}

		public function set _video(_video):void{
			video = _video ;
		}
		
		public function get _escolha():Array{
			return escolha ;
		}
		
		public function set _escolha(_escolha):void{
			id = _escolha ;
		}
	}
}
