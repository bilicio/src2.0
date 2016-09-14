package classes.antidoto.componentes
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import app.Main;
	
	import classes.antidoto.Local;
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	import classes.pixelmask.PixelMaskDisplayObject;
	
	import feathers.controls.text.TextFieldTextRenderer;
	
	import org.as3commons.zip.ZipFile;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;

	public class ModuloBuilder extends Sprite
	{
		private var modulos:Array;
		private var modulosCriados:Array = new Array();
		
		private var _xmlRoot:XMLList;
		private var _xmlModule:XMLList;
		
		private var _local:Local;
		private var menuID:Number = 0;
		private var _bgColor:uint;
		
		// ------------------------------------------------------------------------------------ | MODULOS
		private var modulo_imagem:MyImageLoader;
		private var modulo_imagem2:MyImageLoader2;
		
		private var modulo_mask:MyImageLoader;
		private var modulo_galeria:ModuloGaleria;
		private var modulo_scroll:ModuloScroll;
		private var modulo_block:ModuloBlock;
		private var modulo_popup:ModuloPopup;
		private var modulo_tab:ModuloTab;
		private var modulo_formulario:ModuloFormulario;
		private var modulo_btn_video:ModuloVideoStarling;
		private var modulo_video:ModuloVideo;
		private var modulo_popup_galeria:ModuloPopupGaleria;
		private var modulo_carrossel:ModuloCarrossel;
		private var modulo_galeriaMultitouch:ModuloGaleriaMultitouch;
		private var modulo_btnVideo:ModuloBtnVideo;
		private var modulo_btnForm:ModuloBtnForm;
		private var modulo_custom:ModuloCustomChoice;
		
		private var _modules:Array;
		
		private var zipFile:ZipFile;
		
		private var transitioning:Boolean = false;
		
		private var r:Main;
		
		public var _props:Object;
		
	//	private var gbVars:globalVars;
		
		private var passID:*;
		
		private var prontoTween:Boolean = true;
		
		private var xis:MyImageLoader2;
		
		private var _idModule:Number;
		private var module:String;
		
		public var keepGoing:Boolean = true;
		
		private var item:String;
		private var cnt:Array = new Array();
		
		private var testeXML:XMLList;
		
		private var textRenderer:TextFieldTextRenderer;
		private var _fontSize:Number = 20;
		
		private var textFormat:TextFormat;
		
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		
		private var texture:Texture;
		private var video:Image;
		
		private var enought:Boolean = false;
		
		public function ModuloBuilder(props:Object)
		{
			//trace('MODULEBUILDER');
			_xmlRoot = globalVars.xml;
			_idModule = props.menuID;
			
			if(props.moduloID == undefined){
				
				_xmlModule = _xmlRoot.menu[_idModule].modulo;
				
				//trace('go');
			}else{
				
				//trace('go: ' + _xmlRoot.menu[_idModule].modulo[props.moduloID].item[0].modulo);
				_xmlModule = _xmlRoot.menu[_idModule].modulo[props.moduloID].item[0].modulo;
				
				/*for each(var itemData:XML in _xmlRoot.menu[_idModule].modulo[props.moduloID].item[0].modulo[props.moduloIT].elements()) 
				{
					//trace ("itemCount " + itemData.localName()); 
					item = itemData.localName();
				}
				
				if(item == 'item'){
					_xmlModule = _xmlRoot.menu[_idModule].modulo[props.moduloID].item[0].modulo[props.moduloIT].item[0].modulo;
				}*/
			}
			
		/*	var stringTest:String = "_xmlRoot";
			
			var xmlListString:XMLList = _xmlRoot.menu[_idModule].modulo;
			
			for (var s:String in props) {
				var value:* = props[s];
				
				trace("props: " + s);
				
				cnt.push(value);
			}
			
			for (var i:Number=1; i<cnt.length-1; i++) {
				
				trace("lenght: " + cnt.length);
				
				xmlListString = xmlListString[cnt[i]].child("item")[0].child("modulo");
				trace('roll: ' + xmlListString[cnt[i+1]].toXMLString());	
				//xmlListString +="["+cnt[i]+"].item[0].modulo"
			};*/
			
			//trace("MODULO BUILDER - START");
			
			//testeXML = stringTest as XMLList;
			
			//trace('modulo convertido string: ' + xmlListString[0].toXMLString());
			//trace('modulo convertido: ' + testeXML as XMLList);
			
			_props = props;

			//try{
			_bgColor = _xmlRoot[0].@color;
			//}catch(err){};
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, abrirModulos);

		}
		
		public function get xml():XMLList{
			return _xmlRoot ;
		}
		
		public function set xml(xml):void{
			_xmlRoot = xml;
		}
		
		public function abrirModulos(evt:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, abrirModulos);
			
			modulos = new Array();
			
			//trace(_props.moduloID);
			
			if(_props.moduloID == undefined){
				//trace('aqui');
				for(var i:Number=0; i<_xmlModule.length(); i++){
					if(_xmlModule[i].@tipo != "timeline"){
						modulos.push([_xmlModule[i].@tipo,i]);
					}
					
				}
			}else{
				
				//trace('INFO: ' + _xmlModule);
				//if(item == 'item'){
				//	modulos.push([_xmlModule[_props.moduloIT].@tipo, _props.moduloIT]);
				//}else{
					modulos.push([_xmlModule[_props.moduloIT].@tipo, _props.moduloIT]);
				//}
				
			}
			
			//trace('INFO: ' + modulos);
			
			if(modulosCriados.length>0){
				removeModules();
				//trace('removendo');
			}else{
				//createModulos();
				enought = false;
				createModulo();
				//TweenMax.delayedCall(.5, createModulo);
			}
			
		}
		
		public function createModulos():void
		{
			//trace('modulo');
			if(modulos.length>0){
				createModulo();
			}else if(!enought){
				enought = true;
				transitioning = false;
				modulosCarregados();
			}
		}
		
		private function modulosCarregados():void
		{
			dispatchEvent(new starling.events.Event('Modulos.CARREGADOS'));			
		}
		
		
		private var _particleContainer:PixelMaskDisplayObject;
		
		
		private function createModulo():void
		{
			transitioning = true;
			//trace('LENGHT: ' + modulos.length)
			
			//trace('FROM MODULE BUILDER: ' +  modulos[0][0]);
			
			try{
				module = modulos[0][0];
			}catch(err){};

			var yInicial:Number;
			
			if(numChildren == 0){
				yInicial = 0;
			}else{
				yInicial = getChildAt(numChildren-1).y + getChildAt(numChildren-1).height;
			}
			//var yInicial:Number = 321;
			var getY:Number;
			
			/*gbVars = new globalVars(
				modulos[0][1],
				_xmlModule[modulos[0][1]].@pagina,
				_xmlModule[modulos[0][1]].@multitouch,
				_xmlModule[modulos[0][1]].@globalTransition,
				_xmlModule[modulos[0][1]].@way,
				module,
				_xmlModule[modulos[0][1]].@transition,
				_xmlModule[modulos[0][1]].@file,
				_props.zipFile,
				_props.zip
				);
			
			_props.id = modulos[0][1];
			_props.tela = _xmlModule[modulos[0][1]].@pagina;
			_props.transition = _xmlModule[modulos[0][1]].@transition;
			_props.multitouch = _xmlModule[modulos[0][1]].@multitouch;
			_props.globalTransition = _xmlModule[modulos[0][1]].@globalTransition;
			_props.way = _xmlModule[modulos[0][1]].@way;
			_props.type = module;*/
			
			
			switch(module){
				case 'imagem' :
					modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:modulos[0][1]});
					
					//trace('IMAGE FROM MODULE BUILDER: ' + modulos[0][1]);
					
					getY =  Number(_xmlModule[modulos[0][1]].@y);
					if(getY == 0 && Number(_xmlModule[modulos[0][1]].@x) == 0){
						//modulo_imagem2.y = yInicial;
						modulo_imagem2.y = getY;
					}else{
						modulo_imagem2.y = getY;
					}
					modulo_imagem2.x = _xmlModule[modulos[0][1]].@x;
					
					if(_xmlModule[modulos[0][1]].@clicable == 'false'){
						modulo_imagem2.touchable = false;
					}

					//modulo_imagem.addEventListener('TESTE', imageModuleCreated);
					modulo_imagem2.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
					//dispatchEvent(new starling.events.Event('Modulos.CARREGADOS'));
					
					modulo_imagem2.alpha = 1;
					
					this.addChild(modulo_imagem2);
					modulosCriados.push(modulo_imagem2);
					break
				
				case 'gif' :
					modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:modulos[0][1]});
					
					getY =  Number(_xmlModule[modulos[0][1]].@y);
					if(getY == 0 && Number(_xmlModule[modulos[0][1]].@x) == 0){
						modulo_imagem2.y = yInicial;
					}else{
						modulo_imagem2.y = getY ;
					}
					
					modulo_imagem2.x = _xmlModule[modulos[0][1]].@x ;
					

					modulo_imagem2.addEventListener(propagaEvento.IMAGELOADED, gifModuleCreated);
					modulo_imagem2.alpha = 0;
					
					this.addChild(modulo_imagem2);

					modulosCriados.push(modulo_imagem2);
					break
				
				case 'imagem-mask' :
					modulo_imagem = new MyImageLoader(_xmlModule[modulos[0][1]], _props);

					modulo_imagem.alpha = 0;

					TweenMax.to(modulo_imagem, 5, {width:2250, height:1266, alpha:1,x:-140, y:-140, onComplete:tweenFinished, ease:Quad.easeOut});
					
					
					getY =  Number(_xmlModule[modulos[0][1]].@y);
					if(getY == 0 && Number(_xmlModule[modulos[0][1]].@x) == 0){
						modulo_imagem.y = yInicial;
					}else{
						modulo_imagem.y = getY;
					}
					modulo_imagem.x = _xmlModule[modulos[0][1]].@x;

					modulo_imagem.addEventListener(propagaEvento.IMAGELOADED, imageModuleMaskCreated);

					this.addChild(modulo_imagem);
					modulosCriados.push(modulo_imagem);
					break
				
				case 'galeria' :
					modulo_galeria = new ModuloGaleria({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;

					modulo_galeria.y = getY;
				
					
					//trace('y: ' + getY + ' x: ' + _xmlModule[modulos[0][1]].@x);
					
					modulo_galeria.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_galeria.alpha = 0;
					modulo_galeria.addEventListener(propagaEvento.COMPLETED, galleryModuleCreated);
					this.addChild(modulo_galeria);
					modulosCriados.push(modulo_galeria);
					break;
				
				case 'scroll' :
					modulo_scroll = new ModuloScroll({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_scroll.y = getY;
					}else{
						modulo_scroll.y = yInicial;
					}
					modulo_scroll.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_scroll.alpha = 0;
					modulo_scroll.addEventListener(propagaEvento.COMPLETED, scrollModuleCreated);
					this.addChild(modulo_scroll);
					modulosCriados.push(modulo_scroll);
					break;
				
				case 'popup' :
					trace('popup');
					//modulo_popup = new ModuloPopup({idM:_idModule, idI:_props.moduloID, idT:_props.moduloIT});
					modulo_popup = new ModuloPopup({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;
					modulo_popup.y = getY;

					modulo_popup.x = _xmlModule[modulos[0][1]].@x;
					
					//trace('transition popup: ' + _xmlModule[modulos[0][1]].@transition);
					
					//modulo_popup.alpha = 0;
					modulo_popup.addEventListener(propagaEvento.COMPLETED, popupModuleCreated);
					this.addChild(modulo_popup);
					modulosCriados.push(modulo_popup);
					break;
				
				case 'block' :
					modulo_block = new ModuloBlock(_xmlModule[modulos[0][1]], _props);
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_block.y = getY;
					}else{
						modulo_block.y = yInicial;
					}
					modulo_block.x = _xmlModule[modulos[0][1]].@x;
					
					//modulo_block.alpha = 0;
					modulo_block.addEventListener(propagaEvento.COMPLETED, blockModuleCreated);
					this.addChild(modulo_block);
					modulosCriados.push(modulo_block);
					break;
				
				case 'tab' :
					modulo_tab = new ModuloTab({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_tab.y = getY;
					}else{
						modulo_tab.y = yInicial;
					}
					modulo_tab.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_tab.alpha = 0;
					modulo_tab.addEventListener(propagaEvento.COMPLETED, tabModuleCreated);
					this.addChild(modulo_tab);
					modulosCriados.push(modulo_tab);
					break;
				
				case 'btn' :
					
					if(_xmlModule[modulos[0][1]].@type == 'video'){
						trace('btnVideo');
						modulo_btnVideo = new ModuloBtnVideo({idM:_idModule, idI:_props.moduloID, idT:_props.moduloIT});
						
						trace('nome do video: ' + _xmlModule[modulos[0][1]] + ' - ' + _idModule+ ' - '+modulos[0][1]+ ' - '+_props.moduloIT);
						
						getY =  _xmlModule[modulos[0][1]].@y;
						if(getY>0){
							modulo_btnVideo.y = getY;
						}else{
							modulo_btnVideo.y = yInicial;
						}
						modulo_btnVideo.x = _xmlModule[modulos[0][1]].@x;
						
						modulo_btnVideo.alpha = 0;
						modulo_btnVideo.addEventListener('cargaCompleta', videoModuleCreated);
						modulo_btnVideo.addEventListener(TouchEvent.TOUCH, btnVideoclicado);
						this.addChild(modulo_btnVideo);
						modulosCriados.push(modulo_btnVideo);
					}else{
						
						if(_xmlRoot.menu[_idModule].@modelo == 'timeline'){
							modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:_props.moduloID, idT:modulos[0][1], max:true});
						}else{
							//trace('AQUI');
							modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:modulos[0][1]});
						}
						modulo_imagem2.x = _xmlModule[modulos[0][1]].@x;
						modulo_imagem2.y = _xmlModule[modulos[0][1]].@y;
						
						modulo_imagem2.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
						modulo_imagem2.alpha = 0;
						modulo_imagem2.addEventListener(TouchEvent.TOUCH, clicado);
						
						this.addChild(modulo_imagem2);
						
						modulosCriados.push(modulo_imagem2);
					}

					break;
				
				case 'btnForm' :
					modulo_btnForm = new ModuloBtnForm({idM:_idModule, idI:modulos[0][1], idT:_props.moduloIT});
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_btnForm.y = getY;
					}else{
						modulo_btnForm.y = yInicial;
					}
					modulo_btnForm.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_btnForm.alpha = 1;
					modulo_btnForm.addEventListener('cargaCompleta', btnFormCreated);
					modulo_btnForm.addEventListener(TouchEvent.TOUCH, btnFormClicado);
					this.addChild(modulo_btnForm);
					modulosCriados.push(modulo_btnForm);
					
					break;
				
				case 'btn-gif' :
					modulo_imagem = new MyImageLoader(_xmlModule[modulos[0][1]].@img, _props);
					
					modulo_imagem.x = _xmlModule[modulos[0][1]].@x;
					modulo_imagem.y = _xmlModule[modulos[0][1]].@y;
					
					//trace('BTN FROM MODULE BUILDER: ' + _xmlModule[modulos[0][1]].@img);
					
					modulo_imagem.addEventListener(propagaEvento.IMAGELOADED, gifModuleCreated);
					//modulo_imagem.alpha = 0;
					modulo_imagem.addEventListener(TouchEvent.TOUCH, clicado);
					this.addChild(modulo_imagem);
					modulosCriados.push(modulo_imagem);
					break;
				
				case 'formulario' :
					
					trace('Modulo builder formulario');
					
					if(item == 'item'){
						modulo_formulario = new ModuloFormulario({idM:_idModule, idI:modulos[0][1], idT:_props.moduloIT});
						//_xmlModule = _xmlRoot.menu[_idModule].modulo[_props.moduloID].item[0].modulo[_props.idI].item[0].modulo;
					}else{
						modulo_formulario = new ModuloFormulario({idM:_idModule, idI:modulos[0][1]});
					}
					
					
					
					//trace('IMAGE FROM MODULE BUILDER: ' + _xmlModule[modulos[0][1]]);
					
					getY =  Number(_xmlModule[modulos[0][1]].@y);
					if(getY == 0 && Number(_xmlModule[modulos[0][1]].@x) == 0){
						modulo_formulario.y = yInicial;
					}else{
						modulo_formulario.y = getY;
					}
					modulo_formulario.x = _xmlModule[modulos[0][1]].@x;
					
					//modulo_imagem.addEventListener('TESTE', formularioModuleCreated);
					modulo_formulario.addEventListener(propagaEvento.FORMULARIOLOADED, formularioModuleCreated);
					//dispatchEvent(new starling.events.Event('Modulos.CARREGADOS'));
					
					//trace('formula ok');
					
					modulo_formulario.alpha = 1;
					
					this.addChild(modulo_formulario);
					modulosCriados.push(modulo_formulario);
					break
				
				case 'video' :
					modulo_video = new ModuloVideo({idM:_idModule, idI:modulos[0][1]});
					modulo_video.x = _xmlModule[modulos[0][1]].@x;
					modulo_video.y = _xmlModule[modulos[0][1]].@y;
					//trace('BTN FROM MODULE BUILDER: ' + _xmlModule[modulos[0][1]].@img);
					modulo_video.addEventListener('cargaCompleta', videoModuleCarregado);
					this.addChild(modulo_video);
					modulosCriados.push(modulo_video);
					break;
				
				case 'btn-video' :
					modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:modulos[0][1]});
					
					modulo_imagem2.x = _xmlModule[modulos[0][1]].@x;
					modulo_imagem2.y = _xmlModule[modulos[0][1]].@y;
					
					//trace('BTN FROM MODULE BUILDER: ' + _xmlModule[modulos[0][1]].@img);
					
					modulo_imagem2.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
					//modulo_imagem.alpha = 0;
					modulo_imagem2.addEventListener(TouchEvent.TOUCH, abreVideo);
					this.addChild(modulo_imagem2);
					modulosCriados.push(modulo_imagem2);
					break;
				
				case 'btn-galeria' :
					modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:modulos[0][1], idT:"none"});
					
					modulo_imagem2.x = _xmlModule[modulos[0][1]].@x;
					modulo_imagem2.y = _xmlModule[modulos[0][1]].@y;
					
					//trace('BTN FROM MODULE BUILDER: ' + _xmlModule[modulos[0][1]].@img);
					
					modulo_imagem2.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
					//modulo_imagem.alpha = 0;
					modulo_imagem2.addEventListener(TouchEvent.TOUCH, abreGaleria);
					this.addChild(modulo_imagem2);
					modulosCriados.push(modulo_imagem2);
					break;
				
				case 'swf' :
					modulo_imagem2 = new MyImageLoader2({idM:_idModule, idI:modulos[0][1]});
					
					modulo_imagem2.x = _xmlModule[modulos[0][1]].@x;
					modulo_imagem2.y = _xmlModule[modulos[0][1]].@y;
					
					//trace('BTN FROM MODULE BUILDER: ' + _xmlModule[modulos[0][1]].@img);
					
					modulo_imagem2.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
					//modulo_imagem.alpha = 0;
					modulo_imagem2.addEventListener(TouchEvent.TOUCH, abreSWF);
					this.addChild(modulo_imagem2);
					modulosCriados.push(modulo_imagem2);
					break;
				
				case 'carrossel' :
					modulo_carrossel = new ModuloCarrossel({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_carrossel.y = getY;
					}else{
						modulo_carrossel.y = yInicial;
					}
					
					//trace('y: ' + getY + ' x: ' + _xmlModule[modulos[0][1]].@x);
					
					modulo_carrossel.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_carrossel.alpha = 0;
					modulo_carrossel.addEventListener(propagaEvento.COMPLETED, carrosselModuleCreated);
					this.addChild(modulo_carrossel);
					modulosCriados.push(modulo_carrossel);
					break;
				
				case 'galeria-multitouch' :
					modulo_galeriaMultitouch = new ModuloGaleriaMultitouch({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_galeriaMultitouch.y = getY;
					}else{
						modulo_galeriaMultitouch.y = yInicial;
					}
					
					//trace('y: ' + getY + ' x: ' + _xmlModule[modulos[0][1]].@x);
					
					modulo_galeriaMultitouch.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_galeriaMultitouch.alpha = 0;
					modulo_galeriaMultitouch.addEventListener(propagaEvento.COMPLETED, galMultiModuleCreated);
					this.addChild(modulo_galeriaMultitouch);
					modulosCriados.push(modulo_galeriaMultitouch);
					break;
				
				case 'campo' :
					textFormat = new TextFormat( "Gotham", _fontSize, 0XFFFFFF);
					
					textRenderer = new TextFieldTextRenderer();
					textRenderer.textFormat = textFormat;
					textRenderer.embedFonts = true;
					textRenderer.wordWrap = true;
					textRenderer.isHTML = true;
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						textRenderer.y = getY;
					}else{
						textRenderer.y = yInicial;
					}
					
					var teste:Object;
					teste.cnome = "ISSO";
					//trace('y: ' + getY + ' x: ' + _xmlModule[modulos[0][1]].@x);
					
					textRenderer.x = _xmlModule[modulos[0][1]].@x;
					
					textRenderer.text = teste.cnome;
					
					textRenderer.alpha = 0;
					textRenderer.addEventListener(propagaEvento.COMPLETED, galMultiModuleCreated);
					this.addChild(textRenderer);
					modulosCriados.push(textRenderer);
					break;
				
				case 'custom' :
					modulo_custom = new ModuloCustomChoice({idM:_idModule, idI:modulos[0][1]});
					
					getY =  _xmlModule[modulos[0][1]].@y;
					if(getY>0){
						modulo_custom.y = getY;
					}else{
						modulo_custom.y = yInicial;
					}
					modulo_custom.x = _xmlModule[modulos[0][1]].@x;
					
					modulo_custom.alpha = 1;
					modulo_custom.addEventListener('cargaCompleta', customCreated);
					this.addChild(modulo_custom);
					modulosCriados.push(modulo_custom);
					
					break;
			}
			
		}
		private function customCreated(evt:starling.events.Event):void{
			modulos.splice(0,1);
			createModulos();
			//trace('CUSTOM CREATED');
		}
		
		private function btnFormCreated(evt:starling.events.Event):void{
			modulos.splice(0,1);
			createModulos();
		}
		
		private function btnFormClicado(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as ModuloBtnForm, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);
				
				TweenMax.to(evt.currentTarget, .1, {scaleX:Number(_xmlRoot.menu[0].@btnPressScale), scaleY:Number(_xmlRoot.menu[0].@btnPressScale), yoyo:true, repeat:1, ease:Quad.easeOut});
								
				try{
					//globalVars.cadastro2[xml.menu[(evt.currentTarget as MyImageLoader2)._props.idM].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@vr] = xml.menu[(evt.currentTarget as MyImageLoader2)._props.idM].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@index
				}catch(err){};

				if(globalVars.escolha.length == 0){
					globalVars.escolha.push(globalVars.xml.menu[(evt.currentTarget as ModuloBtnForm)._props.idM].modulo[(evt.currentTarget as ModuloBtnForm)._props.idI].@vr);
				}else{
					for(var i:Number=0; i<globalVars.escolha.length; i++){
						if(globalVars.escolha[i] == globalVars.xml.menu[(evt.currentTarget as ModuloBtnForm)._props.idM].modulo[(evt.currentTarget as ModuloBtnForm)._props.idI].@vr){
							globalVars.escolha.splice(i,1);
							break;
						}
						if(i == globalVars.escolha.length-1){
							globalVars.escolha.push(globalVars.xml.menu[(evt.currentTarget as ModuloBtnForm)._props.idM].modulo[(evt.currentTarget as ModuloBtnForm)._props.idI].@vr);
							break;
						}
					}
				}

				trace('ARRAY ' +  globalVars.escolha);
				
				if(globalVars.escolha.length == 5){
					r = this.root as Main;
					//r.trocaPagina();
				}
			}
			
		}
		
		
		private function videoModuleCreated(evt:starling.events.Event):void
		{
			
			//if(transicao == 'scaleFromCenter'){
				//trace('SCALE -> ' + xml.menu[modulo_imagem2._props.idM].modulo[modulo_imagem2._props.idI].@pagina);
			
			//}
			(evt.currentTarget as ModuloBtnVideo).y += 183 ;
			(evt.currentTarget as ModuloBtnVideo).x += 320 ;
			
			//trace((evt.currentTarget as ModuloBtnVideo).w)
			
			evt.currentTarget.removeEventListener('cargaCompleta', videoModuleCreated);
			
			(evt.currentTarget as ModuloBtnVideo).alpha = 1;

			modulos.splice(0,1);
			createModulos();
			
		}
		
		// ------------------------------------------------------------------------------------------------------------ | LISTENERS FUNCTIONS
		
		private function formularioModuleCreated(evt:starling.events.Event):void
		{
			evt.currentTarget.removeEventListener(propagaEvento.FORMULARIOLOADED, formularioModuleCreated);
			
			trace('formulario modulo OK');
			
			modulo_formulario.alpha = 1;

			modulos.splice(0,1);
			createModulos();
			
		}
		
		private var loader:Loader;
		private var temp:String;
		private var quad1:starling.display.Shape
		
		private function abreSWF(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				
				quad1 = new starling.display.Shape();
				quad1.graphics.beginFill(0x000000, .8);
				quad1.graphics.drawRect(0, 0, 1920, 1080);
				quad1.graphics.endFill();

				addChild(quad1);
				
				xis = new MyImageLoader2({idM:0, idI:0});
				xis.x = Starling.current.stage.width - 120;
				xis.y = 60;
				
				xis.addEventListener(TouchEvent.TOUCH, fechaSWF);
				
				addChild(xis);
				
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onComplete);
				
				loader.x = 0;
				loader.y = 0;
				
				loader.load(new URLRequest(_xmlRoot.menu[_idModule].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].@swf));
				
				temp = _xmlModule[(evt.currentTarget as MyImageLoader2)._props.idI].@info

			}
		}
		
		private function onComplete(event:flash.events.Event):void
		{

			
			//loader.scaleX = .8;
			//loader.scaleY = .8;
			
			
			
			Starling.current.nativeOverlay.addChild(loader);
			
			//loader.content['pdfs'] = temp;
			
		}
		
		private function fechaSWF(evt:TouchEvent=null):void
		{
			
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				trace('FECHA A PARADA');
				
				loader.unload();
				Starling.current.nativeOverlay.removeChild(loader);

				xis.dispose();
				removeChild(xis);
				
				removeChild(quad1);
				
				temp = '';

			}
			
		}
		
		private function abreVideo(evt:TouchEvent):void
		{
			
			
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				
				trace('abriu');
				
				if(prontoTween == true){
					prontoTween = false;
					modulo_btn_video = new ModuloVideoStarling((evt.currentTarget as MyImageLoader2));
					modulo_btn_video.addEventListener('cargaCompleta', btnVideoModuleCarregado);
					modulo_btn_video.addEventListener('disposed', disposedVideo);
					addChild(modulo_btn_video);
					TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});
				}
			}
			
		}
		
		private function disposedVideo(evt:starling.events.Event):void
		{
			trace('disposed');
			modulo_btn_video.removeEventListener('disposed', disposedVideo);
			removeChild(evt.currentTarget as ModuloVideoStarling);
			
		}
		
		private function btnVideoModuleCarregado(evt:starling.events.Event):void
		{
			
			try{
				modulo_btn_video.removeEventListener('cargaCompleta', btnVideoModuleCarregado);
			}catch(err){};
			
			prontoTween = true;
		}
		
		private function videoModuleCarregado(evt:starling.events.Event):void
		{
			try{
				modulo_video.removeEventListener('cargaCompleta', videoModuleCarregado);
			}catch(err){};
			
			modulo_video.alpha = 1;
			
			prontoTween = true;
			
			modulos.splice(0,1);
			createModulos();
		}
		
		private function popupModuleCarregado(evt:starling.events.Event):void
		{
			try{
				modulo_btn_video.removeEventListener('cargaCompleta', popupModuleCarregado);
			}catch(err){};

			prontoTween = true;
		}
		
		private function abreGaleria(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				modulo_popup_galeria = new ModuloPopupGaleria((evt.currentTarget as MyImageLoader2));
				modulo_popup_galeria.addEventListener('cargaCompleta', popupModuleCarregado);
				addChild(modulo_popup_galeria);
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});

			}
			
		}
		
		private function tweenFinished():void{
			TweenMax.to(modulo_imagem, 1, {alpha:0, onComplete:function():void{modulos.splice(0,1);createModulos();modulo_imagem.alpha=1;}});
		}
		
		
		private function imageModuleMaskCreated(evt:starling.events.Event):void{
			modulo_imagem.removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
		}
		
		
		private function clicado(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);

				TweenMax.to(evt.currentTarget, .1, {scaleX:Number(_xmlRoot.menu[0].@btnPressScale), scaleY:Number(_xmlRoot.menu[0].@btnPressScale), yoyo:true, repeat:1, ease:Quad.easeOut, onComplete:btnClicado, onCompleteParams:[evt.currentTarget]});
				
				if(_xmlRoot.menu[_idModule].@modelo != "timeline"){
					//r = this.root as Main;
					//r.trocaPagina(evt.currentTarget as MyImageLoader2);
				}
				
				try{
					globalVars.cadastro2[xml.menu[(evt.currentTarget as MyImageLoader2)._props.idM].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@vr] = xml.menu[(evt.currentTarget as MyImageLoader2)._props.idM].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@index
				}catch(err){};
				
				//trace('VARIABLE: ' + xml.menu[(evt.currentTarget as MyImageLoader2)._props.idM].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@vr);

			}
			
		}
		
		private function btnClicado(mc):void{
			r = this.root as Main;
			r.trocaPagina(mc as MyImageLoader2);
		}
		
		private function btnVideoclicado(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as ModuloBtnVideo, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);
				
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});
				
			/*	if(_xmlRoot.menu[_idModule].@modelo != "timeline"){
					r = this.root as Main;
					r.trocaPagina(evt.currentTarget as ModuloBtnVideo);
				}*/
				
			}
			
		}		
		
		
		private function imageModuleCreated(evt:starling.events.Event):void{

			evt.currentTarget.removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
			
			

			try{
				var modo:XML = _xmlRoot.menu[(evt.currentTarget as MyImageLoader2)._props.idM].modulo[(evt.currentTarget as MyImageLoader2)._props.idI];
				
				//trace('CREATED : ' + modo.@tipo);
				
				if(modo.@transition == 'scaleFromCenter'){
					
					modulo_imagem2.alpha = 1;
					//trace('SCALE');
					//trace('SCALE -> ' + xml.menu[modulo_imagem2._props.idM].modulo[modulo_imagem2._props.idI].@pagina);
					modulo_imagem2.x += modulo_imagem2.width/2;
					modulo_imagem2.y += modulo_imagem2.height/2;
				}
				
				if(modo.@transition == 'elastic'){
					
					modulo_imagem2.alpha = 1;
					
					(evt.currentTarget as MyImageLoader2).x += (evt.currentTarget as MyImageLoader2)._width/2;
					(evt.currentTarget as MyImageLoader2).y += (evt.currentTarget as MyImageLoader2)._height/2;
					
					//TweenMax.fromTo(evt.currentTarget as MyImageLoader2, .3, {scaleX:1, scaleY:1, alpha:1, yoyo:true, repeat:1, ease:Quad.easeInOut},{scaleX:.8, scaleY:.8, yoyo:true, repeat:1, ease:Quad.easeInOut});
					//trace('SCALE');
					//trace('SCALE -> ' + xml.menu[modulo_imagem2._props.idM].modulo[modulo_imagem2._props.idI].@pagina);
					//(evt.currentTarget as MyImageLoader2).x += (evt.currentTarget as MyImageLoader2)._width/2;
					//(evt.currentTarget as MyImageLoader2).y += (evt.currentTarget as MyImageLoader2)._height/2;
					//TweenMax.fromTo(modulo_imagem2, .3, {scaleX:1, scaleY:1, alpha:1, yoyo:true, repeat:1, ease:Quad.easeInOut},{scaleX:.8, scaleY:.8, yoyo:true, repeat:1, ease:Quad.easeInOut});
				}
				
				if(modo.@tipo == 'btn'){

					(evt.currentTarget as MyImageLoader2).x += (evt.currentTarget as MyImageLoader2)._width/2;
					(evt.currentTarget as MyImageLoader2).y += (evt.currentTarget as MyImageLoader2)._height/2;
					
					(evt.currentTarget as MyImageLoader2).alpha = 1;
				}
				
			}catch(err){};
			
			//trace("HAS ALPHA: " + (evt.currentTarget as MyImageLoader2).alpha);
			
			modulos.splice(0,1);
			createModulos();
			
		}
		
		private function gifModuleCreated(evt:starling.events.Event):void{
			
			//trace('GIF CRIADA');
			(evt.currentTarget as MyImageLoader2).img.y -= (evt.currentTarget as MyImageLoader2).height/2;
			(evt.currentTarget as MyImageLoader2).img.x -= (evt.currentTarget as MyImageLoader2).width/2;

			(evt.currentTarget as MyImageLoader2).removeEventListener(propagaEvento.IMAGELOADED, gifModuleCreated);
			
			
			(evt.currentTarget as MyImageLoader2).alpha = 1;
			//TweenMax.delayedCall(Math.random()*1, setTransition)

			setTransition()
			
			
		}
		
		private function setTransition():void
		{
			
			var transicao:String = _xmlModule[modulos[0][1]].@transition;
			
			switch(transicao){
				case 'rotation' :
					modulo_imagem2.alpha = .8;
					TweenMax.to(modulo_imagem2, 1, { rotation:6.3, repeat:-1, repeatDelay:0, ease:Linear.easeNone});
					TweenMax.to(modulo_imagem2, 1, { scaleX:.6, scaleY:.6, repeat:-1, repeatDelay:0, yoyo:true, ease:Quad.easeInOut});
					modulo_imagem2.filter = new starling.filters.BlurFilter(10, 10);
					Starling.juggler.tween(modulo_imagem2.filter, 1, { blurX: 4, blurY: 4 });
					break
				
				case 'scale' :
					TweenMax.from(modulo_imagem2, 2, { alpha:.5, scaleX:.8, scaleY:.8, yoyo:true, repeat:-1, repeatDelay:0,  ease:Quad.easeInOut});
					break;
			}
			
			modulos.splice(0,1);
			createModulos();
			//trace("?")
		}
		
		private function carrosselModuleCreated(evt:starling.events.Event):void{
			
			//trace('terminou');
			
			modulo_carrossel.removeEventListener(propagaEvento.COMPLETED, carrosselModuleCreated);

			TweenLite.to(modulo_carrossel, .5, {alpha:1});
			modulos.splice(0,1);
			
			createModulos();
			
			
		}
		
		private function galMultiModuleCreated(evt:starling.events.Event):void{
			
			//trace('terminou');
			
			modulo_galeriaMultitouch.removeEventListener(propagaEvento.COMPLETED, carrosselModuleCreated);
			
			TweenLite.to(modulo_galeriaMultitouch, .5, {alpha:1});
			modulos.splice(0,1);
			
			createModulos();
			
			
		}
		
		private function galleryModuleCreated(evt:starling.events.Event):void{
			modulo_galeria.removeEventListener(propagaEvento.COMPLETED, galleryModuleCreated);
			
		//	trace('AGORA');
			
			TweenLite.to(modulo_galeria, .5, {alpha:1});
			modulos.splice(0,1);
			
			createModulos();
		}
		
		private function scrollModuleCreated(evt:starling.events.Event):void{
			modulo_scroll.removeEventListener(propagaEvento.COMPLETED, scrollModuleCreated);
			TweenLite.to(modulo_scroll, .5, {alpha:1});
			modulos.splice(0,1);
			
			createModulos();
		}
		
		private function popupModuleCreated(evt:starling.events.Event):void
		{
			modulo_popup.removeEventListener(propagaEvento.COMPLETED, popupModuleCreated);
			//TweenLite.to(modulo_block, .5, {alpha:1});
			modulos.splice(0,1);
			
			createModulos();
		}
		
		private function blockModuleCreated(evt:starling.events.Event):void
		{
			modulo_block.removeEventListener(propagaEvento.COMPLETED, blockModuleCreated);
			TweenLite.to(modulo_block, .5, {alpha:1});
			modulos.splice(0,1);
			
			createModulos();
		}
		
		private function tabModuleCreated(evt:starling.events.Event):void
		{
			
			//trace('TAB');
			
			modulo_tab.removeEventListener(propagaEvento.COMPLETED, tabModuleCreated);
			modulo_tab.alpha = 1;
			modulos.splice(0,1);
			
			createModulos();
		}
		
		private function removeModules():void{
			transitioning = true;
			
			for(var i:Number=0; i<modulosCriados.length; i++){
			//	trace(modulosCriados);
				//TweenLite.to(modulosCriados[i], .5,{ onComplete:removeModule, delay:1, onCompleteParams:[modulosCriados[i]]});
				
				//TweenMax.delayedCall(1, removeModule, [modulosCriados[i]]);
			}
		}
		
		private function removeModule(target):void{
			target.dispose();
			removeChild(target);
			modulosCriados.splice(0,1);
			
			if(modulosCriados.length == 0){
				//trace("?");
				createModulos();
			}
			
		}
		
		public function get transition():Boolean{
			return transitioning;
		}
		
		/*public function flat():void{
			for(var i:Number = numChildren; i--;){
				this.flatten();
			}
		}*/

		override public function dispose():void{
			
		//	trace('====================== TRY DISPOSE');
			
			try{
				if(loader){
					fechaSWF();
					xis.dispose();
					removeChild(xis);
					
					removeChild(quad1);
				}
			}catch(err){}
			
			for(var i:Number = numChildren; i--;){

				try{
					if(getChildAt(i).hasEventListener(TouchEvent.TOUCH)){
						getChildAt(i).removeEventListener(TouchEvent.TOUCH, clicado);
					}
				}catch(err){};
				
				try{
					if(getChildAt(i).hasEventListener(TouchEvent.TOUCH)){
						getChildAt(i).removeEventListener(TouchEvent.TOUCH, abreVideo);
					}
				}catch(err){};
				
				try{
					if(getChildAt(i).hasEventListener(TouchEvent.TOUCH)){
						getChildAt(i).removeEventListener(TouchEvent.TOUCH, abreGaleria);
					}
				}catch(err){};
				
				try{
					getChildAt(i).dispose()
				}catch(err){}
				
				removeModule(getChildAt(i))
			}

		}
	}
}