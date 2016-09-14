package classes.antidoto {
	import flash.events.Event;
	
	public class ComunicadorEvent extends Event {

		public var leitura:String;
		
		public static const LEITURA_RECEBIDA:String = "leitura_recebida";
		
		public function ComunicadorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
