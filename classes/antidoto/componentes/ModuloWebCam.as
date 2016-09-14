package classes.antidoto.componentes
{

	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import classes.antidoto.Arduino;
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	import classes.camera.StarlingCamera;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.text.TextFieldTextRenderer;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	
	public class ModuloWebCam extends Sprite
	{

	//	private var img:MyImageLoader;

		private var _xml:XMLList;
		
		private var _h:Number;

		private var _w:Number;

		private var container:ScrollContainer;

		private var _props:Object;

			
		private var item:String;
		
		private var ldr:MyImageLoader2;
		
		private var imgArr:Array = new Array();
		public var fieldsArr:Array = new Array();

		private var r:Number = 0;
		
		private var posX:Number = 450;
		private var posY:Number = 0;
		
		private var camera:classes.camera.StarlingCamera;
		
		private var textRenderer:TextFieldTextRenderer;
		private var _fontSize:Number = 200;
		
		private var textFormat:TextFormat;
		
		private var acc:Number = 3;
		
		private var canvas:Canvas;
		
		private var canvasBlurredTexture:Texture;
		private var canvasBlurred:Image;
		
		private var result:BitmapData;
		
		private var myClonedBitmap:BitmapData;
		
		private var lockFlash:Boolean = false;
		
		private var myParentSquareBitmap:BitmapData;

		private var arduino:Arduino;
		
		public function ModuloWebCam(props:Object)
		{
			trace('modulo comeca');
			for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
			{
				trace ("itemCount " + itemData.localName()); 
				item = itemData.localName();
			}

			_props = props;
			
			if(item == 'item'){
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo;
			}
				
			_h = _xml[0].@height;
			_w = _xml[0].@width;
			
			try{
				
				myClonedBitmap.dispose();
				
				trace('CLONE DISPOSED');
				
			}catch(err){};
	
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			//this.height = _h;
		}
		
		private function criaComponente(evt:Event):void
		{
			
			if(globalVars.xml.@flash == 'true'){
				//trace('TEM FLASH');
				arduino = new Arduino();
			}
			
			textFormat = new TextFormat( "Gotham", _fontSize, 0XFFFFFF);
			
			textRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = textFormat;
			textRenderer.embedFonts = true;
			textRenderer.wordWrap = true;
			textRenderer.isHTML = true;
			
			textRenderer.x = posX + Number(_xml.parent().parent().@width) / 2 - 60;
			textRenderer.y = posY + Number(_xml.parent().parent().@height) / 2 - 120;
			
			textRenderer.text = '';
			
			
			
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			
			
			if(!globalVars.camera){
				camera = new StarlingCamera();
				
				//Initialize. Pass in:
				//1. a rect to define the camera "viewport"
				//2. a capture rate (fps, default 24)
				//3. a downsample value (.5 means half-height, half-width, default 1)
				//4. true if you want to rotate the camera (default false)
				camera.x = posX+6;
				camera.y = posY+20;
				camera.init(new Rectangle(0, 0, Number(_xml.parent().parent().@width), Number(_xml.parent().parent().@height)), 24, 1, false);
				//Each time you call reflect() you toggle mirroring on/off
				camera.reflect();
				//Put it onstage
				addChild(camera);
				//Select a webcam
				camera.selectCamera(0);
				
				camera.alpha = 0;
				
				globalVars.camera = camera;
			}else{
				trace('TEM A CAMERA');
				
				camera = globalVars.camera;
				
				camera.alpha = 0;
				
				addChild(camera);
			}
			
		/*	try{
				canvas.clear();
			}catch(err){}
			
			canvas = new Canvas()
			canvas.beginFill(0xff0000);
			canvas.drawCircle( Number(_xml.parent().parent().@width)/2, posY + Number(_xml.parent().parent().@height)/2, Number(_xml.parent().parent().@width)/2);
			canvas.endFill();*/
				
			//addChild(canvas);
				
			//camera.mask = canvas;				
			
			ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, max:false});
			ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			imgArr.push(ldr);
			
			ldr.x = posX-29;
			ldr.y = posY;
			
			//ldr.x = posX;
			//ldr.y = posY;
			
			ldr.touchable = false;
			
			TweenMax.to(camera, 1, {alpha:1, delay:1.5});
			
			//TweenMax.delayedCall(1.5, function():void{camera.alpha = 1});
			
			addChild(ldr);
			
			addChild(textRenderer);

			
			criaBtns();
			
			this.dispatchEventWith(propagaEvento.COMPLETED, false);
			
		}
		
		private function criaBtns():void
		{
			
			ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:0, max:true});
			ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
				
			imgArr.push(ldr);
			
			ldr.x = _xml[0].@x;
			ldr.y = _xml[0].@y;
			
			ldr.addEventListener(TouchEvent.TOUCH, tiraFoto);

			addChild(ldr);

			ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:1, max:true});
			ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			
			imgArr.push(ldr);
			
			ldr.alpha = 0;

			ldr.x = _xml[1].@x;
			ldr.y = _xml[1].@y;
			
			//ldr.addEventListener(TouchEvent.TOUCH, refazFoto);
			
			addChild(ldr);

		}
		
		private function refazFoto(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});
				canvasBlurredTexture.dispose();
				canvasBlurred.dispose();
				
				removeChild(canvasBlurred);
				
				contador();
				
				imgArr[2].removeEventListener(TouchEvent.TOUCH, refazFoto);
			}
			
		}
		
		private function tiraFoto(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				TweenMax.to(evt.currentTarget, .1, {scaleX:.9, scaleY:.9, yoyo:true, repeat:1, ease:Quad.easeOut});
				imgArr[1].removeEventListener(TouchEvent.TOUCH, tiraFoto);
				contador()
			}
			
		}
		
		private function contador():void
		{
			lockFlash = true;
			
			try{
				arduino.sendData("H");
			}catch(err){};
			
			
			if(acc >= 1){
				TweenMax.delayedCall(1, contador)
				textRenderer.text = acc.toString();
				acc--
			}else{
				try{
					imgArr[2].addEventListener(TouchEvent.TOUCH, refazFoto);
					
					imgArr[2].alpha = 1;
					
					acc = 3;
					textRenderer.text = '';
					snapshot();
				}catch(err){}
			}
			
		}

		
		private function snapshot():void{
			lockFlash = false;
			myParentSquareBitmap = copyAsBitmapData(camera);
			myClonedBitmap = myParentSquareBitmap.clone(); 
			canvasBlurredTexture = Texture.fromBitmapData(myParentSquareBitmap, false);
			canvasBlurred = new Image(canvasBlurredTexture);  

			canvasBlurred.x = posX;
			canvasBlurred.y = posY+20;
			
			canvas = new Canvas()
			canvas.beginFill(0xff0000);
			canvas.drawCircle(posX/2 + 75, posY + Number(_xml.parent().parent().@width)/2, Number(_xml.parent().parent().@width)/2);
			canvas.endFill();
			
			canvasBlurred.mask = canvas;
			
			//TweenMax.delayedCall(3, function():void{canvas.clear();})
			
			//TweenMax.delayedCall(6, addClone)
			
			addChild(canvasBlurred);
			
			try{
				arduino.sendData("O");
			}catch(err){};
		}
		
		private function addClone():void{

			canvasBlurredTexture = Texture.fromBitmapData(myClonedBitmap, false);
			canvasBlurred = new Image(canvasBlurredTexture);  
			
			canvasBlurred.x = posX;
			canvasBlurred.y = posY+10;
			
			addChild(canvasBlurred);
		}
		
		/*public static function snapshot(scl:Number=1.0):BitmapData // Screenshot da tela
		{
			var stage:Stage = Starling.current.stage;
			var viewport:Rectangle = Starling.current.viewPort;                                          
			
			var rs:RenderSupport = new RenderSupport();                                                  
			
			rs.clear();
			rs.scaleMatrix(scl, scl);
			rs.setProjectionMatrix(0, 0, viewport.width, viewport.height);                         
			
			stage.render(rs, 1.0);
			rs.finishQuadBatch();                                                                        
			
			var outBmp:BitmapData = new BitmapData(viewport.width * scl, viewport.height * scl, true);
			Starling.context.drawToBitmapData(outBmp);                                                   
			
			return outBmp;
		}*/
		
		public function copyAsBitmapData(displayObject:starling.display.DisplayObject, transparentBackground:Boolean = true, backgroundColor:uint = 0xcccccc):BitmapData
		{
			if (displayObject == null || isNaN(displayObject.width)|| isNaN(displayObject.height))
				return null;
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			
			result = new BitmapData(displayObject.width, displayObject.height, transparentBackground, backgroundColor);
			var context:Context3D = Starling.context;
		//	var support:RenderSupport = new RenderSupport();
			//RenderSupport.clear();
			//support.setProjectionMatrix(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			//support.applyBlendMode(true);
			//support.translateMatrix( -resultRect.x, -resultRect.y);
			//support.pushMatrix();
			//support.blendMode = displayObject.blendMode;
			//displayObject.render(support, 1.0);
			//support.popMatrix();
			//support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}
		
		private function imagemCarregada(evt:starling.events.Event):void
		{
			//trace('img OK')
			evt.currentTarget.removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			
		}
		
		
		public function saveVariables():Boolean{
			if(myClonedBitmap == null || lockFlash){
				//trace('BITMAP: ' + myClonedBitmap)
				return false
			}
			
			globalVars.cadastro2[_xml.parent().parent().@vr] = myClonedBitmap;
			
			return true;
		}
		
	
		
		
		override public function dispose():void{
			
			trace('WEBCAM DISPOSED');
			
			try{
				arduino.dispose();
			}catch(err){err};
			
			try{
				result.dispose();
			}catch(err){};
			
			try{
				canvasBlurredTexture.dispose();
			}catch(err){};
			
			try{
				canvasBlurred.dispose();
			}catch(err){};
			
			try{
				myParentSquareBitmap.dispose();
			}catch(err){};
			try{
				removeChild(canvasBlurred);
				canvasBlurred = null;
			}catch(err){};	
			
			//canvas.clear();
			
			textRenderer.dispose();
			
			
			imgArr[0].dispose();
			imgArr[1].dispose();
			
			imgArr[2].removeEventListener(TouchEvent.TOUCH, refazFoto);
			imgArr[2].dispose();
			
			//camera.mask.dispose();
			
			//camera.dispose();
			removeChild(camera);

			imgArr = [];
			imgArr = null;
			
			/*if(img_Clima){	
			img_Clima.dispose();
			}*/
			
			//trace('disposed!!!');
		}
	}
}