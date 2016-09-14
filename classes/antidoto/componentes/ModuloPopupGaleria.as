package classes.antidoto.componentes
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ModuloPopupGaleria extends Sprite
	{
		private var _bgColor:uint;
		
		private var img:MyImageLoader2;
		private var xis:MyImageLoader2;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:XMLList;
		
		private var _h:Number;
		private var _w:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var imagem:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var imageArr:Array;
		
		private var blockListaLayout:TiledRowsLayout;
		
		private var quad:Quad;
		
		private var popupColor:uint = 0x000000;
		
		private var _props:Object;
		
		private var modulo_imagem:MyImageLoader;
		
		private var oY:Number = 0;
		private var oX:Number = 0;
		
		private var contImagens:Number = 0;
		
		private var allCompleted:Boolean = false;
		
		private var totalW:Number;
		private var totalH:Number;
		
		private var modules:ModuloBuilder;
		private var modulo_galeria:ModuloGaleria;
		
		public static const FINISHED:String = "cargaCompleta";
		
		public function ModuloPopupGaleria(image:MyImageLoader2)
		{
			_props = image._props;

			_xml = globalVars.xml;
			
			totalW = Starling.current.stage.width;
			totalH = Starling.current.stage.height;
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);

		}
		
		private function criaComponente(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			
			criaImagem();
		
		}
		
		private function criaImagem():void
		{

			criaFundo();

			modulo_galeria = new ModuloGaleria({idM:_props.idM, idI:_props.idI});
			
			var getY:Number =  globalVars.xml.menu[_props.idM].modulo[_props.idI].item.@y;
			if(getY>0){
				modulo_galeria.y = getY;
			}else{
				modulo_galeria.y = 0;
			}

			modulo_galeria.x = globalVars.xml.menu[_props.idM].modulo[_props.idI].item.@x;
			
			modulo_galeria.alpha = 0;
			modulo_galeria.addEventListener(propagaEvento.COMPLETED, galleryModuleCreated);
			this.addChild(modulo_galeria);
			
			
			
		}
		
		private function galleryModuleCreated(evt:starling.events.Event):void{
			modulo_galeria.removeEventListener(propagaEvento.COMPLETED, galleryModuleCreated);

			TweenLite.to(modulo_galeria, .5, {alpha:1});
			this.dispatchEventWith(FINISHED, false, '');
			
			modulo_galeria.x = totalW/2 - modulo_galeria.width/2;
			modulo_galeria.y = totalH/2 - modulo_galeria.height/2;
			
			abreXis();
		}

		private function criaFundo():void
		{
			
			quad = new Quad(1, 1080, popupColor);
			quad.alpha = .8;
			
			quad.x = 0;
			quad.y = 0;
			
			quad.addEventListener(TouchEvent.TOUCH, fechaPopup);
			
			addChild(quad);

			TweenMax.to(quad, .5, {width:totalW, onComplete:function():void{ TweenLite.to(quad, .5, {height:totalH});}});

		}
		
		private function abreXis():void
		{

			xis = new MyImageLoader2({idM:0, idI:0});
			//img.maintainAspectRatio = false;
			xis.x = Starling.current.stage.stageWidth - 80;
			xis.y = 20;
			
			xis.addEventListener(TouchEvent.TOUCH, fechaPopup);

			addChild(xis);
			
		}
		
		private function fechaPopup(evt:TouchEvent = null):void
		{
			//trace('XIS');
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);

				TweenMax.to(quad, .5, {height:1});
				
				xis.dispose();
				removeChild(xis);
				
				quad.removeEventListener(TouchEvent.TOUCH, fechaPopup);
				xis.removeEventListener(TouchEvent.TOUCH, fechaPopup);
				
				TweenMax.delayedCall(1, function():void{removeChild(quad);});

				modulo_galeria.dispose();
				removeChild(modulo_galeria);
			}

		}

		
		override public function dispose():void{
			xis.dispose();
			removeChild(xis);
			
			quad.removeEventListener(TouchEvent.TOUCH, fechaPopup);
			xis.removeEventListener(TouchEvent.TOUCH, fechaPopup);
			
			removeChild(quad);

			modulo_galeria.dispose();
			removeChild(modulo_galeria);
		}
	}
}