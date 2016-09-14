package classes.antidoto{
	import flash.utils.Dictionary;
	
	import starling.events.TouchEvent;
	
	public class eventDispatchTouchs extends TouchEvent {
		
		public static const REQUEST:String = "REQUEST";
		public static const XMLPRONTO:String = "XMLPRONTO";
		public static const DATABASE:String = "DATABASE";
		public static const INSERT:String = "INSERT";
		public static const BARCODE:String = "BARCODE";
		public static const COMPLETED:String = "COMPLETED";
		public static const FILELOADED:String = "FILELOADED";
		public static const IMAGELOADED:String = "IMAGELOADED";
		public static const IMAGELOADED2:String = "IMAGELOADED2";
		public static const CONNECTED:String = "CONNECTED";
		public static const ARDUINORESPONSE:String = "ARDUINORESPONSE";
		public static const ZIPLOADED:String = "ZIPLOADED";
		public static const QUIZCOMPLETED:String = "QUIZCOMPLETED";
		public static const FOCUSIN:String = "FOCUSIN";
		public static const DISPOSED:String = "DISPOSED";
		public static const FORMULARIOLOADED:String = "FORMULARIOLOADED";
		public static const VALIDATE:String = "VALIDATE";
		public static const FORMPRONTO:String = "FORMPRONTO";
		
		public static const THREE_TOUCH_BEGIN: String = "threeTouchBegin";
		public static const THREE_TOUCH_END: String = "threeTouchEnd";
		
		private var _data: Object;
		private var nTouch: int = 0;
		private var touchID: int = 0;
		// dictionnaire (table) des touch
		private var dPoints: Dictionary = new Dictionary();
		
		public var params:*;
		
		public function eventDispatchTouchs(type:String, $params:Object, bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type,bubbles,cancelable);
			if (type == TouchEvent.TOUCH) {
				nTouch++;
				trace('touch')
				//dPoints[touchPointID] = new Point(stageX, stageY);
				if (nTouch >= 3) {
					trace('threepoints')
					for (var pt in dPoints) {
						
					}
					
				}
				
			}
		}
		
		/*public override function clone():Event
        {
            return new propagaEvento(type, this.params, bubbles, cancelable);
        }
        
        public override function toString():String
        {
            return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");
		}*/

	}
	
}
