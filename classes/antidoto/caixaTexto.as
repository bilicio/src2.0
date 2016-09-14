package classes.antidoto {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	import flash.events.FocusEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	
	public class caixaTexto extends Sprite{
		
		public var textField:TextField;
		private var myFormat:TextFormat;
		private var _id:Number;
		private var _color:uint;
		
		private var _text:String;
		
		public function caixaTexto(id:Number, larguraCampos:Number, alturaCampos:Number, text:String, font:String, color:uint, size:Number, input:Boolean=false) {
			
			_id = id;
			_text = text;
			_color = color;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			
			textFormat(font, color, size);
			
			textField = new TextField();
			
			textField.defaultTextFormat = myFormat;
			textField.embedFonts = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.htmlText = text;
			//addChild(textField);

			//textField.border = true;
			textField.wordWrap = true;
			textField.width = larguraCampos;
			textField.height = alturaCampos;
			
			if(input){
				textField.type = 'input';
				textField.addEventListener(FocusEvent.FOCUS_IN, focusIN);
				textField.addEventListener(FocusEvent.FOCUS_OUT, focusOUT);
			}

			addChild(textField);
		}
		
		private function focusIN(evt:FocusEvent):void{
			
			if(evt.currentTarget.text == _text){
				evt.currentTarget.text = '';
			}
			
			myFormat.color = _color;
			textField.setTextFormat(myFormat);
			
			var pe:propagaEvento = new propagaEvento(propagaEvento.FOCUSIN, {parsed:evt.currentTarget});
			this.dispatchEvent(pe);
		}
		
		private function focusOUT(evt:FocusEvent):void{
			/*if(evt.currentTarget.text == ''){
				//evt.currentTarget.text = evt.currentTarget.text.substr(evt.currentTarget.text.indexOf(_text)+_text.length,_text.length);
				evt.currentTarget.text = _text;
			}*/
			TweenMax.delayedCall(.5, limpaCampo, [evt.currentTarget]);
		}
		
		private function limpaCampo(campo){
			//trace('campo: ' + campo);
			if(campo.text == ''){
				campo.text = _text;
			}
		}
		
		private function textFormat(font, color, size):void{
			myFormat = new TextFormat();
			myFormat.size = size;
			myFormat.align = TextFormatAlign.LEFT;
			myFormat.color = color;
			myFormat.font = font;
			myFormat.leading = 10;
		}
		
		public function get id():Number{
			return _id;
		}
		
		public function set color(color:uint):void{
			//trace('cor alterada');
			//textField.htmlText = "<font color="+"'#FF0000'"+"'>"+10+"</font>"
			myFormat.color = color;
			textField.setTextFormat(myFormat);
		}
		
		public function dispose(evt:Event):void{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			try{
				textField.removeEventListener(FocusEvent.FOCUS_IN, focusIN);
				textField.removeEventListener(FocusEvent.FOCUS_OUT, focusOUT);
			}catch(err){};
			//trace('DISPOSED');
		}
	}
}
