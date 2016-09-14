package classes.antidoto{
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	
	import flash.utils.getDefinitionByName;
	import com.greensock.loading.ImageLoader;
	import com.greensock.events.LoaderEvent;
	import classes.antidoto.propagaEvento;
	import flash.geom.Matrix;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.core.TouchMovieClip;
	import com.gestureworks.core.TouchSpriteBase;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class slideShow extends Sprite {
		
		private var SpriteImage:TouchSprite = new TouchSprite();;
		
		private var resultadoX:Number;
		private var resultadoY:Number;
		private var mousex:Number;
		private var mousey:Number;
		
		private var slideX:Number;
		private var slideXfinal:Number;
		
		private var tween:TweenMax;
		
		private var tootoo:Boolean = false;
		
		private var amask:BlitMask;
		
		private var _largura:Number;
		private var _altura:Number;
		private var _xml:String;
		private var _qnt:Number;
		private var _tamanhoBolinha:Number;
		
		private var loader:ImageLoader;
		
		private var posSlideAntiga:Number = -1;
		private var posSlide:Number = 0;
		
		private var fotosLibrary:Array = new Array();
		private var fotosIndexadas:Array = new Array();
		
		private var totalLoaded:Number = 0;
		
		private var ctn_bolinhas:Sprite;
		
		private var xmlNode:XML;
		private var xmlLoader:URLLoader;
				
		public function slideShow(largura:Number,altura:Number,tamanhoBolinha:Number,xml) {
			
			_largura = largura;
			_altura = altura;
			_xml = xml;
			_tamanhoBolinha = tamanhoBolinha;

			fotosLibrary = [];
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
		}
		
		private function addedToStage(evt:Event):void{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			parseXML()
			//for(var i:Number=0;i<_qnt;i++){
//				
//				var imagem = "imgs/"+_images.conteudo[i];
//				var foto:MovieClip = new MovieClip();
//				//var mnPG = "imgs/btn_673.png";
//					loader = new ImageLoader(imagem,{container:foto, width:_largura, height:_altura, vAlign:"top", scaleMode:"none"});
//					loader.load();
//					foto.name = "foto_"+i;
//					//loader.addEventListener(LoaderEvent.COMPLETE, loaderComplete);
//					fotosLibrary.push([foto,_largura * i]);
//				
//				//if(_qnt-1 == i){
//					loader.addEventListener(LoaderEvent.COMPLETE, loaderComplete);
//				//}
//			}
		}
		
		private function parseXML(){
			var onLoadXML = function(e:Event):void {
				xmlLoader.removeEventListener(Event.COMPLETE, onLoadXML);
				xmlNode = new XML(e.target.data);
				_qnt = xmlNode.conteudo.length();
				charge();
			}
			
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onLoadXML);
			xmlLoader.load(new URLRequest(_xml));
			
			SpriteImage.graphics.beginFill(0x000000);
			SpriteImage.graphics.drawRect(0,0,_largura,_altura);
			SpriteImage.graphics.endFill();
		}
		
		private function charge(){
			if(totalLoaded != _qnt){
				
				var imagem = "imgs/"+xmlNode.conteudo[totalLoaded];

				var foto:Sprite = new Sprite();

					loader = new ImageLoader(imagem,{container:foto, width:_largura, height:_altura, vAlign:"top", scaleMode:"none", bgColor:0x000000});
					loader.addEventListener(LoaderEvent.COMPLETE, loaderComplete);
					foto.name = "foto_"+totalLoaded;
					fotosLibrary.push([foto,_largura * totalLoaded]);
					loader.load();

			}
		}
		
		private function loaderComplete(evt:LoaderEvent):void{
			
			loader.removeEventListener(LoaderEvent.COMPLETE, loaderComplete);
			
			var buffer:BitmapData = new BitmapData ( fotosLibrary[totalLoaded][0].width, fotosLibrary[totalLoaded][0].height);
				buffer.draw ( fotosLibrary[totalLoaded][0]);
				
			var bitmap:Bitmap = new Bitmap(buffer);
				fotosLibrary[totalLoaded][0] = bitmap;
				
			totalLoaded++

			if(totalLoaded != _qnt){
				charge();
			}else{
				criaSlideShow();
				_qnt == 1?undefined:criaBolinhas();
			}
		}
		
		private function criaSlideShow():void{
			
			SpriteImage.addEventListener(MouseEvent.MOUSE_DOWN, clique);
		
			//SpriteImage.addEventListener(GWGestureEvent.TAP, clique);
			//SpriteImage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipe);	

			if(SpriteImage.numChildren == 0 && _qnt != 1){
				for(var i:Number=0;i<2;i++){
					SpriteImage.addChild(fotosLibrary[i][0]);
					var image = SpriteImage.getChildByName(fotosLibrary[i][0].name)
						image.x = fotosLibrary[i][1];
						image.cacheAsBitmap = true;
						
				}
			}else{
				SpriteImage.addChild(fotosLibrary[0][0]);
				var image2 = SpriteImage.getChildByName(fotosLibrary[0][0].name)
					image2.x = fotosLibrary[0][1];
					image2.cacheAsBitmap = true;
			}
			
			
			addChild(SpriteImage);
			
			amask = new BlitMask(SpriteImage, 0, 0, _largura, _altura, true);
			amask.disableBitmapMode();
			//SpriteImage.cacheAsBitmap = true;
			
			this.dispatchEvent(new propagaEvento(propagaEvento.SLIDESH, {pronto:"OK"}));
			//criaMascara();
		}
		
		
		
		private function criaBolinhas():void{
			ctn_bolinhas = new Sprite();
			for(var i:Number = 0; i<_qnt;i++){
				var bola:Sprite = new Sprite();
					bola.graphics.lineStyle(.5,0xffffff);
					bola.graphics.beginFill(0x555555,1);
					bola.graphics.drawCircle(0,0,_tamanhoBolinha);
					bola.graphics.endFill();
					bola.x = ((bola.width+5)*i);
					bola.alpha = .5;
				ctn_bolinhas.addChild(bola);
					
			}
			ctn_bolinhas.getChildAt(0).alpha = 1;
			ctn_bolinhas.y = _altura - 53;
			ctn_bolinhas.x = _largura/2 - ctn_bolinhas.width/2;
			addChild(ctn_bolinhas);
		}
		
		private function alteraBolinha(n){
			for(var i:Number = 0;i<ctn_bolinhas.numChildren;i++){
				ctn_bolinhas.getChildAt(i).alpha = .5;
			}
			ctn_bolinhas.getChildAt(n).alpha = 1;
		}
		
		private function verificaImagens():void{

			var image;
			var posSlideAbs = Math.abs(posSlide);
			var posSlideAntigaAbs = Math.abs(posSlideAntiga);
			
			if(posSlideAbs<posSlideAntigaAbs){
				
				image = SpriteImage.getChildByName(String("foto_"+Number(posSlideAntigaAbs+1)))
				
				if(image != null){
					SpriteImage.removeChild(image);
				}
				
				if(posSlideAbs!= 0){
					SpriteImage.addChild(fotosLibrary[posSlideAbs-1][0]);
					image = SpriteImage.getChildByName(fotosLibrary[posSlideAbs-1][0].name)
					image.x = fotosLibrary[posSlideAbs-1][1];
					image.cacheAsBitmap = true;
				}
				
			}else{

				if(posSlideAntigaAbs !== 0){
						
					image = SpriteImage.getChildByName(String("foto_"+Number(posSlideAntigaAbs-1)))
					
					if(image !== null){
						SpriteImage.removeChild(image);
					}
				}
					
				if(posSlideAbs!==_qnt-1){
					SpriteImage.addChild(fotosLibrary[posSlideAbs+1][0]);
					image = SpriteImage.getChildByName(fotosLibrary[posSlideAbs+1][0].name)
					image.x = fotosLibrary[posSlideAbs+1][1];
					image.cacheAsBitmap = true;
				}
			}
		}
		
		//private function criaMascara():void{
			//amask = new BlitMask(SpriteImage, 0, 0, _largura, _altura, true);
//			amask.graphics.beginFill(000000);
//			amask.graphics.drawRect(0,0,_largura,_altura)
//			amask.graphics.endFill();
//addChild(amask);
//			amask.mouseEnabled = false;
//			amask.cacheAsBitmap = true;
//			SpriteImage.mask = amask;
			
			//this.dispatchEvent(new propagaEvento(propagaEvento.SLIDESHOW, {pronto:"OK"}));

		//}
		
		private function clique(e:Event):void
		{	
			mousex = mouseX;
			mousey = mouseX;
			
			slideX = SpriteImage.x;
			
			resultadoX = 0;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mousemove);	
			stage.addEventListener(MouseEvent.MOUSE_UP, solta);
			
			//trace('clique');
		}
		
		private function solta(e:Event):void
		{	
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mousemove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, solta);
			
			var calc:Number;
			
				if(Math.abs(resultadoX)>_largura/2){
					calculaPosicao();
					calc = posSlide*_largura;
					tween = TweenMax.to(SpriteImage, .5, {x:calc, ease:Quad.easeOut});
				}else if(Math.abs(resultadoX)<.2){
					abrePagina(Math.abs(posSlide))
					//trace(resultadoX);
				}else{
					tween = TweenMax.to(SpriteImage, .5, {x:posSlide*_largura, ease:Quad.easeOut});
				}
		}
		
		private function abrePagina(pg){

			var evt:propagaEvento = new propagaEvento(propagaEvento.PAGINA, {pagina:pg});
				this.dispatchEvent(evt);
							
		}
		
		private function mousemove(evt:Event):void{
			 
			resultadoX = mousex-mouseX;
			
			slideXfinal = slideX-resultadoX;
			tootoo = TweenMax.isTweening(SpriteImage);
			
			tween = TweenMax.to(SpriteImage, .5, {x:slideXfinal, ease:Quad.easeOut});

		}
		
		private function swipe(e:TransformGestureEvent){
			
			/*if(e.offsetX>0 && posSlide !== 0){
				posSlideAntiga = Math.abs(posSlide);
				posSlide++;
				verificaImagens();
				
			}else if(e.offsetX<_qnt && posSlide !== -(_qnt-1)){
				posSlideAntiga = Math.abs(posSlide);
				posSlide--;
				verificaImagens();
				
			}
			var calc:Number;
				calc = posSlide*_largura;
				tween = TweenMax.to(SpriteImage, .5, {x:calc, ease:Quad.easeOut});*/
		}
		
		private function calculaPosicao():void{
			
			if(resultadoX>0 && posSlide != -(_qnt-1)){
				posSlideAntiga = Math.abs(posSlide);
				posSlide--;
				verificaImagens();
			}else if(resultadoX<_qnt && posSlide != 0){
				posSlideAntiga = Math.abs(posSlide);
				posSlide++;
				verificaImagens();
			}
			fotosLibrary.length>1?alteraBolinha(Math.abs(posSlide)):undefined;
			
		}
		
		public function kill(){
			try{
				if(SpriteImage.numChildren>0){
					while(SpriteImage.numChildren>0){
						SpriteImage.removeChildAt(0);
					}
				}
			}catch(e:Error){}

			var evt:propagaEvento = new propagaEvento(propagaEvento.DELETADO, {param:'ok'});
				this.dispatchEvent(evt);

		}

	}
	
}
