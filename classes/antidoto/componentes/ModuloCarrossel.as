package classes.antidoto.componentes
{

	import com.ficon.FontAwesome;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import app.Main;
	
	import classes.antidoto.FontAwesomeStarling;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class ModuloCarrossel extends Sprite
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
		
		private var img:Image;
		private var dpi:Number;
		
		private var panel:ScrollContainer;
		private var _pageIndicator:PageIndicator;
		private var layout:HorizontalLayout;
		
		private var imgArr:Array = new Array();
		private var imgArr2:Array = new Array();
		
		private var retangulo:starling.display.Quad;
		private var label:Label;
		
		private var _xml:XMLList;
		
		private var imgCont:Number = 0;
		private var _pageIndicatorY:Number;
		
		private var ldr:MyImageLoader2;
		
		private var images:Array = new Array();
		private var mcArray:Array = new Array();
		
		private var nlabel:Label;
		
		private var _props:Object;
		
		private var _counterSize:Number;
		
		private var molduraHeight:Number = 25;
		
		private var oldPos:Number = 0;
		
		private var lockSlide:Boolean = false;
		
		private var mc:Sprite;
		
		private var novoContA:Number = 0;
		private var novoContB:Number = 0;

		private var setaDirIL:ImageLoader = new ImageLoader();
		private var setaEsqIL:ImageLoader = new ImageLoader();
		
		private var timer:Timer;
		private var inverse:Boolean = false;
		
		private var _w:Number;
		private var _h:Number;
		
		private var _module:XML
		
		private var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();

		private var iconBitmapData:BitmapData;
		private var icon:TextField;
		private var iconTexture:Texture;
		private var iconImage:Image;
		
		private var r:Main;
		
		private var touchXOn:Number = 0;
		private var touchXOff:Number = 0;

		public function ModuloCarrossel(props:Object)
		{

			_module = globalVars.xml.menu[props.idM].modulo[props.idI]
			
			_w = _module.@width;
			_h = _module.@height;

			_props = props;
			
			_xml = _module.item;
			
			_bgColor = globalVars.xml.@color;
			_pageIndicatorY = _module.@counterY;
			_counterSize = _module.@counterSize;
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.addEventListener(TouchEvent.TOUCH, openSystem)
			
		}
		
		private function openSystem(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as DisplayObject, TouchPhase.BEGAN)){
				try{
					touchXOn = evt.getTouch(evt.currentTarget as DisplayObject).globalX;
				}catch(err){}
			}
			
			if(evt.getTouch(evt.currentTarget as DisplayObject, TouchPhase.ENDED)){
				touchXOff = evt.getTouch(evt.currentTarget as DisplayObject).globalX;

				if(Math.abs(touchXOn-touchXOff) < 10 && (touchXOn >700 &&  touchXOn <1100)){

					TweenMax.to(imgArr[panel.horizontalPageIndex], .2, {scaleX:.8, scaleY:.8, yoyo:true, repeat:1, ease:com.greensock.easing.Quad.easeOut});
					
					r = this.root as Main;
					r.trocaPagina(imgArr[panel.horizontalPageIndex] as MyImageLoader2);
				}
			}
			
		}
		
				
		private function criaComponente(evt:Event):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			panel = new ScrollContainer();

			panel.snapToPages = true;
			panel.autoHideBackground = true;
			panel.addEventListener(Event.SCROLL, foi);

			panel.clipContent = true;
			
			panel.width = Starling.current.stage.width;
			panel.pageWidth = _w;
			
			layout = new HorizontalLayout();
			//layout.gap = 0;
			//layout.padding = 70;
			layout.paddingLeft = _w*2-80;
			layout.paddingRight = _w*2;
			//layout.paddingBottom = 300;
			//layout.typicalItemWidth = 800;
			
			panel.layout = layout;
			
			panel.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			panel.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			
			this.addChild( panel );

			//this.clipRect = new Rectangle(-_module.@x, 0, Starling.current.stage.width, Starling.current.stage.height);
			
			_pageIndicator = new PageIndicator();
			
			if(_xml.modulo.length()==1){
				_pageIndicator.alpha = 0;
				//panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			}

			panel.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;

			for(var i:Number=0; i<_xml.modulo.length(); i++){
				images.push(i);
			}
			
			
			carregaImagem(images[0], 0);
			
			imgCont = 0;
		}
		
		
		private function carregaImagem(img, pos):void{

			if(pos%2 == 0){
				ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:novoContA, max:true});
				ldr.addEventListener(propagaEvento.IMAGELOADED, criaRetangulos);
				imgArr[novoContA] = ldr;
				novoContA++;
			}else{
			
				ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:novoContB, max:false});
				ldr.addEventListener(propagaEvento.IMAGELOADED, criaRetangulos);
				imgArr2[novoContB] = ldr;
				
				novoContB++;
			}
		}
		
		
		
		private function criaRetangulos(evt:Event):void{

			evt.target.removeEventListener(propagaEvento.IMAGELOADED, criaRetangulos);

			if(imgCont%2 == 0){
				
				(evt.target as MyImageLoader2).scaleX = 1;
				(evt.target as MyImageLoader2).scaleY = 1;

				mc = new Sprite();
				
				retangulo = new starling.display.Quad(_w, _h, 0x000000);
				retangulo.alpha = 0;
			
				/*retangulo = new Shape;
				retangulo.graphics.beginFill(0x000000,0);
				retangulo.graphics.drawRect(0,0, _w, _h);*/

				mc.addChild(retangulo)

			}
			
			mc.addChild(evt.target as MyImageLoader2)
			
			if(imgCont%2 != 0){
				mcArray.push(mc);
					
				panel.addChild(mc);
			}
			
			//trace('IMAGEARR: ' + images.length + " - " + imgCont);
			
			if(imgCont == 0){

				textRenderer.textFormat = new TextFormat( "Gotham", Number(_module.@textSize), uint(_module.@color));
				textRenderer.embedFonts = true;

				textRenderer.wordWrap = true;
				
				//textRenderer.text = "<span class='heading'>hello</span> <font color='#ff0000'> world!</font>";
				textRenderer.isHTML = true;
				
				textRenderer.addEventListener(TouchEvent.TOUCH, clicado);
				
				addChild(textRenderer);
				
			//	var trophy:flash.display.DisplayObject = FontAwesome[_module.@icon]({color: uint(_module.@color)})
					
			//	var scale:Number = Number(_module.@textSize /6) *.10;
				//var matrix:Matrix = new Matrix();
				//matrix.scale(scale, scale);
				
				//iconBitmapData = new BitmapData(75 * scale, 75 * scale, true, 0x000000);
				//iconBitmapData.draw(trophy, matrix, null, null, null, true);

				//iconTexture = Texture.fromBitmapData(iconBitmapData)
					
				//iconImage = new Image(iconTexture);
				
				//iconImage.addEventListener(TouchEvent.TOUCH, clicado);
				
				//addChild(iconImage)
				
				//iconBitmapData.dispose();
				
				var awe:FontAwesomeStarling = new FontAwesomeStarling(Number(_module.@textSize) , 0xfffffff); 
				
				icon = awe.getIconTextField(FontAwesomeStarling.plus_sign);
				
				icon.addEventListener(TouchEvent.TOUCH, clicadoIcon);
				
				addChild(icon);

				var DO:MyImageLoader2 = evt.currentTarget as MyImageLoader2;

				if(_xml.@moldura == 'true'){
					
					retangulo = new starling.display.Quad(DO.width, molduraHeight, _bgColor);
					retangulo.y = 0;
					
					/*retangulo = new Shape;
					retangulo.graphics.beginFill(_bgColor);
					retangulo.graphics.drawRect(0,0, DO.width, molduraHeight);
					retangulo.y = 0;*/
					addChild(retangulo);
					
					retangulo = new starling.display.Quad(DO.width, molduraHeight, _bgColor);
					retangulo.y = DO.y+DO.height+molduraHeight;
					
					/*retangulo = new Shape;
					retangulo.graphics.beginFill(_bgColor);
					retangulo.graphics.drawRect(0, 0, DO.width, molduraHeight);
					retangulo.y = DO.y+DO.height+molduraHeight;*/
					addChild(retangulo);
					
					panel.y = molduraHeight;
					
					//label.y = DO.y+DO.height -5;
					
					
					textRenderer.y = _h 
					_pageIndicator.y = DO.y+DO.height+2 +molduraHeight;
					
					//trace('PY: ' + _pageIndicatorY);
					
				}else{
					icon.y = _h + 50;
					textRenderer.y = _h + 50;
				}
				
				if(_pageIndicatorY == 0){
					_pageIndicator.y = DO.y+DO.height+2 ;
				}else{
					_pageIndicator.y = _pageIndicatorY + molduraHeight/2 - 12;
					
					//trace(_pageIndicatorY)
					//textRenderer.y = _pageIndicatorY-35;
					
					try{
						retangulo.y = _pageIndicatorY;
					}catch(err){};
					
					textRenderer.y = DO.y+DO.height - molduraHeight/2;
				}
				
				//setaEsqIL.source = Texture.fromBitmap( new setaEsq() as Bitmap );
				//	setaEsqIL.addEventListener( Event.COMPLETE, trace );
				
				//setaEsqIL.alpha = .5;
				//setaEsqIL.y = _pageIndicator.y/2 - 50;
				//addChild( setaEsqIL );
				
				//setaDirIL.source = Texture.fromBitmap( new setaEsq() as Bitmap );
				//setaDirIL.addEventListener( Event.COMPLETE, trace );
				
				//setaDirIL.y = _pageIndicator.y/2 - 50;
				//setaDirIL.x = DO.width;
				
				//setaDirIL.alpha = .5;
				
				//setaDirIL.scaleX = -1;
				//addChild( setaDirIL );
				
				setChildIndex(textRenderer, numChildren-1);
				
				
				_pageIndicator.pageCount = _xml.modulo.length();
				_pageIndicator.addEventListener( Event.CHANGE, pageIndicator_changeHandler );
				_pageIndicator.scaleX = _counterSize;
				_pageIndicator.scaleY = _counterSize;
				
				addChild(_pageIndicator);
				_pageIndicator.validate();
				_pageIndicator.x = DO.width/2 - _pageIndicator.width/2;
				
				// SETA WIDTH DO TAMANHO DA IMAGEM
				
				//panel.width = DO.width;
				//panel.pageWidth = DO.width;
				
				//textRenderer.x = 0;
				textRenderer.x = _w/2-textRenderer.width/2;
				//textRenderer.x = DO.width/2-textRenderer.width/2;
				
				if(DO.width < 1080){
					//this.x = 1080/2 - DO.width / 2;
					
					//trace('POSX: ' + (1080 - DO.width) / 2);
				}
				
				
				this.dispatchEventWith(propagaEvento.COMPLETED, false);
				//----------------------------------------------------------------------------- | PAGE INDICATOR
				
				//var pe:propagaEvento = new propagaEvento(propagaEvento.COMPLETED, {});
				//this.dispatchEvent(new propagaEvento(propagaEvento.DATABASE, {parsed:result, table:tableName}));
				//this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			}
			
			imgCont++;
			
			if(imgCont == images.length*2){
				panel.scrollToPageIndex(Math.floor(images.length/2),0)
				imgArr[panel.horizontalPageIndex].scaleX = 1
				imgArr[panel.horizontalPageIndex].scaleY = 1
				//this.dispatchEventWith(propagaEvento.COMPLETED,false);
				//panel.clipRect = new Rectangle(0, 0, DO.width, DO.height);
			}else{
				//images.splice(0,1);
				carregaImagem(images[1], imgCont );
				
			}
			
			
			
			//trace(imgCont);
		}
		
		private function clicado(evt:TouchEvent):void
		{

			if(evt.getTouch(evt.currentTarget as TextFieldTextRenderer, TouchPhase.ENDED)){
				evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);

				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:com.greensock.easing.Quad.easeOut});
				
				//trace('TROCA PAGINA');
				
				r = this.root as Main;
				r.trocaPagina(imgArr[panel.horizontalPageIndex] as MyImageLoader2);
				
				
			}

		}	
		
		private function clicadoIcon(evt:TouchEvent):void
		{
			
			if(evt.getTouch(evt.currentTarget as DisplayObject, TouchPhase.ENDED)){
				evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);
				
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:com.greensock.easing.Quad.easeOut});
				
				r = this.root as Main;
				r.trocaPagina(imgArr[panel.horizontalPageIndex] as MyImageLoader2);
				
			}
			
		}		

		private function foi(evt:Event):void
		{
			
			//trace('ok')
			
			_pageIndicator.selectedIndex = panel.horizontalPageIndex;
			
			try{
				textRenderer.text = _xml.modulo[panel.horizontalPageIndex].@texto;
				textRenderer.validate();
				textRenderer.x = 0;
				textRenderer.x = Starling.current.stage.width/2-textRenderer.width/2;
				//textRenderer.filter = BlurFilter.createDropShadow(1, 0.785, 0x000000, 0.9, 0.1, 0.5);
				
				icon.x = Starling.current.stage.width/2-textRenderer.width/2 - Number(_module.@textSize) * 2;

			}catch(err){};
			
		}
		
		private function pageIndicator_changeHandler():void
		{
			panel.scrollToPageIndex(_pageIndicator.selectedIndex, 0, panel.pageThrowDuration);
			try{
				textRenderer.text = _xml.modulo[_pageIndicator.selectedIndex].@texto;
			}catch(err){};
			
			//panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			try{
				for(var i:Number=0; i<images.length; i++ ){
					TweenLite.to(imgArr[i], 1, {scaleX:.6, scaleY:.6, alpha:0, ease:com.greensock.easing.Quad.easeOut});
					TweenLite.to(imgArr2[i], 1, {scaleX:.6, scaleY:.6, alpha:1, ease:com.greensock.easing.Quad.easeOut});
				}
				
				
				TweenLite.to(imgArr[panel.horizontalPageIndex], 1, {scaleX:1, scaleY:1, alpha:1, ease:com.greensock.easing.Quad.easeOut});
				TweenLite.to(imgArr2[panel.horizontalPageIndex], 1, {scaleX:1, scaleY:1, alpha:0, ease:com.greensock.easing.Quad.easeOut});
			}catch(err){};
		}
		
		private function button_triggeredHandler(evt:starling.events.Event):void
		{
			var ok:Object = evt.target;
			var page:Number = ok.name.substr(ok.name.indexOf('!')+1,ok.name.lastIndexOf('!')-ok.name.indexOf('!')-1);
			//r.pages[0] = page;
			//r.goBrowse('List');
			//trace("Btn: " + page );
		}
		
		
		
		
		override public function dispose():void{
			try{
				for(var i:Number=0; i<imgArr.length; i++){
					imgArr[i].dispose();
					imgArr2[i].dispose();
					removeChild(imgArr[i]);
					removeChild(imgArr2[i]);
				}
			}catch(err){};
			
			try{
				icon.removeEventListener(TouchEvent.TOUCH, clicadoIcon);
				icon.dispose();
				removeChild(icon);
			}catch(err){};
			
			
			imgArr = [];
			imgArr = null;
			
			if(_xml.@autoPlay == 'true'){
				timer.stop();
			}
			
			_pageIndicator.dispose();
			removeChild(_pageIndicator);
			/*if(img_Clima){	
			img_Clima.dispose();
			}*/
			
			//trace('disposed!!!');
		}
	}
}