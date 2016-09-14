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
	
	[Event(name="cargaCompleta",type="starling.events.Event")]
	
	public class ModuloPopup extends Sprite
	{
		public static const FINISHED:String = "cargaCompleta";
		
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
		
		private var modulo_imagem:MyImageLoader2;
		
		private var oY:Number = 0;
		private var oX:Number = 0;
		
		private var contImagens:Number = 0;
		
		private var allCompleted:Boolean = false;
		
		private var totalW:Number;
		private var totalH:Number;
		
		private var item:String;
		
		
		public function ModuloPopup(props:Object)
		{
			
			trace('CRIA POPUP');

			_props = props;
			
			
			//trace('dentro ' + item);
			
			//trace('dentro ' + _props.idM + _props.idI);
			
			if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@tipo == 'timeline'){
				
				for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
				{
					//trace ("itemCount " + itemData.localName()); 
					item = itemData.localName();
				}
				
				if(item == 'item'){
					trace('tem item');
					_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
				}else{
					trace('nao tem item');
					_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo
				}
				
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo
			}

			
			_h = _xml.@height;
			_w = _xml.@width;
			
			//trace('comecou a criar o popup: ' + _props.idM+ ' - ' + _props.idI + ' - ' + _props.idT);
			
			_props = props;
			
			
			
		//	_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI];
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.height = _h;
			
			imageArr = new Array();
		}
		
		private function criaComponente(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			
			criaImagem();
		
		}
		
		private function criaImagem():void
		{
			
			if(globalVars.xml.menu[_props.idM].modulo[_props.idI].@tipo == 'timeline'){
				trace('timeline');
				modulo_imagem = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:contImagens, max:false});
			}else{
				trace('normal');
				modulo_imagem = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:contImagens, max:false});
			}
			
			//trace('IMAGE FROM MODULE BUILDER: ' + _xmlRoot[modulos[0][1]]);
			/*if(getY == 0 && Number(_xmlRoot[modulos[0][1]].@x) == 0){
			modulo_imagem.y = yInicial;
			}else{
			modulo_imagem.y = getY;
			}*/
			
			imageArr.push(modulo_imagem);
			
			//modulo_imagem.addEventListener('TESTE', imageModuleCreated);
			
			//dispatchEvent(new starling.events.Event('Modulos.CARREGADOS'));
			//modulo_imagem.alpha = 0;
			contImagens++;
			
			modulo_imagem.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
			
			this.addChild(modulo_imagem);
			
		}
		
		private function imageModuleCreated(evt:Event):void
		{
			
			//trace('width: ' + modulo_imagem.width);
			
			modulo_imagem.removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
			modulo_imagem.x = (modulo_imagem._width + Number(_xml.@padding)) * oX;
			modulo_imagem.y = (modulo_imagem._height + Number(_xml.@padding)) * oY;
			
			//modulo_imagem.x = 0;
			//modulo_imagem.y = 0;
			
			//TweenLite.to(modulo_imagem, .5, {alpha:1});
			
			modulo_imagem.addEventListener(TouchEvent.TOUCH, clicado);
			
			//trace('imagens: ' + _xml + " - " + _xml.@width);
			
			if(_xml.length() > contImagens){
				
				//trace(oX*modulo_imagem.width + "  |  " + Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@width - modulo_imagem.width*2));
				
				if(oX*modulo_imagem._width < Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@width - modulo_imagem._width*2)){
					oX++;
				}else{
					oX = 0;
					oY++;
				}
				criaImagem();
			}else{
				this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
				allCompleted = true;
			}

		}
		
		private function clicado(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);
			
				
				if(!TweenMax.isTweening(quad) && allCompleted == true){
					
					parent.setChildIndex(this, parent.numChildren-1);
					
					
					quad = new Quad(1, 1080, 0x000000);
					quad.alpha = .95;
					
					quad.x = -Number(_xml.parent().parent().@x);
					quad.y = -Number(_xml.parent().parent().@y);
					
					addChild(quad);
					
					//trace('Tweening: ' + TweenMax.isTweening(quad) + " y: " + _xml.parent().parent().@y);
					
				//	trace('POSICAO: ' + (evt.currentTarget as MyImageLoader).imagePos);
					
					totalW = Starling.current.stage.width;
					totalH = Starling.current.stage.height;
					
					TweenMax.to(quad, .5, {width:totalW, onComplete:function():void{ TweenLite.to(quad, .5, {height:totalH});}});
					
					abreImagem(evt.currentTarget as MyImageLoader2)
					
					this.dispatchEventWith(FINISHED, false, '');
				}
			}
			
			//trace(TweenMax.isTweening(quad));
			
		}
		
		private function abreImagem(item):void{
			
		//	trace('get: ' + item + " vars: " + item._props.idM + " - " + item._props.idI + " - " + item._props.idT + " - " + item._props.idW);
			
			//img = new MyImageLoader2({idM:item._props.idM, idI:item._props.idI, idT:item._props.idT, idW:item._props.idW,  max:true});
			img = new MyImageLoader2({idM:item._props.idM, idI:item._props.idI, idT:item._props.idT, idW:0,  max:true});
			
			img.addEventListener(propagaEvento.IMAGELOADED, imagePopupCreated);
			//img.maintainAspectRatio = false;
			
			img.alpha = 0;
			
			//img.source = item.popup;
		//	img.addEventListener(TouchEvent.TOUCH, fechaPopup);
			addChild(img);

			
			//img.addEventListener(TouchEvent.TOUCH, fechaPopup);
			
			
			//imageArr.push(xis);
			
			//TweenLite.from(xis, .5, {scaleX:0, scaleY:0, delay:.5, ease:Elastic.easeOut});
			
		}
		
		private function imagePopupCreated(evt:Event):void
		{
			img.removeEventListener(propagaEvento.IMAGELOADED, imagePopupCreated);
			// TODO Auto Generated method stub
			img.x = totalW/2 - (evt.currentTarget as MyImageLoader2).width /2 -Number(_xml.parent().parent().@x);
			img.y = totalH/2 - (evt.currentTarget as MyImageLoader2).height /2 -Number(_xml.parent().parent().@y);
			
			TweenLite.to(img, .5, {alpha:1, delay:1});
			
			xis = new MyImageLoader2({idM:0, idI:0 });
			//xis.x = -Number(_xml.parent().parent().@x) + totalW - xis.width*2 - 200;
			//xis.y = -Number(_xml.parent().parent().@y) + xis.height*2 + 200;
			xis.x = Starling.current.stage.stageWidth - xis.width - 100;
			xis.y = -40  ;
			
			xis.pivotX = 28;
			xis.pivotY = 28;
			xis.addEventListener(TouchEvent.TOUCH, fechaPopup);

			addChild(xis);
			
		}
		
		private function fechaPopup(evt:TouchEvent = null):void
		{
			//trace('XIS');
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//evt.currentTarget.removeEventListener(TouchEvent.TOUCH, clicado);
				(evt.currentTarget as MyImageLoader2).removeEventListener(TouchEvent.TOUCH, fechaPopup);
				//xis.removeEventListener(TouchEvent.TOUCH, fechaPopup);
				
				TweenLite.to(img, .5, {alpha:0});
				TweenMax.to(quad, .5, {height:1, onComplete:function():void{ TweenLite.to(quad, .5, {width:0});}});
				
				xis.dispose();
				removeChild(xis);
				
				TweenMax.delayedCall(1, function():void{img.dispose();removeChild(img);removeChild(quad);});
				/*img.dispose();
				removeChild(img);
				removeChild(quad);*/
			}

		}
		
		private function disposeArrayImages():void
		{
			try{
				for(var i:Number=0; i<imageArr.length; i++){
					imageArr[i].removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
					imageArr[i].removeEventListener(TouchEvent.TOUCH, clicado);
					imageArr[i].dispose();
					removeChild(imageArr[i]);
				}
			}catch(err){}

			imageArr = [];
			imageArr = null;
			
			try{
				img.removeEventListener(TouchEvent.TOUCH, fechaPopup);
				img.dispose();
				removeChild(img);
				removeChild(quad);
			}catch(err){};
	
		}
		
		override public function dispose():void{
			disposeArrayImages();
		}
	}
}