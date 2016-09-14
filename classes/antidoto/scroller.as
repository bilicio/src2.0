package classes.antidoto {
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.events.TweenEvent;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.core.TouchMovieClip;
	import com.gestureworks.core.TouchSpriteBase;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.Sprite;
		
	public class scroller extends Sprite{
		
		private var mousey:Number;

		private var savedLink;
		
		public var cont:TouchSprite;
		
		//private var masK:BlitMask;
		
		private var tween:TweenMax;
		
		private var _largura:Number;
		private var _altura:Number;
		private var _dados;
	
		private var selector:Sprite;
		
		private var masK:Sprite;
		
		private var holder:Number = 3;
		
		public function scroller(posX:Number, posY:Number, largura:Number, altura:Number, dados = null) {
			_largura = largura;
			_altura = altura;
			
			this.x = posX;
			this.y = posY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		}
		
		private function addedToStage(evt:Event){
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.addEventListener(MouseEvent.MOUSE_UP, upped);
			criaScroller();
		}
		
		private function criaScroller(){
			selector = new Sprite();
			selector.graphics.beginFill(0x000000);
			selector.graphics.drawRect(0,0,_largura,_altura);
			selector.graphics.endFill();
				
			masK = new Sprite();
			masK.graphics.beginFill(0x000000);
			masK.graphics.drawRect(0,0,_largura,_altura);
			masK.graphics.endFill();

			cont = new TouchSprite();

			cont.gestureEvents = true;
				//container.addChild(_selector);
			selector.addChild(cont);
				
			selector.addChild(masK);
			cont.mask = masK;
				
			cont.touchChildren = true;
			cont.addEventListener(GWGestureEvent.DRAG, gestureDragHandler);
				//cont.addEventListener(GWGestureEvent.HOLD, gestureTapHandler);
				
			
				
			addChild(selector);
				
			//masK = new BlitMask(cont, 0, 0, _largura, _altura, true);
				
				
		}
		
		private function gestureDragHandler(event:GWGestureEvent):void
		{
			event.target.x = 0;
			if(event.target.y>0 || event.target.y<Number(-(event.target.height-masK.height))){
				tween = TweenMax.to(event.target, 1, {y:event.target.y+(event.value.dy)*2, ease:Quart.easeOut});
			}else{
				tween = TweenMax.to(event.target, 1, {y:event.target.y+(event.value.dy)*4, ease:Quart.easeOut});
			}
			if(mouseY<0||mouseY>_altura||mouseX<0||mouseX>_largura){
				cont.gestureList = {"n-drag":false};
				onFinishTween();
			}
			//trace(mouseY);
			

		}
		
		// -----------------------------------------> Filtra os Itens (Passar objeto e a tag do filtro)
		public function filtraItens(objeto,filtro:String = ''){
			trace(objeto + " - " + filtro);
			var acc:Number = 0;
			tween = TweenMax.to(cont, 1, {y:0, ease:Quart.easeOut});
			
			if(filtro==''){
				for(var i:Number = 0; i<objeto.length; i++){
					var nome = objeto.getItemAt(acc);
					
					var loja:splat_loja = new splat_loja();
						loja.nome.text = nome.Item;
						loja.y = -50;
						loja.link = nome.link;
						loja.name = nome.Item;
						
						//TweenMax.to(loja, .5, {y:44*i, ease:Quart.easeOut, delay:i*.1});
						loja.y = 44*acc;
						
						loja.addEventListener(MouseEvent.MOUSE_DOWN, pressed);
						
						cont.addChild(loja);
						acc++
					//stage.setChildIndex(loja, numChildren - 1);
				}
			}else{
				for(var a:Number = 0; a<objeto.length; a++){
					var onome = objeto.getItemAt(a);
					
					if(onome.Type == filtro){
						var aloja:splat_loja = new splat_loja();
							aloja.nome.text = onome.Item;
							aloja.y = -50;
							aloja.link = onome.link;
							
							//TweenMax.to(loja, .5, {y:44*i, ease:Quart.easeOut, delay:i*.1});
							aloja.y = 44*acc;
							
							aloja.addEventListener(MouseEvent.MOUSE_DOWN, pressed);
							
							cont.addChild(aloja);
							acc++;
					}
					//stage.setChildIndex(loja, numChildren - 1);
				}
			}
		}
		
		private function pressed(evt:Event){
			//trace(numChildren);
			cont.gestureList = {"n-drag":true};
			try{
				tween.removeEventListener(TweenEvent.UPDATE, onFinishTween);
			}catch(e:Error){}
			
			mousey = stage.mouseY;
			//mouseyY = _selector.stores.mouseY;
			savedLink = evt.currentTarget.name;

		}
		
		private function upped(evt:Event){
			if(Math.abs(mousey-stage.mouseY)<40){
				mousey = undefined;
				//trace(savedLink);
				var devt:propagaEvento = new propagaEvento(propagaEvento.ITEM, {item:savedLink});
				this.dispatchEvent(devt);
			}
			try{
				tween.addEventListener(TweenEvent.UPDATE, onFinishTween);
			}catch(e:Error){};
		}
		
		
		private function onFinishTween(evt:TweenEvent = null){
			if(cont.y>0 || cont.height<=masK.height){
				tween = TweenMax.to(cont, 1, {y:0, ease:Quart.easeOut});
			}else if(cont.y<Number(-(cont.height-masK.height))){
				tween = TweenMax.to(cont, 1, {y:Number(-(cont.height-masK.height)), ease:Quart.easeOut});
			}
		}
		
		// -----------------------------------------> Limpa os Itens
		public function limpaItens(){

			try{
				if(cont.numChildren>0){
					while(cont.numChildren>0){
						
						cont.getChildAt(0).removeEventListener(MouseEvent.MOUSE_DOWN, pressed);
						cont.removeChildAt(0);
					}
				}
			}catch(e:Error){}
		}
		
		// -----------------------------------------> Elimina a classe
		public function kill(){
			
			limpaItens();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, upped);
			cont.removeEventListener(GWGestureEvent.DRAG, gestureDragHandler);
			
			try{
				if(numChildren>0){
					while(numChildren>0){
						removeChildAt(0);
					}
				}
			}catch(e:Error){}
			
			var evt:propagaEvento = new propagaEvento(propagaEvento.DELETADO, {param:'true'});
				this.dispatchEvent(evt);

			//trace(getChildAt(0).name);
			
		}

	}
	
}
