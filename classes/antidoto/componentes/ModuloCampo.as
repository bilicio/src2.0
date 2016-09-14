package classes.antidoto.componentes
{

	import flash.text.TextFormat;

	
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

	
	public class ModuloCampo extends Sprite
	{
		[Embed(source = "/assets/fonts/Gotham-Bold.otf",
			fontName = "Gotham",
			mimeType = "application/x-font",
			fontWeight="Bold",
			fontStyle="Bold",
			advancedAntiAliasing = "true",
			embedAsCFF="false")]
		public static const fontMergeBold:Class;
		
		private var _bgColor:uint;
		
		private var img:MyImageLoader;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:*;
		
		private var _h:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var _w:Number;
		
		private var imagem:MyImageLoader;
		private var sombra:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var fieldArr:Array = new Array();
		private var imageAvulsaArr:Array = new Array();
		
		private var _props:Object;
		
		private var cont:Number = 0;
		
		private var campo:TextInput;
		
		
		
		private var textInput:TextInput = new TextInput()
			
		private var item:String;
		
		private var ldr:MyImageLoader2;
		
		private var imgArr:Array = new Array();
		public var fieldsArr:Array = new Array();
		
		private var _keyboardSize:Number = 2;
		
		private var textRenderer:TextFieldTextRenderer;
		private var _fontSize:Number = 20;
		
		private var textFormat:TextFormat;
		
		private var selectedField:TextFieldTextRenderer;

		
		public function ModuloCampo(props:Object)
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
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo[_props.idW];
				_fontSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo[_props.idW].@fontSize);
				
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[0];
				_fontSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@fontSize);
			}
			
			trace('FONT: ' + _fontSize);
				
			_h = _xml.@height;
			_w = _xml.@width;
	
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.height = _h;
		}
		
		private function criaComponente(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			var layout:VerticalLayout = new VerticalLayout();
			//trace('categoria: ' + _list.selectedItem.text );
			
			container = new ScrollContainer();
			container.width = _w;
			container.height = _h;
			
			/*container.x = _xml.@x;
			container.y = _xml.@y;*/
			
			container.layout = layout;
			
			textFormat = new TextFormat( "Gotham", _fontSize, 0XFFFFFF);
			
			
			
			//textRenderer.addEventListener(TouchEvent.TOUCH, clicado);

			//textRenderer.text = "TESTE DE TEXTO";
			//textRenderer.validate();
			
			
			addChild(container);
			
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			
	
			criaCampos();
			
		}
		
		private function criaCampos():void
		{

				if(_xml.@img != undefined){
					ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, max:true});
					ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
					addChild(ldr);

					ldr.x = Number(_xml.@x);
					ldr.y = Number(_xml.@y);
				}

				
				
				//trace('--- NOME: ' + globalVars.cadastro[_xml.@vr].toUpperCase());
				
				textRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = textFormat;
				textRenderer.embedFonts = true;
				textRenderer.wordWrap = false;
				textRenderer.isHTML = true;
				
				//textRenderer.width = 100;
				//textRenderer.maxWidth = 120;
				
				
				
				textRenderer.touchable = false;

				textRenderer.x =  Number(_xml.@x)+20;
				textRenderer.y =  Number(_xml.@y)+36;
				
				//textRenderer.addEventListener(TouchEvent.TOUCH, escolheCampo);
				
				addChild(textRenderer);
				
				trace('ok');
	
			/*	if(_xml[i].@type == "post"){
					textRenderer.text = _xml[i].@texto.toUpperCase();
				}else{
					
				}*/
				try{
					textRenderer.text = globalVars.cadastro[_xml.@vr].toUpperCase() + ",";
				}catch(err){}
					
						
				trace('ADDEDD');
		
			this.dispatchEventWith(propagaEvento.COMPLETED, false);
			
		}
		
		
		
		private function imagemCarregada(evt:Event):void
		{
			
			evt.currentTarget.removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			
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
		
		/*public function saveVariables():void{
			var saveObject:Object = new Object();
			for(var i:Number=0; i<_xml.length(); i++){
				if(_xml[i].@type == "post"){
					saveObject[_xml[i].@vr] = fieldsArr[i][1].text;
				}
			}
			
			globalVars.cadastro = saveObject;
			
		//	trace('salvo: ' + globalVars.cadastro["cnome"])
		}*/
		
		
		
		override public function dispose():void{
			try{
				ldr.dispose();
			}catch(err){};
			
			try{
				removeChild(ldr);
			}catch(err){};
			
			try{
				textRenderer.dispose();
			}catch(err){};
			
			try{
				removeChild(textRenderer);
			}catch(err){};
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