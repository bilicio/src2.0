package classes.antidoto.componentes
{

	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	import flash.utils.Timer;
	
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ModuloGaleriaMultitouch extends Sprite
	{
		private var _bgColor:uint;
		
		private var img:Image;
		private var dpi:Number;
		
		private var panel:ScrollContainer;
		private var _pageIndicator:PageIndicator;
		private var layout:HorizontalLayout;
		
		private var imgArr:Array = new Array();
		
		private var retangulo:starling.display.Quad;
		private var label:Label;
		
		private var _xml:XMLList;
		
		private var imgCont:Number = 0;
		private var _pageIndicatorY:Number;
		
		private var ldr:MyImageLoader2;
		
		private var images:Array = new Array();
		
		private var nlabel:Label;
		
		private var _props:Object;
		
		private var _counterSize:Number;
		
		private var molduraHeight:Number = 25;
		
		private var oldPos:Number = 0;
		
		private var lockSlide:Boolean = false;
		
		//[Embed(source="../../../assets/seta.png")]
		//public static const setaEsq:Class;
		
		private var setaDirIL:ImageLoader = new ImageLoader();
		private var setaEsqIL:ImageLoader = new ImageLoader();
		
		private var timer:Timer;
		private var inverse:Boolean = false;
		
		private var _w:Number;
		private var _h:Number;
		
		//private var zipFile:ZipFile;
		
		public function ModuloGaleriaMultitouch(props:Object)
		{
			_props = props;
			
			_xml = globalVars.xml.menu[props.idM].modulo[props.idI].item;
			
			_w = globalVars.xml.menu[props.idM].modulo[props.idI].@width;
			_h = globalVars.xml.menu[props.idM].modulo[props.idI].@height;
			
			_bgColor = globalVars.xml.@color;
			_pageIndicatorY = globalVars.xml.menu[props.idM].modulo[props.idI].@counterY;
			_counterSize = globalVars.xml.menu[props.idM].modulo[props.idI].@counterSize;

			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);

		}
		
		
		
		private function criaComponente(evt:Event):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			trace('GALERIA MULTITOUCH');
			
			retangulo = new starling.display.Quad(globalVars.xml.menu[_props.idM].modulo[_props.idI].@width, globalVars.xml.menu[_props.idM].modulo[_props.idI].@height, 0x000000);
			retangulo.alpha = globalVars.xml.menu[_props.idM].modulo[_props.idI].@guide == "true"?.5:0;
			
			/*retangulo = new Shape;
			retangulo.graphics.beginFill(0x000000,globalVars.xml.menu[_props.idM].modulo[_props.idI].@guide == "true"?.5:0);
			retangulo.graphics.drawRect(0,0, globalVars.xml.menu[_props.idM].modulo[_props.idI].@width, globalVars.xml.menu[_props.idM].modulo[_props.idI].@height);*/
			addChild(retangulo);
				
			for(var i:Number=0; i<_xml.modulo.length(); i++){
				//trace('openimage');
				ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:i, max:true});
				ldr.addEventListener(propagaEvento.IMAGELOADED, espalha);
				
				imgArr[i] = ldr
					
				ldr.addEventListener(TouchEvent.TOUCH, toFront);

			}
			
			imgCont = 0;
			
			this.dispatchEventWith(propagaEvento.COMPLETED, false);
		}
		
		private function toFront(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				setChildIndex((evt.currentTarget as MyImageLoader2), numChildren-1);
			}
			
		}
		
		private function espalha(evt:Event):void
		{
			addChild(evt.currentTarget as MyImageLoader2);

			var media:Number = Math.random()*-1 + .5;
			var randomX:Number = Math.random()*_w;
			var randomY:Number = Math.random()*_h;

			TweenLite.fromTo((evt.currentTarget as MyImageLoader2).img, 2, {x:_w/2, 
																			y:_h/2, scaleX:0, 
																			scaleY:0, 
																			ease:com.greensock.easing.Quad.easeOut}, 
																		   {x:randomX, 
																			y:randomY, 
																			scaleX:globalVars.xml.menu[_props.idM].modulo[_props.idI].@minScale, 
																			scaleY:globalVars.xml.menu[_props.idM].modulo[_props.idI].@minScale, 
																			rotation: media,  
																			ease:com.greensock.easing.Quad.easeOut});
			
			TweenLite.fromTo((evt.currentTarget as MyImageLoader2).img2, 2, {x:_w/2, 
																			y:_h/2, scaleX:0, 
																			scaleY:0, 
																			ease:com.greensock.easing.Quad.easeOut}, 
																			{x:randomX, 
																			 y:randomY, 
																			 scaleX:globalVars.xml.menu[_props.idM].modulo[_props.idI].@minScale, 
																			 scaleY:globalVars.xml.menu[_props.idM].modulo[_props.idI].@minScale, 
																			 rotation: media,  
																			 ease:com.greensock.easing.Quad.easeOut});
			
		}		

		override public function dispose():void{
			try{
				for(var i:Number=0; i<imgArr.length; i++){
					imgArr[i].dispose();
					removeChild(imgArr[i]);
				}
			}catch(err:Error){};
			
			imgArr = [];
			imgArr = null;
			
			if(_xml.@autoPlay == 'true'){
				timer.stop();
			}

		}
	}
}