package classes.antidoto.componentes
{
	
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import cc.cote.feathers.softkeyboard.KeyEvent;
	
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.data.ListCollection;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ModuloBtnForm extends Sprite
	{
		public static const FINISHED:String = "cargaCompleta";
		
		private var _bgColor:uint;
		
		private var img:MyImageLoader;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:XMLList;
		
		private var _h:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var _w:Number;
		
		private var imagem:MyImageLoader;
		private var sombra:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var fieldArr:Array = new Array();
		private var imageAvulsaArr:Array = new Array();
		
		public var _props:Object;
		
		private var cont:Number = 0;
		
		private var campo:TextInput;
		
		private var textRenderer:TextFieldTextRenderer;
		
		private var textInput:TextInput = new TextInput()
			
		private var item:String;
		
		private var ldr:MyImageLoader2;
		
		private var imgArr:Array;
		public var fieldsArr:Array = new Array();
		
		private var _keyboardSize:Number = 2;
		private var _fontSize:Number = 50;
		
		private var textFormat:TextFormat;
		
		private var timer:Timer = new Timer(100, 0);
		
		private var currentItem:MyImageLoader2;

		
		public function ModuloBtnForm(props:Object)
		{
			//trace('modulo comeca');
			/*for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
			{
				trace ("itemCount " + itemData.localName()); 
				item = itemData.localName();
			}*/
			
			

			_props = props;
			
			//trace('issa -' + _props.idM + ' - ' + _props.idI);
			
			//trace(globalVars.xml.menu[_props.idM].modulo[_props.idI])
			
			//if(item == 'item'){
			//	_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
			//}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo;
			//}
				
			_h = _xml[0].@height;
			_w = _xml[0].@width;
			
			textFormat = new TextFormat( "Gotham", _fontSize, 0XFFFFFF);

			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			timer.addEventListener(TimerEvent.TIMER, mudaIdade);
			
			this.height = _h;
		}
		
		private function criaComponente(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			criaCampos();
			
		}
		
		private function criaCampos():void
		{
			imgArr = new Array();
			
			switch(String(_xml.parent().parent().@type)){
				case 'choice' :
					for(var i:Number=0; i<_xml.length(); i++){
						
						imgArr[i] = [];
						
						ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:i, max:true});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[i][0] = ldr;
						
						ldr.touchable = false;
						
						addChild(ldr);
						
						imgArr[i][0].x = Number(_xml[i].@x);
						imgArr[i][0].y = Number(_xml[i].@y);
						
						ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:i, max:false});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[i][1] = ldr;
						
						ldr.alpha = 0;
						
						addChild(ldr);
						
						imgArr[i][1].addEventListener(TouchEvent.TOUCH, change);
						
						imgArr[i][1].x = Number(_xml[i].@x);
						imgArr[i][1].y = Number(_xml[i].@y);
						
					}
					
					break
				
				case 'check' :
					for(var a:Number=0; a<_xml.length(); a++){
						
						imgArr[a] = [];
						
						/*ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:a, max:true});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[a][0] = ldr;*/
						ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:0, max:true});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[a][0] = ldr;
						
						ldr.touchable = false;
						
						addChild(ldr);
						
						//imgArr[a][0].x = Number(_xml[a].@x);
						//imgArr[a][0].y = Number(_xml[a].@y);
						
						/*ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:a, max:false});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[a][1] = ldr;*/
						ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:0, max:false});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[a][1] = ldr;
						
						ldr.alpha = 0;
						
						addChild(ldr);
						
						imgArr[a][1].addEventListener(TouchEvent.TOUCH, change);
						
						//imgArr[a][1].x = Number(_xml[a].@x);
						//imgArr[a][1].y = Number(_xml[a].@y);
						
					}
					
					break
				
				case 'set' :
					for(var b:Number=0; b<_xml.length(); b++){
						
						imgArr[b] = [];
						
						ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:b, max:true});
						ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
						imgArr[b][0] = ldr;
						
						if(_xml[b].@tipo == 'campo'){
							ldr.touchable = false;
							
							textRenderer = new TextFieldTextRenderer();
							textRenderer.textFormat = textFormat;
							textRenderer.embedFonts = true;
							textRenderer.wordWrap = true;
							textRenderer.isHTML = true;
							
							textRenderer.touchable = false;
							
							textRenderer.x =  Number(_xml[b].@x) + 36;
							textRenderer.y =  Number(_xml[b].@y) + 20;
							
							textRenderer.text = String(18);
							
							//textRenderer.addEventListener(TouchEvent.TOUCH, escolheCampo);
							
							addChild(textRenderer);
							
						}else{
							if(_xml[b].@type == 'up'){
								ldr.addEventListener(TouchEvent.TOUCH, change);
							}else{
								ldr.addEventListener(TouchEvent.TOUCH, change);
							}
							
						}
						
						addChild(ldr);
						
						imgArr[b][0].x = Number(_xml[b].@x);
						imgArr[b][0].y = Number(_xml[b].@y);
						
					}
					
					break
			}
			
			
			this.dispatchEventWith(FINISHED, false, '');
			//this.dispatchEventWith(propagaEvento.COMPLETED, false);
			
		}
			
		private function imagemCarregada(evt:starling.events.Event):void
		{
			//trace('img OK')
			evt.currentTarget.removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			
		}
		
		private function change(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				
				//trace(String(_xml.parent().parent().@type));
				
				switch(String(_xml.parent().parent().@type)){
					case 'choice' :
						
						for(var i:Number=0; i<imgArr.length; i++){
							imgArr[i][0].alpha = 1;
							imgArr[i][1].alpha = 0;
							
							if(imgArr[i][1] == (evt.currentTarget as MyImageLoader2)){
								imgArr[i][0].alpha = 0;
							}
						}
						
						if((evt.currentTarget as MyImageLoader2).alpha == 0){
							(evt.currentTarget as MyImageLoader2).alpha = 1
						}
						
					break;
					
					case 'check' :
						if((evt.currentTarget as MyImageLoader2).alpha == 0 ){
							imgArr[0][0].alpha = 0;
							imgArr[0][1].alpha = 1;
						}else{
							imgArr[0][0].alpha = 1;
							imgArr[0][1].alpha = 0;
						}
					break;
					
					case 'set' :
						var tipo:String = globalVars.xml.menu[currentItem._props.idM].modulo[currentItem._props.idI].item[0].modulo[currentItem._props.idT].item[0].modulo[currentItem._props.idW].@type;
						
						if(	tipo == 'up' ){
							if(Number(textRenderer.text) < 99){
								textRenderer.text = String(Number(textRenderer.text) + 1)
							}
						}else{
							if(Number(textRenderer.text) > 10){
								textRenderer.text = String(Number(textRenderer.text) - 1)
							}
						}
						
						break
			
				}
			}
			
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.BEGAN)){
				switch(String(_xml.parent().parent().@type)){
					case 'set' :
						currentItem = (evt.currentTarget as MyImageLoader2);
						timer.start();
						break
				}
					
			}
			
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				switch(String(_xml.parent().parent().@type)){
					case 'set' :
						timer.stop();
						break
				}
				
			}
			
			
	
		}
		
		private function mudaIdade(evt:TimerEvent):void{
			switch(String(_xml.parent().parent().@type)){
				case 'set' :
					var tipo:String = globalVars.xml.menu[currentItem._props.idM].modulo[currentItem._props.idI].item[0].modulo[currentItem._props.idT].item[0].modulo[currentItem._props.idW].@type;
					
					if(	tipo == 'up' ){
						if(Number(textRenderer.text) < 99){
							textRenderer.text = String(Number(textRenderer.text) + 1)
						}
					}else{
						if(Number(textRenderer.text) > 10){
							textRenderer.text = String(Number(textRenderer.text) - 1)
						}
					}
					
					break
			}
		}
			
		public function onKeyUp(e:KeyEvent):void {
			trace(e.char);
			fieldsArr[0][1].text += e.char;
		}
		
		/*private function globalTextEditorFactory():ITextEditor
		{*/
			/*var editor:TextFieldTextEditor = new TextFieldTextEditor();
			editor.textFormat = new TextFormat("MavenPro", 30, 0x333333);
			editor.embedFonts = true;*/
			
			
			/*var editor:StageTextTextEditor = new StageTextTextEditor();
			editor.fontFamily = "GothamFont";
			editor.fontSize = 30;
			editor.color = 0x333333;
			return editor;

		}*/
		
		public function valida():Boolean{
			if(String(_xml.parent().parent().@type) == "choice"){
				for(var i:Number=0; i<imgArr.length; i++){
					if(imgArr[i][1].alpha == true){
						
						globalVars.cadastro2[String(_xml.parent().parent().@vr)] = i;
						
						trace("CHOICE: " + String(_xml.parent().parent().@vr) + " -> " + i);
						//trace("CHOICE: " + String(_xml.parent().parent().@vr) + " -> " + globalVars.cadastro['ccliente']);
						
						return true;
					}
				}
			}
			
			if(String(_xml.parent().parent().@type) == "check"){
				if(String(_xml.parent().parent().@valid) == 'true'){
					if(imgArr[0][1].alpha == 0){
						return false;
					}else{
						return true;
					}
				}else{
					
					if(imgArr[0][1].alpha == 0){
						globalVars.cadastro2[String(_xml.parent().parent().@vr)] = 0;
						
						trace("Check: " + String(_xml.parent().parent().@vr) + " -> " + 0);
					}else{
						globalVars.cadastro2[String(_xml.parent().parent().@vr)] = 1;
						
						trace("Check: " + String(_xml.parent().parent().@vr) + " -> " + 1);
						
						//trace("Check: " + String(_xml.parent().parent().@vr) + " -> " + globalVars.cadastro['coptin']);
						
					}
					
					return true;
				}
			}
			
			if(String(_xml.parent().parent().@type) == "set"){
				globalVars.cadastro2[String(_xml.parent().parent().@vr)] = Number(textRenderer.text);
				return true;
			}
			
			return false;
		}
		
		
		/*private function getFieldForm(i):TextInput
		{
			campo = new TextInput();
			
			//_xml.@width, _xml.@height, _xml.@nome, "Verdana" , _xml.@size, _xml.@color
			
			//campo.nameList.add('minha-info');
			
			
			campo.textEditorFactory = function():ITextEditor
			{*/
				/*var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontFamily = "MavenPro";
				editor.fontSize = 12;
				editor.color = 0x000000;
				editor
				return editor;*/
				
				/*var input:TextFieldTextEditor = new TextFieldTextEditor();
				input.textFormat = new TextFormat('MavenPro', 26, 0x000000);
				input.embedFonts = true;
				return input;
			};
			
			campo.typicalText = "The quick brown fox jumps over the lazy dog";
			
			campo.name = _xml.campo[i].@nome;
			campo.text = _xml.campo[i].@nome;
			campo.width = _xml.campo[i].@width
			//telaAtual.addChild(campo);
				
				
			return campo;
		}*/
		
		
		
		override public function dispose():void{
			
			//trace('lenght - ' + imgArr.length);
			for(var i:Number=0; i<imgArr.length; i++){
				imgArr[i][0].dispose();
				removeChild(imgArr[i][0]);
				imgArr[i][0].removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
				
				try{
					imgArr[i][1].removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
					imgArr[i][1].removeEventListener(TouchEvent.TOUCH, change);
					imgArr[i][1].dispose();
					removeChild(imgArr[i][1])
				}catch(err){}
			}
			
			try{
				textRenderer.dispose();
			}catch(err){}
			
			try{
				timer.removeEventListener(TimerEvent.TIMER, mudaIdade);
			}catch(err){}
			
			//imgArr = [];
			//imgArr = null;
			
			/*if(img_Clima){	
			img_Clima.dispose();
			}*/
			
			//trace('disposed!!!');
		}
	}
}