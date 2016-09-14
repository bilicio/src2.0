package classes.antidoto.componentes
{
	
	import com.greensock.TweenMax;
	
	import classes.antidoto.Assets;
	import classes.antidoto.ImageLoaderBA;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ModuloTab extends Sprite
	{
		private var _bgColor:uint;
		
		private var img:MyImageLoader2;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:*;
		
		private var _h:Number;
		private var _w:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;

		//private var imagem:ImageLoaderBA;
		
		private var container:ScrollContainer;
		
		private var tabArr:Array = new Array();
		private var imageArr:Array = new Array();
		
		private var retangArra:Array = new Array();
		
		private var retangulo:Shape;
		
		private var tabActive:Number = 0;
		
		private var modules:ModuloBuilder;
		
		private var _props:Object;
		
		private var transitioning:Boolean = false;
		
		private var shapeImg:Image;
		
		private var _hShape:Number;
		private var _wShape:Number;
		
		public function ModuloTab(props:Object)
		{
			
			
			_props = props;
			
			_xml = globalVars.xml.menu[props.idM].modulo[props.idI];
			
			_bgColor = _xml.@color;
			_w = _xml.@w;
			_h = _xml.@h;
			
			_hShape = Number(_xml.item[0].@h);
			_wShape = _w /_xml.item.length() - 5;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.height = _h;
		}
		
		private function criaComponente(evt:Event):void
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			for(var i:Number = 0; i<_xml.item.length(); i++){
				
				retangulo = new Shape();
				retangulo.graphics.beginFill(_bgColor);
				retangulo.graphics.drawRect(0, 0, _wShape, _hShape);
				retangulo.graphics.endFill();
				
				retangulo.x = (_wShape + 5) * i
				
				retangulo.alpha = .8;
					
				addChild(retangulo);
				
				retangulo.addEventListener(TouchEvent.TOUCH, apertaTab);
				
				tabArr.push(retangulo);
				
		
				
				img = new MyImageLoader2({idM:0, idI:0 });
				img.x = retangulo.x + retangulo.width/2;
				img.y = Number(_hShape/2);
				img.pivotX = Number(_hShape/2);
				img.pivotY = Number(_hShape/2);
				//img.addEventListener(TouchEvent.TOUCH, fechaPopup);
				
				imageArr.push(img);
				
				addChild(img);
				
				
				
				
				
				/*img = new ImageLoaderBA();
				img.maintainAspectRatio = false;
				img.x = (1080/_xml.tab.length()) * i;
				
				img.touchable = false;
				
				imageArr.push(img);
				
				//img.source = File.documentsDirectory.resolvePath("queiroz_galvao/img/"+_xml.tab[i].@img).url;
				img.source = Assets.getImage(_xml.tab[i].@img);
				
				addChild(img);*/
				
				/*if(i == 0){
					retangulo.graphics.clear();
					retangulo.graphics.beginFill(_bgColor);
					retangulo.graphics.drawRect(0, 0, (Starling.current.stage.width/_xml.item.length())-2, 80);
					retangulo.graphics.endFill();
					
					TweenMax.from(retangulo, .5, {y:80, height:0});
					
					//if(_xml.@hover != 0){
					//	img.color = _xml.@hover;
					//}
					
					modules = new ModuloBuilder({localID:1});
					modules.y = 105;
					addChild(modules);
					
					modules.addEventListener(propagaEvento.COMPLETED, transitionOFF);
				}*/
				
				
				
				/*container = new ScrollContainer();
				container.height = _h
				container.width = _w = 1080 / _xml.img.length();
				container.x = i * (1080 / _xml.img.length());
				
				imagem = new ImageLoader();
				imagem.source = File.documentsDirectory.resolvePath("queiroz_galvao/img/"+_xml.img[i]).url;
				imagem.addEventListener(Event.COMPLETE, botaMask);
				
				imageArr.push([imagem,container]);
				
				container.addChild(imageArr[i][0]);
				container.layout = layout;
				
				addChild(container);*/
			}
			
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			
		}
		
		private function transitionOFF(evt:Event):void
		{
			transitioning = false;
			
		}
		
		private function apertaTab(evt:TouchEvent):void
		{
			
			var SP:Shape =  evt.currentTarget as Shape;
			
			
		
			if(evt.getTouch(SP, TouchPhase.ENDED)){
				
				SP.alpha = 1;
				
				SP.height += 10;
				
				if(!transitioning){
					
					transitioning = true;
					
					for(var i:Number = tabArr.length; i--;){
						if(tabArr[i] == SP){
							if(i != tabActive){
								
								clearTabs();
								//SP.alpha = 0;
								SP.graphics.beginFill(_bgColor);
								SP.graphics.drawRect(0, 0, (Starling.current.stage.width/_xml.item.length())-2, 80);
								SP.graphics.endFill();
								
								TweenMax.from(SP, .5, {y:80, height:0});
								
								if(_xml.@hover != 0){
									imageArr[i].color = _xml.@hover;
								}
								
								tabActive = i;
								openModule(i);
							}
						}else{
							SP.graphics.beginFill(0x00ff00);
							SP.graphics.endFill();
						}
					}
				}else{
					//trace('TRANSITIONING');
				}
			}
			
			
		}
		
		private function openModule(i:Number):void
		{
			//modules.xml = _xml.tab[i].modulo
			//modules.abrirModulos();
			
		}
		
		private function clearTabs():void{
			for(var i:Number = 0; i<tabArr.length; i++){
				tabArr[i].graphics.clear();
				tabArr[i].graphics.beginFill(0x363636);
				tabArr[i].graphics.drawRect(0, 0, (Starling.current.stage.width/_xml.item.length())-2, 80);
				tabArr[i].graphics.endFill();
			}
		}
		
		
		
		
		
		override public function dispose():void{
			for(var i:Number=0; i<imageArr.length; i++){
				
				imageArr[i].dispose();
				removeChild(imageArr[i]);
				
				tabArr[i].removeEventListener(TouchEvent.TOUCH, apertaTab);
				removeChild(tabArr[i]);
				
			}
			
			for(var a:Number = 0; a<retangArra.length; a++){
				removeChild(retangArra[a]);
			}
			
			modules.removeEventListener(propagaEvento.COMPLETED, transitionOFF);
			
			imageArr = [];
			imageArr = null;
			
			tabArr = [];
			tabArr = null;
			
			imageArr = [];
			imageArr = null;
			
			modules.dispose();
			
			/*if(img_Clima){	
			img_Clima.dispose();
			}*/
			
			//trace('disposed!!!');
		}
	}
}