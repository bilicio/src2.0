package classes.antidoto.componentes
{

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.Label;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ModuloGaleria extends Sprite
	{
		private var _bgColor:uint;
		
		private var img:Image;
		private var dpi:Number;
		
		private var panel:ScrollContainer;
		private var _pageIndicator:PageIndicator;
		private var layout:HorizontalLayout;
		
		private var imgArr:Array = new Array();
		
		private var retangulo:Shape;
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
		
		private var setaDirIL:MyImageLoader2;
		private var setaEsqIL:MyImageLoader2;
		
		private var timer:Timer;
		private var inverse:Boolean = false;
		
		private var totalW:Number;
		private var totalH:Number;
		private var quad:Shape;
		private var allCompleted:Boolean = false;
		private var popupColor:uint = 0x000000;
		private var myImg:MyImageLoader2;
		private var xis:MyImageLoader2;
		
		//private var zipFile:ZipFile;
		
		public function ModuloGaleria(props:Object)
		{
			/*dpi = DeviceCapabilities.dpi / 326
			this.x = 10;
			this.y = y;
			_h = h * dpi;*/
			_props = props;
			
			_xml = globalVars.xml.menu[props.idM].modulo[props.idI].item;
			
			_bgColor = globalVars.xml.@color;
			_pageIndicatorY = globalVars.xml.menu[props.idM].modulo[props.idI].@counterY;
			_counterSize = globalVars.xml.menu[props.idM].modulo[props.idI].@counterSize;

			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			

		}
		
		protected function trocaFoto(event:TimerEvent):void
		{
			if(panel.horizontalPageIndex < _pageIndicator.pageCount-1 && !inverse){
				nextPhoto();
			}else{
				//inverse = true;
				panel.scrollToPageIndex(0,0);
				imgArr[0].visible = true;
			}
			
			
			if(panel.horizontalPageIndex > 0 && inverse){
				prevPhoto()
			}else if(panel.horizontalPageIndex == 0 && inverse){
				inverse = false;
				imgArr[panel.horizontalPageIndex+1].visible = true;
				panel.scrollToPageIndex(panel.horizontalPageIndex+1,0);
			}
		}
		
		protected function nextPhoto():void{
			
			if(panel.horizontalPageIndex < _pageIndicator.pageCount-1 && !panel.isScrolling){
				try{
					imgArr[panel.horizontalPageIndex+1].visible = true;
				}catch(err){};
				panel.scrollToPageIndex(panel.horizontalPageIndex+1,0);
			}
		}
		
		protected function prevPhoto():void{
			if(panel.horizontalPageIndex > 0 && !panel.isScrolling){
				imgArr[panel.horizontalPageIndex-1].visible = true;
				panel.scrollToPageIndex(panel.horizontalPageIndex-1,0);
			}
		}
		
		private function criaComponente(evt:Event):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, teclaApertada);
			
			panel = new ScrollContainer();
			//panel.headerProperties.title = "Equipamentos";
			//panel.width = 1080
			//panel.height = 694;
			
			panel.snapToPages = true;
			panel.autoHideBackground = true;
			panel.addEventListener(Event.SCROLL, foi);
			panel.addEventListener(FeathersEventType.SCROLL_COMPLETE, transitionComplete);
			panel.addEventListener(FeathersEventType.BEGIN_INTERACTION, apertou);
		//	panel.addEventListener(FeathersEventType.END_INTERACTION, soltou);
			
			panel.clipContent = true;
			
			//panel.pageWidth = 1080;
			
			layout = new HorizontalLayout();
			//layout.gap = 0;
			//layout.padding = 70;
			//layout.paddingLeft = 0;
			//layout.paddingRight = 0;
			//layout.paddingBottom = 300;
			
			panel.layout = layout;
			
			panel.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			panel.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			this.addChild( panel );
			
			//panel.footerFactory = function():PageIndicator
			//{
			
			
			_pageIndicator = new PageIndicator();
			
			
			
			
			//}
			
			if(_xml.modulo.length()==1){
				//_pageIndicator.alpha = 0;
				panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			}
			
			
			panel.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			//panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			//scrollBar.scrollBarDisplayMode = "SCROLL_BAR_DISPLAY_MODE_NONE";
			
			for(var i:Number=0; i<_xml.modulo.length(); i++){
				
				
				images.push(i);
				
				/*ldr = new MyImageLoader(_xml.img[i]);
				ldr.addEventListener(propagaEvento.IMAGELOADED, criaRetangulos);
				imgArr.push(ldr);*/
			}
			
			//trace('IMAGES: ' + _xml.modulo.length() + " - " + images[0]);
			
			carregaImagem(images[0], 0);
			//carregaImagem(_xml.img[1]);
			//this.dispatchEventWith(propagaEvento.COMPLETED,false);
			
			/*nlabel = new Label();
			nlabel.nameList.add('label-data');
			nlabel.x = 50;
			nlabel.y = 50;
			nlabel.text = 'Carregando imagens...';
			
			addChild(nlabel);*/
			
			imgCont = 0;
		}
		
		private function teclaApertada(evt:KeyboardEvent):void
		{
			//trace('TARGET: ' + evt.keyCode);
			
			if(evt.keyCode == 37){
				prevPhoto();
			}
			
			if(evt.keyCode == 39){
				nextPhoto();
			}
			
		}
		
		private function apertou(evt:Event):void
		{
			for(var i:Number = imgArr.length; i--;){
				imgArr[i].visible = true;
			}
			
		}		
		
		
		private function carregaImagem(img, pos):void{
			//	if(images.length>0){
			//var image:BitmapData = _props.zipFile.getBitmapData("provig_btn_3.png");
			//trace("Size: " + image.width + "x" + image.height);
			trace('IMG: ' + img);
			
			ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:img, max:false});
			ldr.addEventListener(TouchEvent.TOUCH, clicado);
			//ldr.x = 1080 * pos;
			ldr.addEventListener(propagaEvento.IMAGELOADED, criaRetangulos);
			imgArr[pos] = ldr;
			//}
			
			//trace('IMAGE OK');
		}
		
		private var moveDedo:Number = 0;
		
		private function clicado(evt:TouchEvent):void
		{

			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.BEGAN)){
				moveDedo = evt.getTouch(evt.currentTarget as MyImageLoader2).globalX;
				//trace('BEGAN ' + moveDedo);
			}
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED) && globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].hasOwnProperty("@img2") == true){
				if(evt.getTouch(evt.currentTarget as MyImageLoader2).globalX == moveDedo){
					//trace('SINGLE CLICKED ' + globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].hasOwnProperty("@img2"));
					
					openNewImage(evt.currentTarget);
				}else{
					//trace('NO CLICK');
				}
				
				
				
				
			}
		}
		
		private function openNewImage(target):void{
			if(!TweenMax.isTweening(quad)){
				
				parent.setChildIndex(this, parent.numChildren-1);
				
				
				
				quad = new Shape();
				quad.graphics.beginFill(popupColor, .95);
				quad.graphics.drawRect(0, 0, 1, 1080);
				quad.graphics.endFill();
				
				quad.x = -Number(_xml.parent().@x);
				quad.y = -Number(_xml.parent().@y);
				
				addChild(quad);
				
				trace('Tweening: ' + TweenMax.isTweening(quad) + " y: " + _xml.parent().@y);
				
				//	trace('POSICAO: ' + (evt.currentTarget as MyImageLoader).imagePos);
				
				totalW = Starling.current.stage.width;
				totalH = Starling.current.stage.height;
				
				TweenMax.to(quad, .5, {width:totalW, onComplete:function():void{ TweenLite.to(quad, .5, {height:totalH});}});
				
				abreImagem(target as MyImageLoader2)
				
				//this.dispatchEventWith(FINISHED, false, '');
			}
		}
		
		private function abreImagem(item):void{
			
			trace('get: ' + item + " vars: " + item._props.idM + " - " + item._props.idI + " - " + item._props.idT + " - " + item._props.idW);
			
			//img = new MyImageLoader2({idM:item._props.idM, idI:item._props.idI, idT:item._props.idT, idW:item._props.idW,  max:true});
			myImg = new MyImageLoader2({idM:item._props.idM, idI:item._props.idI, idT:item._props.idT, idW:0,  max:true});
			
			myImg.addEventListener(propagaEvento.IMAGELOADED, imagePopupCreated);

			myImg.alpha = 0;

			//myImg.addEventListener(TouchEvent.TOUCH, fechaPopup);
			addChild(myImg);
			
		}
		
		private function imagePopupCreated(evt:Event):void
		{
			myImg.removeEventListener(propagaEvento.IMAGELOADED, imagePopupCreated);
			// TODO Auto Generated method stub
			myImg.x = totalW/4 - (evt.currentTarget as MyImageLoader2).width /2 -Number(_xml.parent().parent().@x);
			myImg.y = totalH/4 - (evt.currentTarget as MyImageLoader2).height /2 -Number(_xml.parent().parent().@y);
			
			TweenLite.to(myImg, .5, {alpha:1, delay:1, onComplete:function():void{xis.addEventListener(TouchEvent.TOUCH, fechaPopup);}});
			
			xis = new MyImageLoader2({idM:0, idI:0 });
			//xis.x = -Number(_xml.parent().parent().@x) + totalW - xis.width*2 - 200;
			//xis.y = -Number(_xml.parent().parent().@y) + xis.height*2 + 200;
			xis.x = myImg.x + myImg._width + xis.width;
			xis.y = myImg.y - xis.height ;
			
			xis.pivotX = 28;
			xis.pivotY = 28;
			
			
			addChild(xis);
			
		}
		
		private function fechaPopup(evt:TouchEvent = null):void
		{
			//trace('XIS');
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);
				(evt.currentTarget as MyImageLoader2).removeEventListener(TouchEvent.TOUCH, fechaPopup);
				//xis.removeEventListener(TouchEvent.TOUCH, fechaPopup);
				
				TweenLite.to(myImg, .5, {alpha:0});
				TweenMax.to(quad, .5, {height:1, onComplete:function():void{ TweenLite.to(quad, .5, {width:0});}});
				
				xis.dispose();
				removeChild(xis);
				
				TweenMax.delayedCall(1, function():void{myImg.dispose();removeChild(myImg);removeChild(quad);});
				/*img.dispose();
				removeChild(img);
				removeChild(quad);*/
			}
			
		}
		
		private function criaRetangulos(evt:Event):void{
			
			//trace('IMAGEM');
			
			evt.target.removeEventListener(propagaEvento.IMAGELOADED, criaRetangulos);
			panel.addChild(evt.target as MyImageLoader2);
			
			trace('IMAGEARR: ' + imgArr);
			
			if(imgCont == 0){

				label = new Label();
				
				label.text = _xml.modulo[0].@texto;
				
				addChild(label);
				
				label.validate();

				var DO:MyImageLoader2 = evt.currentTarget as MyImageLoader2;

				if(_xml.@moldura == 'true'){
					retangulo = new Shape;
					retangulo.graphics.beginFill(_bgColor);
					retangulo.graphics.drawRect(0,0, DO.width, molduraHeight);
					retangulo.y = 0;
					addChild(retangulo);
					
					retangulo = new Shape;
					retangulo.graphics.beginFill(_bgColor);
					retangulo.graphics.drawRect(0, 0, DO.width, molduraHeight);
					retangulo.y = DO.y+DO.height+molduraHeight;
					addChild(retangulo);
					
					panel.y = molduraHeight;

					label.y = DO.y+DO.height - molduraHeight/2;
					_pageIndicator.y = DO.y+DO.height+2 +molduraHeight;
					
				}else{
					label.y = DO.y+DO.height -30;
				}
				
				if(_pageIndicatorY == 0){
					_pageIndicator.y = DO.y+DO.height+2 ;
				}else{
					_pageIndicator.y = 50;
					
					//trace(_pageIndicatorY)
					//label.y = _pageIndicatorY-35;
					
					try{
						retangulo.y = _pageIndicatorY;
					}catch(err){};
					
					label.y = DO.y+DO.height - molduraHeight/2;
				}
				
				if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
				
					setaEsqIL = new MyImageLoader2({idM:0, idI:7 });
					setaEsqIL.addEventListener( TouchEvent.TOUCH, goBackw );
					
					setaEsqIL.alpha = 0;
					setaEsqIL.y = DO.height/2 - 50;
					addChild( setaEsqIL );
					
					setaDirIL = new MyImageLoader2({idM:0, idI:8 });
					setaDirIL.addEventListener(  TouchEvent.TOUCH, goForw  );
					
					setaDirIL.alpha = 0;
					setaDirIL.y = DO.height/2 - 50;
					setaDirIL.x = DO.width - 30;
					addChild( setaDirIL );
					
					if(panel.horizontalPageIndex == 0 && images.length>1){
						setaDirIL.alpha = 1;
					}
				}
				
				//setaDirIL.source = Texture.fromBitmap( new setaEsq() as Bitmap );
				//setaDirIL.addEventListener( Event.COMPLETE, trace );
				
				//setaDirIL.y = _pageIndicator.y/2 - 50;
				//setaDirIL.x = DO.width;
				
				//setaDirIL.alpha = .5;
				
				//setaDirIL.scaleX = -1;
				//addChild( setaDirIL );
				
				setChildIndex(label, numChildren-1);
				
				trace("COUNT: " + _xml.modulo.length());
				_pageIndicator.pageCount = _xml.modulo.length();
				_pageIndicator.addEventListener( Event.CHANGE, pageIndicator_changeHandler );
				_pageIndicator.scaleX = _counterSize;
				_pageIndicator.scaleY = _counterSize;
				
				addChild(_pageIndicator);
				_pageIndicator.validate();
				_pageIndicator.x = DO.width/2 - _pageIndicator.width/2;
				
				trace("PAGEIND: " + globalVars.xml.menu[_props.idM].modulo[_props.idI].@pageY);
				
				_pageIndicator.y = globalVars.xml.menu[_props.idM].modulo[_props.idI].@pageY;
				//var pages:PageIndicator = new PageIndicator();
				//pages.pageCount = 5;
				//this.addChild( pages );
				
				panel.width = DO.width;
				panel.pageWidth = DO.width;
				
				//label.x = 0;
				label.x = DO.width-label.width - 10;
				//label.x = DO.width/2-label.width/2;
				
				if(DO.width < 1080){
					//this.x = 1080/2 - DO.width / 2;
					
					//trace('POSX: ' + (1080 - DO.width) / 2);
				}
				
				
				this.dispatchEventWith(propagaEvento.COMPLETED,false);
				//----------------------------------------------------------------------------- | PAGE INDICATOR
				
				//var pe:propagaEvento = new propagaEvento(propagaEvento.COMPLETED, {});
				//this.dispatchEvent(new propagaEvento(propagaEvento.DATABASE, {parsed:result, table:tableName}));
				//this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			}
			
			imgCont++;
			
			
			
			if(imgCont > 1){
				
				//this.dispatchEventWith(propagaEvento.COMPLETED,false);
				//panel.clipRect = new Rectangle(0, 0, DO.width, DO.height);
			}else{
				//images.splice(0,1);
				trace('passou: ' + imgCont);
				carregaImagem(images[1], 1 );
				
				for(var i:Number = imgArr.length; i--;){
					imgArr[i].visible = false;
				}
				imgArr[panel.horizontalPageIndex].visible = true;
				
				if(_xml.@autoPlay == 'true'){
					timer = new Timer(Number(_xml.@autoPlayTime*1000), 0);
					timer.addEventListener(TimerEvent.TIMER, trocaFoto);
					timer.start();
				}
				
			}
			
			
			
			//trace(imgCont);
		}
		
		private function goForw(evt:TouchEvent):void{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});
				nextPhoto();
			}
		}
		
		private function goBackw(evt:TouchEvent):void{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});
				prevPhoto();
			}
		}
			
		
		private function transitionComplete(evt:Event):void
		{
			//trace('INDEX: ' + panel.horizontalPageIndex);
			
			//trace('x: ' + this.x);
			
			if(_xml.@autoPlay == 'true'){
				timer.reset();
				timer.start();
			}
			
			
			panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			
			
		//	var imgTemp:MyImageLoader;
			
			if(panel.horizontalPageIndex != oldPos){
				//trace('passou');
				
				if(oldPos == 0 && images.length>2){
					if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
					setaDirIL.alpha = 1;
					}
					//trace('OK');
					
					if(oldPos<panel.horizontalPageIndex){
						//trace('carregou');
						if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
						setaEsqIL.alpha = 1;
						}

						if(imgArr[panel.horizontalPageIndex+1] == undefined){
							carregaImagem(images[panel.horizontalPageIndex+1], panel.horizontalPageIndex+1);
						}else{
							imgArr[panel.horizontalPageIndex+1].visible = true;
						}
						
						//carregaImagem(images[panel.horizontalPageIndex+1], panel.horizontalPageIndex+1);
						//	imgTemp = imgArr[panel.horizontalPageIndex+1];
						//trace(imgTemp);
					}
					
					
					
				}else if(oldPos != 0){
					
					if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
					setaDirIL.alpha = 1;
					}
					//trace(oldPos + " | " +panel.horizontalPageIndex);
					if(oldPos<panel.horizontalPageIndex && images.length != panel.horizontalPageIndex+1){
						//trace('aumentou ');
						//trace('imagem a ser criada: ' + imgArr[panel.horizontalPageIndex+1] + ' imgArr-Lenght: ' + imgArr.length + ' pageIndex: ' +  panel.horizontalPageIndex);
						if(imgArr[panel.horizontalPageIndex+1] == undefined){
							
							carregaImagem(images[panel.horizontalPageIndex+1], panel.horizontalPageIndex+1);
							//trace('passou');
						}else{
							imgArr[panel.horizontalPageIndex+1].visible = true;
						}
						
						//imgArr[panel.horizontalPageIndex-2].dispose()
						imgArr[panel.horizontalPageIndex-2].visible = false;
						
						//imgArr[panel.horizontalPageIndex-2] = '-';
					}else{
						
						try{
							imgArr[panel.horizontalPageIndex+2].visible = false;
						}catch(err){};
						
						try{
							imgArr[panel.horizontalPageIndex-1].visible = true;
						}catch(err){};
						
						
						/*panel.removeChild(imgArr[panel.horizontalPageIndex-1]);
						imgArr[panel.horizontalPageIndex-1].dispose()
						
						carregaImagem(images[panel.horizontalPageIndex-1], panel.horizontalPageIndex-1);
						
						imgArr[panel.horizontalPageIndex+2].dispose()
						panel.removeChild(imgArr[panel.horizontalPageIndex+2]);*/
						
						
						
						//imgArr[panel.horizontalPageIndex+2] = '-';
						//imgTemp = imgArr[panel.horizontalPageIndex-1].dispose();
					}
				}
				
				//	panel.addChild(imgTemp as MyImageLoader);
				
				if(panel.horizontalPageIndex == 0){
					if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
					setaEsqIL.alpha = 0;
					}
				}
				
				if(panel.horizontalPageIndex == images.length-1){
					if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
					setaDirIL.alpha = 0;
					}
				}
				
				if(panel.horizontalPageIndex > 0){
					if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
					setaEsqIL.alpha = 1;
					}
				}
				
				
				
				oldPos = panel.horizontalPageIndex != oldPos?panel.horizontalPageIndex : oldPos;
				
				
				for(var i:Number = imgArr.length; i--;){
					imgArr[i].visible = false;
				}
				imgArr[panel.horizontalPageIndex].visible = true;
			}
			
		}
		
		private function foi(evt:Event):void
		{
			
			
			_pageIndicator.selectedIndex = panel.horizontalPageIndex;

			/*try{
				label.text = _xml.modulo[panel.horizontalPageIndex].@texto;
				label.validate();
				label.x = 0;
				label.x = this.width-label.width - 10;
				label.filter = BlurFilter.createDropShadow(1, 0.785, 0x000000, 0.9, 0.1, 0.5);
				//label.x = this.width/2-label.width/2;
			}catch(err){};*/
	
		}
		
		private function pageIndicator_changeHandler():void
		{
			panel.scrollToPageIndex(_pageIndicator.selectedIndex, 0, panel.pageThrowDuration);
			try{
				label.text = _xml.modulo[_pageIndicator.selectedIndex].@texto;
			}catch(err){};
			
			panel.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
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
					removeChild(imgArr[i]);
				}
			}catch(err:Error){};
			
			this.removeEventListener(KeyboardEvent.KEY_DOWN, teclaApertada);
			
			imgArr = [];
			imgArr = null;
			
			if(_xml.@autoPlay == 'true'){
				timer.stop();
			}
			
			try{
				xis.removeEventListener(TouchEvent.TOUCH, fechaPopup);
				xis.dispose();
				removeChild(xis);
				
				myImg.dispose();
				removeChild(myImg);
				
				removeChild(quad);
			}catch(err){};
			
			if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@useArrow == "true"){
				
				setaEsqIL.dispose();
				setaEsqIL.removeEventListener( TouchEvent.TOUCH, goBackw );
				removeChild(setaEsqIL);
				
				setaDirIL.dispose();
				setaDirIL.removeEventListener(  TouchEvent.TOUCH, goForw  );
				removeChild(setaDirIL);

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