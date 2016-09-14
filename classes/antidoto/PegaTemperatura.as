package classes.antidoto
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class PegaTemperatura
	{
		private var _f:Function;
		private var weatherArray:XML ;
		private var tempArray:Array = new Array();
		
		private var xmlUserFileStream:FileStream;
		private var xmlUserXML:XML;
		private const XML_USER_FILE:File = File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml");
		private const XML_DATA_WEATHER:String = 'http://weather.yahooapis.com/forecastrss?w=2459115&u=c';
		//private const XML_DATA_WEATHER:String = 'http://';
		
		public function PegaTemperatura(f:Function)
		{
			
			_f = f;
			
			var pegaXml:URLLoader = new URLLoader();
				pegaXml.load(new URLRequest(XML_DATA_WEATHER));
				pegaXml.addEventListener(Event.COMPLETE, botaTemperatura);
				pegaXml.addEventListener(IOErrorEvent.IO_ERROR, seDerErro);
		}
		
		protected function seDerErro(event:IOErrorEvent):void
		{
			trace('erro');
			var data:Object = retornaInfosDoViajante();
			_f(data.min, data.max, data.icon);
		}
		
		// ---------------------------------------------------------- | Filtra XML epega temperaturas
		
		public function botaTemperatura(evt:Event):void
		{
			var xmlClima:XML = new XML(evt.target.data);
			
			var filtraData:XMLList = xmlClima.children()[0].children();
				
			for(var a:uint = filtraData.length(); a--;){
				
				if(filtraData[a].localName() == 'item'){
					
					//trace('lenght: ' + filtraData[a].children()[0].localName());
					
					for(var b:uint = filtraData[a].children().length(); b--;){
						//trace('DADO: ' + filtraData[a].children()[b].localName());
						if(filtraData[a].children()[b].localName() == 'forecast'){
							//trace(filtraData[a].children()[b].@low);
							tempArray.push({low:filtraData[a].children()[b].@low, high:filtraData[a].children()[b].@high, code:filtraData[a].children()[b].@code})	
						}
					}
					tempArray.reverse();
				}
			}
				
			//trace(tempArray[0].low + " | " + tempArray[0].high + " | " + tempArray[0].code);
			
			if(tempArray[0] != null){
				trace('retornado');
				_f(tempArray[0].low+'°', tempArray[0].high+'°', getImage(tempArray[0].code));
				salvaInfosDoViajante(getImage(tempArray[0].code), tempArray[0].low+'°', tempArray[0].high+'°' );
			}else{
				trace('salvo');
				var data:Object = retornaInfosDoViajante();
				_f(data.min, data.max, data.icon);
			}
			
		}
		
		// ---------------------------------------------------------- | PEGA IMAGEM 
		
		private function getImage(id):String{
			
			weatherArray = new XML(Assets.am.getXml('weather'));
			
			//trace('ok: ' + weatherArray);
			
			for(var a:uint = weatherArray.node.length(); a--;){
				//trace(weatherArray.node[a].@id + ' | ' + id);
				if(weatherArray.node[a].@id == id){
					
					return  weatherArray.node[a].img;
					//return  'sol';
				}
			}
			
			return 'nublado';
		}
		
		private function abreXML():void
		{
			xmlUserFileStream = new FileStream();
			xmlUserFileStream.open(XML_USER_FILE, FileMode.READ);
			xmlUserXML = new XML(xmlUserFileStream.readUTFBytes(xmlUserFileStream.bytesAvailable));
			xmlUserFileStream.close();
		}
		
		public function salvaInfosDoViajante(icon:String, min:String, max:String):void
		{
			var fileStream:FileStream = new FileStream();
				fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.READ);
			var tempXml:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
				tempXml.user.icon = icon;
				tempXml.user.min = min;
				tempXml.user.max = max;
				fileStream.open(File.documentsDirectory.resolvePath("familia_scania/dados_user/user_infos.xml"), FileMode.WRITE);
				fileStream.writeUTFBytes(tempXml.toXMLString());
				fileStream.close();
		}
		
		public function retornaInfosDoViajante():Object
		{
			abreXML();
			var retorno:Object = new Object();
			retorno.icon = xmlUserXML.user.icon;
			retorno.min = xmlUserXML.user.min;
			retorno.max = xmlUserXML.user.max;
			return retorno;
		}
	}
}