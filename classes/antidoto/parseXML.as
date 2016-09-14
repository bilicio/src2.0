package  classes.antidoto{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import classes.antidoto.propagaEvento;
	
	public class parseXML extends Sprite{
		
		private var xmlLoader:URLLoader;
		private var xml:XML;

		public function parseXML(file) {
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onLoadXML);
			xmlLoader.load(new URLRequest(file));
		}
		
		private function onLoadXML(e:Event):void{	
			xmlLoader.removeEventListener(Event.COMPLETE, onLoadXML);
			xml = new XML(e.target.data);
			var evt:propagaEvento = new propagaEvento(propagaEvento.XMLPRONTO, {parsed:xml});
				this.dispatchEvent(evt);
		}
		
		public function get parsedXML():*{
			return xml;
		}

	}
	
}
