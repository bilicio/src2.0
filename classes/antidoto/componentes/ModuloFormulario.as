package classes.antidoto.componentes
{
	
	import com.greensock.TweenMax;
	
	import flash.text.TextFormat;
	
	import cc.cote.feathers.softkeyboard.KeyEvent;
	import cc.cote.feathers.softkeyboard.SoftKeyboard;
	import cc.cote.feathers.softkeyboard.layouts.Layout;
	import cc.cote.feathers.softkeyboard.layouts.NumbersSymbolsSwitch;
	import cc.cote.feathers.softkeyboard.layouts.QwertySwitch;
	
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
	import feathers.layout.VerticalLayout;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	
	public class ModuloFormulario extends Sprite
	{
		/*[Embed(source = "/assets/fonts/BMWMotorradTypeGlobal_Pro_bold_italic.ttf",
			fontName = "BMWMotorradTypeGlobal",
			mimeType = "application/x-font",
			fontWeight="Bold",
			fontStyle="Bold",
			advancedAntiAliasing = "true",
			embedAsCFF="false")]*/
		
		[Embed(source = "/assets/fonts/Gotham-Bold.otf",
			fontName = "Gotham",
			mimeType = "application/x-font",
			fontWeight="Bold",
			fontStyle="Bold",
			advancedAntiAliasing = "true",
			embedAsCFF="false")]
		public static const fontMergeBold:Class;
		
		private var _bgColor:uint;
		
		//private var img:MyImageLoader;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:XMLList;
		
		private var _h:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var _w:Number;
		
		//private var imagem:MyImageLoader;
		//private var sombra:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var fieldArr:Array = new Array();
		private var imageAvulsaArr:Array = new Array();
		
		private var _props:Object;
		
		private var cont:Number = 0;
			
		private var item:String;
		
		private var ldr:MyImageLoader2;
		
		private var imgArr:Array = new Array();
		public var fieldsArr:Array = new Array();
		
		private var _keyboardSize:Number = 2;
		
		private var textRenderer:TextFieldTextRenderer;
		private var warnText:TextFieldTextRenderer;
		private var _fontSize:Number = 20;
		
		private var textFormat:TextFormat;
		private var textFormatEmail:TextFormat;
		
		private var keyboard:SoftKeyboard;
		
		private var selectedField:TextFieldTextRenderer;
		
		private var fieldOptions:Array = new Array();

		
		public function ModuloFormulario(props:Object)
		{
			//trace('modulo comeca');
			for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
			{
				//trace ("itemCount " + itemData.localName()); 
				item = itemData.localName();
			}
			
			//trace('issa');

			_props = props;
			
			if(item == 'item'){
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
				_keyboardSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@keyboardSize);
				_fontSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@fontSize);
				
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo;
				_keyboardSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@keyboardSize);
				_fontSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@fontSize);
			}
				
			_h = _xml[0].@height;
			_w = _xml[0].@width;
	
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.height = _h;
		}
		
		private function criaComponente(evt:Event):void
		{
			var layout:VerticalLayout = new VerticalLayout();
	
			container = new ScrollContainer();
			container.width = _w;
			container.height = _h;

			container.layout = layout;
			
			textFormat = new TextFormat( "Gotham", _fontSize, 0XFFFFFF);
			textFormatEmail = new TextFormat( "Gotham", _fontSize-5, 0XFFFFFF);
			

			
			addChild(container);
			
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			
			if(_xml.parent().parent().@keyboard == 'true'){
			//	var layout2:Layout = new Qwerty(2);
				var layout2:Vector.<Layout> = new <Layout>[
					new QwertySwitch(NumbersSymbolsSwitch, _keyboardSize),
					new NumbersSymbolsSwitch(QwertySwitch, _keyboardSize)
				];
				keyboard = new SoftKeyboard(layout2, _keyboardSize)
				keyboard.addEventListener(KeyEvent.KEY_UP, onKeyUp);
				addChild(keyboard)
				
				if(item == 'item'){
					keyboard.y = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@keyboardY);
					keyboard.x = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@keyboardX);
				}else{
					keyboard.y = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@keyboardY);
					keyboard.x = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@keyboardX);
				}
			}

			criaCampos();
			
		}
		
		private function criaCampos():void
		{
			//trace('xml: ' + _xml.length())
			for(var i:Number=0; i<_xml.length(); i++){
				
				if(_xml[i] != ""){
					
					ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:i, max:true});
					ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
					imgArr[i] = ldr;
	
					addChild(ldr);
					
					imgArr[i].addEventListener(TouchEvent.TOUCH, escolheCampo);
					
					imgArr[i].x = Number(_xml[i].@x);
					imgArr[i].y = Number(_xml[i].@y);
					
					if(i==0){
						//imgArr[i].filter = BlurFilter.createDropShadow(4,.7,0x21acdf,1,0,.5)
					}
				}

				
				textRenderer = new TextFieldTextRenderer();
				if(_xml[i].@texto.toUpperCase() != 'E-MAIL'){
					textRenderer.textFormat = textFormat;
				}else{
					textRenderer.textFormat = textFormatEmail
				}
				
				textRenderer.embedFonts = true;
				textRenderer.wordWrap = false;
				textRenderer.isHTML = true;
				
				textRenderer.touchable = false;
				
				fieldsArr.push([_xml[i].@texto.toUpperCase(), textRenderer]);
				
				fieldOptions.push([_xml[i].@restrict,_xml[i].@maxChar]);

				textRenderer.x =  Number(_xml[i].@x)+20;
				textRenderer.y =  Number(_xml[i].@y)+38;
				
				textRenderer.width = imgArr[i].width - 40;
				
				
				
				//textRenderer.addEventListener(TouchEvent.TOUCH, escolheCampo);
				
				addChild(textRenderer);
				
	
				if(_xml[i].@type == "post"){
					textRenderer.text = _xml[i].@texto.toUpperCase();
				}else{
					try{
						textRenderer.text = globalVars.cadastro[_xml[i].@vr].toUpperCase() + ",";
					}catch(err){}
				}
			}
			
			selectedField = fieldsArr[0][1];
			this.dispatchEventWith(propagaEvento.COMPLETED, false);
			
		}
		
		private function escolheCampo(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				for(var i:Number=0; i<imgArr.length; i++){
					if(imgArr[i] == (evt.currentTarget as MyImageLoader2)){
						selectedField = fieldsArr[i][1];
						
						if(fieldsArr[i][1].text == fieldsArr[i][0]){
							fieldsArr[i][1].text = '';
						}
						//(evt.currentTarget as MyImageLoader2).filter = BlurFilter.createGlow(0x0000ff,1,.5,.5)
						
					}
					try{
						imgArr[i].filter.dispose();
						imgArr[i].filter = null;
					}catch(err){};
				}
				
			//	(evt.currentTarget as MyImageLoader2).filter = BlurFilter.createDropShadow(4,.7,0x21acdf,1,0,.5)
				
				for(var a:Number=0; a<fieldsArr.length; a++){
					if(fieldsArr[a][1].text == '' && selectedField != fieldsArr[a][1]){
						fieldsArr[a][1].text = fieldsArr[a][0];
					}
				}
			}
		}
		
		private function imagemCarregada(evt:Event):void
		{
			
			evt.currentTarget.removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			
		}
			
		public function onKeyUp(e:KeyEvent):void {

			selectedField.text = keyboard.setKEY(e, selectedField, fieldsArr, fieldOptions);
			
			//trace(selectedField.measureText());

		}
		
		private function removeAllFilters():void{
			for(var i:Number=0; i<fieldsArr.length; i++){
				try{
					imgArr[i].filter.dispose();
					imgArr[i].filter = null;
				}catch(err){};
			}
		}
		
		public function valida():Boolean{
			removeAllFilters();
			for(var i:Number=0; i<fieldsArr.length; i++){
				for(var a:Number=0; a<fieldsArr.length; a++){
					if(fieldsArr[i][1].text == fieldsArr[i][0] || fieldsArr[i][1].text == ''){
						//trace('campo ' + fieldsArr[i][1].text);
					//	imgArr[i].filter = BlurFilter.createDropShadow(4,.7,0xff0000,1,0,.5)
						//TweenMax.delayedCall(2, function():void{imgArr[i].filter = BlurFilter.createDropShadow(4,.7,0x21acdf,1,0,.5)});
							
						warnLabel(fieldsArr[i][0].toLowerCase());
						
						selectedField = fieldsArr[i][1];
						//imgArr[i].filter = BlurFilter.createDropShadow(4,.7,0x21acdf,1,0,.5)
							
						fieldsArr[i][1].text = '';
						return false
					}
					
					if(fieldsArr[i][0] == "E-MAIL"){
						if(fieldsArr[i][1].text.indexOf('@') == -1 || fieldsArr[i][1].text.indexOf('.') == -1){
							//trace('campo ' + fieldsArr[i][1].text);
							//imgArr[i].filter = BlurFilter.createDropShadow(4,.7,0xff0000,1,0,.5)
								
							warnLabel(fieldsArr[i][0].toLowerCase() + " corretamente");

							return false
						}
					}
					
					
				}
			}
			
			return true
		}
		
		private function warnLabel(texto):void{
			warnText = new TextFieldTextRenderer();
			warnText.textFormat = textFormat;
			warnText.embedFonts = true;
			warnText.wordWrap = true;
			warnText.isHTML = true;
			
			
			warnText.touchable = false;
			
			warnText.x =  imgArr[imgArr.length-1].x + 3;
			warnText.y =  imgArr[imgArr.length-1].y + imgArr[imgArr.length-1].height;
				
			warnText.text = "Preencha o campo " + texto;
			
			//textRenderer.addEventListener(TouchEvent.TOUCH, escolheCampo);
			
			addChild(warnText);
			
			TweenMax.delayedCall(2, function():void{warnText.dispose(); removeChild(warnText)});
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
		
		public function saveVariables():void{
			var saveObject:Object = new Object();
			for(var i:Number=0; i<_xml.length(); i++){
				if(_xml[i].@type == "post"){
					saveObject[_xml[i].@vr] = fieldsArr[i][1].text;
				}
			}
			
			globalVars.cadastro = saveObject;
			
		//	trace('salvo: ' + globalVars.cadastro["cnome"])
		}
		
		
		
		
		
		override public function dispose():void{
			try{
				keyboard.dispose();
			}catch(err){};
			
			try{
				removeChild(keyboard);
			}catch(err){};
			
			try{
				keyboard = null;
			}catch(err){};
			

			for(var i:Number=0; i<imgArr.length; i++){
				imgArr[i].dispose();
				removeChild(imgArr[i]);
				
				try{
					imgArr[i].filter.dispose()
					imgArr[i].filter = null;
				}catch(err){}
				try{
					fieldsArr[i][1].dispose();
					removeChild(fieldsArr[i][1]);
				}catch(err){}
			}
			
			fieldsArr = null;
			fieldOptions = null;
			
			try{
				warnText.dispose();
				removeChild(warnText);
			}catch(err){}
			
			container.dispose();
			
		/*	for(var i:Number=0; i<imageArr.length; i++){
				imageArr[i][0].dispose();
				removeChild(imageArr[i][0]);
				imageArr[i][1].dispose();
				removeChild(imageArr[i][1])
			}
			
			for(var a:Number=0; a<imageAvulsaArr.length; a++){
				imageAvulsaArr[a].dispose();
				removeChild(imageAvulsaArr[a]);
			}
			
			imageAvulsaArr = [];
			imageAvulsaArr = null;
			
			imageArr = [];
			imageArr = null;*/
			
			/*if(img_Clima){	
			img_Clima.dispose();
			}*/
			
			//trace('disposed!!!');
		}
	}
}