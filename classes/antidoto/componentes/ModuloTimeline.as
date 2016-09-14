package classes.antidoto.componentes
{

	//import flash.events.Event;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.net.getClassByAlias;
	import flash.ui.Keyboard;
	
	import app.Main;
	
	import classes.antidoto.Assets;
	import classes.antidoto.ImageLoaderBA;
	import classes.antidoto.Local;
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.as3commons.zip.ZipLibrary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;

	//import starling.filters.BlurFilter;
	
	//------------------------------------------------------- Eventos de retorno de função
	[Event(name="openPage",type="starling.events.Event")]
	[Event(name="cargaCompleta",type="starling.events.Event")]

	public class ModuloTimeline extends Screen
	{
		public static const OPEN_PAGE:String = "openPage";
		public static const FINISHED:String = "cargaCompleta";
		
		private var empreend:ListCollection;

		public function ModuloTimeline()
		{
			super.initialize();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			//initializeHandler()
		}
		
		private var _list:List;
		private var banner:MyImageLoader;
		private var _footer:MyImageLoader;
		//private var _back:ImageLoaderBA;
		
		
		private var xmlRoot:XMLList;
		private var qgXML:XML;
		
		private var atracaoesListaLayout:TiledRowsLayout;
		
		private var modulo_imagem:MyImageLoader2;
		
		private var vid:VideoLoader;
		
		private var _local:Local;
		private var vidLoader:Sprite;
		
		private var r:Main;
		
		private var myTimeline:TimelineMax ;
		private var nestedTimeline:TimelineMax;
		private var _zipFile:ZipLibrary;
		
		private var timelineArr:Array = new Array();
		
		private var imageModules:Array = new Array();
		
		private var velTime:Number = 2;
		
		private var timelineToPlay:Number = 0;
		private var firstTimeline:Number = 0
		private var timelineTotal:Number = 0
		
		private var stagger:Number = .2;
		private var time:Number = 2;
		
		private var imageSrc:*;
		
		private var contaX:Number;
		private var contaY:Number;
		
		private var modules:ModuloBuilder;
		private var modulo_formulario:ModuloFormulario;
		private var modulo_btn:ModuloBtnForm;
		private var modulo_webcam:ModuloWebCam;
		private var modulo_btnDyn:ModuloBtnDynamic;
		private var modulo_campo:ModuloCampo;
		private var modulo_custom:ModuloCustom;
		//private var zipFile:ZipFile;
		
		private var lockTimeline:Boolean = true;
		
		protected function initializeHandler(evt:starling.events.Event = null):void
		{

			qgXML = new XML(Assets.am.getXml('settings').toXMLString());
			xmlRoot = qgXML.app;
			
			TweenPlugin.activate([BlurFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.
			
			this.x = 0;
			this.y = 0;
			
			
		}
		
		//------------------------------------------------------- Seta e Pega variavel para abrir mapa com lugar específico
		public function get local():Local
		{
			return _local;
		}
		
		public function set local(value:Local):void
		{
			
			if(_local == value)
			{
				return;
			}
			
			this._local = value;
			this.invalidate( INVALIDATION_FLAG_DATA );
			
		}
		
		public function get zipFile():ZipLibrary
		{
			return _zipFile;
		}
		
		public function set zipFile(value:ZipLibrary):void
		{
			
			if(_zipFile == value)
			{
				return;
			}
			
			this._zipFile = value;
			this.invalidate( INVALIDATION_FLAG_DATA );
			
		}
		
		private function criaComponentes(evt:starling.events.Event=null):void
		{

		//	trace('TIMELINE: ' + xmlRoot.menu[_local.id].modulo.length());
			
			myTimeline = new TimelineMax({onReverseComplete:backTimeline, onComplete:terminouTimeline, align:'normal'});
			
			velTime = Number(xmlRoot.menu[_local.id].@vel);
			stagger = Number(xmlRoot.menu[_local.id].@stagger);
			time = Number(xmlRoot.menu[_local.id].@time);
			
			
			
			globalVars.cadastro2["cip"] = xmlRoot.menu[0].@ip;
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, teclaApertada);

			//Starling.current.nativeOverlay.addChild(modulo_imagem);
			
			if(xmlRoot.menu[_local.id].modulo[0].@tipo != "timeline"){
				modules = new ModuloBuilder({menuID:_local.id});
				modules.addEventListener('Modulos.CARREGADOS', ModuleCreated);
				modules.y = 0;
				
				
				//modules.addEventListener(TouchEvent.TOUCH, reset);

				addChild(modules);
			}
			
			/*if(xmlRoot.menu[_local.id].modulo[1].@tipo != "timeline"){
				modules = new ModuloBuilder({menuID:_local.id, moduloID:1, moduloIT:0});
				modules.addEventListener('Modulos.CARREGADOS', ModuleCreated);
				modules.y = 0;
				modules.addEventListener(TouchEvent.TOUCH, jump);
				
				addChild(modules);
			}*/
			
			for(var i:Number=0; i<xmlRoot.menu[_local.id].modulo.length(); i++ ){
				if(xmlRoot.menu[_local.id].modulo[i].@tipo == "timeline"){
					timelineTotal++
				}
			}
			
			for(var a:Number=0; a<xmlRoot.menu[_local.id].modulo.length(); a++ ){
				if(xmlRoot.menu[_local.id].modulo[a].@tipo == "timeline"){
					if(firstTimeline == 0){
						criaTimeline(a);
						firstTimeline = a;
						timelineToPlay = a;
						
						break;

					}

				}
			}
			
			
			//this.dispatchEventWith(FINISHED, false, '');
		}
		
		private function ModuleCreated(evt:starling.events.Event):void{
			
			//trace('remove event');
			
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', ModuleCreated);
			//this.dispatchEventWith(FINISHED, false, '');
			
			//trace((modules.getChildAt(4) as MyImageLoader).tela + " - " + (modules.getChildAt(4) as MyImageLoader).name);
		}
		
		private function criaTimeline(a):void{
			
			lockTimeline = true;
			
			trace('TIME TO PLAY: ' + timelineToPlay + ' - ' + a);
			
			imageModules = [];
			trace('------------- CRIA TIMELINE -------------' + a);
			try{
				
				imageSrc = xmlRoot.menu[_local.id].modulo[a].item[0].modulo;
				
				for(var i:Number=0; i<imageSrc.length(); i++ ){
					
					trace('TIPO: ' + String(imageSrc[i].@tipo));
					
					switch(String(imageSrc[i].@tipo)){

						case "imagem" :
	
							modulo_imagem = new MyImageLoader2({idM:_local.id, idI:a, idT:i, max:true});

							imageModules.push(modulo_imagem);
							
							modulo_imagem.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
							
							if(xmlRoot.menu[_local.id].modulo[a].item[0].modulo[i] == 'back_intro.jpg'){
								modulo_imagem.addEventListener(TouchEvent.TOUCH, reset);
							}
							
							trace("IMAGEM: " + xmlRoot.menu[_local.id].modulo[a].item[0].modulo[i]);
							
							modulo_imagem.alpha = 0;
							
							this.addChild(modulo_imagem);
							
							modulo_imagem.filter = new starling.filters.BlurFilter(10, 10);
							Starling.juggler.tween(modulo_imagem.filter, 1, { blurX: 0, blurY: 0 , delay:i/(velTime/stagger)});
						
						break;
							
						case "formulario" :
							modulo_formulario = new ModuloFormulario({idM:_local.id, idI:a, idT:i});
	
							modulo_formulario.addEventListener('Modulos.CARREGADOS', formularioModuleCreated);
		
							addChild(modulo_formulario);
	
							imageModules.push(modulo_formulario);
							
							imageModules[i].alpha = 0;
							
							trace('formulario');
						break;
						
						case "campo" :
							modulo_campo = new ModuloCampo({idM:_local.id, idI:a, idT:i});
							
							modulo_campo.addEventListener('Modulos.CARREGADOS', campoModuleCreated);
							
							addChild(modulo_campo);
							
							imageModules.push(modulo_campo);
							
							imageModules[i].alpha = 0;
							
							trace('modulo_campo');
							break;
						
						case "btnForm" :
							modulo_btn = new ModuloBtnForm({idM:_local.id, idI:a, idT:i});
							
							modulo_btn.addEventListener('Modulos.CARREGADOS', btnFormModuleCreated);
							
							addChild(modulo_btn);
							
							imageModules.push(modulo_btn);
							
							imageModules[i].alpha = 0;
							
							trace('btnForm');
						break;
						
						case "btnDynamic" :
							modulo_btnDyn = new ModuloBtnDynamic({idM:_local.id, idI:a, idT:i});
							
							modulo_btnDyn.addEventListener('Modulos.CARREGADOS', btnDynModuleCreated);
							modulo_btnDyn.addEventListener('Modulos.FINISHED', finished);
							
							modulo_btnDyn.addEventListener(TouchEvent.TOUCH, travar);
							
							addChild(modulo_btnDyn);
							
							imageModules.push(modulo_btnDyn);
							
							imageModules[i].alpha = 0;
							
							trace('modulo_btnDyn');
							break;
						
						case "webcam" :
							modulo_webcam = new ModuloWebCam({idM:_local.id, idI:a, idT:i});
							
							modulo_webcam.addEventListener('Modulos.CARREGADOS', webcamModuleCreated);
							
							addChild(modulo_webcam);
							
							imageModules.push(modulo_webcam);
							
							imageModules[i].alpha = 0;
							
							trace('webcam');
							break;
						
						case "custom" :
							modulo_custom = new ModuloCustom({idM:_local.id, idI:a, idT:i});
							
							modulo_custom.addEventListener('Modulos.CARREGADOS', customModuleCreated);
							modulo_custom.addEventListener('Modulos.FINISHED', finished);
							
							addChild(modulo_custom);
							
							imageModules.push(modulo_custom);
							
							imageModules[i].alpha = 0;
							
							trace('custom');
							break;
						
						default :

							modules = new ModuloBuilder({menuID:_local.id, moduloID:a, moduloIT:i});
							
							modules.addEventListener('Modulos.CARREGADOS', ModuleCreated);
							
							
							addChild(modules);
							
							imageModules.push(modules);
							
							imageModules[i].alpha = 0;
							
							if(imageSrc[i].@tipo == "btn"){
								if(imageSrc[i].@pagina == "timelineForward"){
									imageModules[i].addEventListener(TouchEvent.TOUCH, avanca);
								}else if(imageSrc[i].@pagina == "timelineBackward"){
									imageModules[i].addEventListener(TouchEvent.TOUCH, retrocede);
								}else if(imageSrc[i].@pagina == "jump"){
									imageModules[i].addEventListener(TouchEvent.TOUCH, jump);
								}
							}
							
							trace('btn');
						break;
					}
					
					
					trace('----------------------| POSICAO: ' + String(imageSrc[i].@tipo));
					
					switch(String(imageSrc[i].@tipo)){
						
						case "imagem" :
							switch(String(imageSrc[i].@transition)){

								case "posFromTop" :
									modulo_imagem.x = Number(imageSrc[i].@x);
									modulo_imagem.y = Number(imageSrc[i].@y)  - 100;
									myTimeline.to(modulo_imagem, 1, {alpha:1, y:imageSrc[i].@y-0, ease:Quad.easeOut}, i*stagger);
									break;
								
								case "posFromLeft" :
									//myTimeline.set(modulo_imagem, {x:Number(imageSrc[i].@x) - 100, y:Number(imageSrc[i].@y)});
									modulo_imagem.x = Number(imageSrc[i].@x) - 100;
									modulo_imagem.y = Number(imageSrc[i].@y);
									myTimeline.to(modulo_imagem, 1, {alpha:1, x:Number(imageSrc[i].@x), ease:Quad.easeOut}, i*stagger);
									break;
								
								case "posFromRight" :
									modulo_imagem.x = Number(imageSrc[i].@x) + 100;
									modulo_imagem.y = Number(imageSrc[i].@y);
									//myTimeline.set(modulo_imagem, {x:Number(imageSrc[i].@x) + 100, y:imageSrc[i].@y-0});
									myTimeline.to(modulo_imagem, 1, {alpha:1, x:Number(imageSrc[i].@x), ease:Quad.easeOut}, i*stagger);
									break;
								
								case "posFromBottom" :
									modulo_imagem.x = Number(imageSrc[i].@x);
									modulo_imagem.y = Number(imageSrc[i].@y)  + 100;
									myTimeline.to(modulo_imagem, 1, {alpha:1, y:Number(imageSrc[i].@y), ease:Quad.easeOut}, i*stagger);
									break;
								
								case "scaleFromCenter" :
									trace('foi2');
									/*img.x = -img.width/2;
									img.y = -img.height/2;
									
									spMask.clipRect = new Rectangle(-img.width/2, -img.height/2, img.width, img.height);
									
									this.x += img.width;
									this.y += img.height;
									
									releaseEvent();*/
									modulo_imagem.x = Number(imageSrc[i].@x);
									modulo_imagem.y = Number(imageSrc[i].@y);
									myTimeline.to(modulo_imagem, time, {alpha:1, ease:Quad.easeOut},i*stagger);
									
									break;
								
								case "delayAlpha" :
									modulo_imagem.x = Number(imageSrc[i].@x);
									modulo_imagem.y = Number(imageSrc[i].@y);
									
									TweenMax.to(modulo_imagem, 1, {alpha:1, delay:Number(imageSrc[i].@time)});
									
									myTimeline.to(modulo_imagem, 1, {alpha:0, ease:Quad.easeOut}, i*stagger);
									break;
								
								case "alpha" :
									modulo_imagem.x = Number(imageSrc[i].@x);
									modulo_imagem.y = Number(imageSrc[i].@y);
									
									
									myTimeline.to(modulo_imagem, 1, {alpha:1, ease:Quad.easeOut}, i*stagger);
									break;
								
								case "none" :
									//trace('NONE-1')
								//	myTimeline.set(modulo_imagem, {x:xmlRoot.menu[_local.id].modulo[a].item[i].@x, y:xmlRoot.menu[_local.id].modulo[a].item[i].@y});
									//if(i>2){
										modulo_imagem.x = Number(imageSrc[i].@x);
										modulo_imagem.y = Number(imageSrc[i].@y);
										myTimeline.to(modulo_imagem, time, {alpha:1, ease:Quad.easeOut},i*stagger);
									//}else{
										//myTimeline.to(modulo_imagem, 1, {alpha:1, ease:Quad.easeOut});
									//}
									//releaseEvent();
									break;
								
								default :
									modulo_imagem.x = Number(imageSrc[i].@x);
									modulo_imagem.y = Number(imageSrc[i].@y);
									myTimeline.to(modulo_imagem, 1, {alpha:1, ease:Quad.easeOut}, i*stagger);
									//trace('NONE')
									//releaseEvent();
									//spMask.clipRect = new Rectangle(0, 0, img.width, img.height);
									break;
							}
							
							break;
					
								
						
								
								
						case "formulario" :		
								//myTimeline.set(imageModules[i], {x:Number(imageModules[i].x+imageModules[i].width/2), y:Number(imageModules[i].y+imageModules[i].height/2)});
								imageModules[i].x = Number(imageSrc[i].@x);
								imageModules[i].y = Number(imageSrc[i].@y);
								myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut});
								
								
								trace('formulario timeline: ' + imageModules[i].alpha + ' i: ' + i) ;
							//	trace(imageModules[i].x);
								//trace(imageModules[i].x);
								//modules.alpha = 1;
						break;
						
						case "btnDynamic" :		
							//myTimeline.set(imageModules[i], {x:Number(imageModules[i].x+imageModules[i].width/2), y:Number(imageModules[i].y+imageModules[i].height/2)});
							imageModules[i].x = Number(imageSrc[i].@x);
							imageModules[i].y = Number(imageSrc[i].@y);
							myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut});
							
							
							trace('btnDynamic timeline: ' + imageModules[i].alpha + ' i: ' + i) ;
							//	trace(imageModules[i].x);
							//trace(imageModules[i].x);
							//modules.alpha = 1;
							break;
						
						case "campo" :		
							//myTimeline.set(imageModules[i], {x:Number(imageModules[i].x+imageModules[i].width/2), y:Number(imageModules[i].y+imageModules[i].height/2)});
							imageModules[i].x = Number(imageSrc[i].@x);
							imageModules[i].y = Number(imageSrc[i].@y);
							myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut});
							
							
							trace('campo timeline: ' + imageModules[i].alpha + ' i: ' + i) ;
							//	trace(imageModules[i].x);
							//trace(imageModules[i].x);
							//modules.alpha = 1;
							break;
						
						case "btnForm" :
							
							trace('btnForm');
							
							imageModules[i].x = Number(imageSrc[i].@x);
							imageModules[i].y = Number(imageSrc[i].@y);
							myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut});
							
							
							trace('btnForm timeline: ' + imageModules[i].alpha + ' i: ' + i) ;
							//	trace(imageModules[i].x);
							//trace(imageModules[i].x);
							//modules.alpha = 1;
							break;
						
						case "webcam" :
							
							trace('webcam');
							
							imageModules[i].x = Number(imageSrc[i].@x);
							imageModules[i].y = Number(imageSrc[i].@y);
							myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut});
							
							
							trace('webcam timeline: ' + Number(imageSrc[i].@x) + ' i: ' + i) ;
							//	trace(imageModules[i].x);
							//trace(imageModules[i].x);
							//modules.alpha = 1;
							break;
						
						default : 		
						//	myTimeline.set(imageModules[i], {x:Number(imageModules[i].x+imageModules[i].width/2), y:Number(imageModules[i].y+imageModules[i].height/2)});
							
							if(String(imageSrc[i].@transition) == "scaleFromCenter"){
							
								imageModules[i].x = Number(imageModules[i].x+imageModules[i].width/2);
								imageModules[i].y = Number(imageModules[i].y+imageModules[i].height/2);
								myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut}, i*stagger);
								
							}else if(String(imageSrc[i].@transition) == "delayAlpha"){

								//imageModules[i].x = 2100;
								//imageModules[i].touchable = false;
								TweenMax.to(imageModules[i], 1, {alpha:1, delay:Number(imageSrc[i].@time)});
								
								myTimeline.to(imageModules[i], 1, {alpha:0, ease:Quad.easeOut}, i*stagger);
								
							}else{
								myTimeline.to(imageModules[i], 1, {alpha:1, ease:Quad.easeOut}, i*stagger);
							}
							
							
							trace('button timeline: ' + imageModules[i].alpha + ' i: ' + i) ;
							//	trace(imageModules[i].x);
							//trace(imageModules[i].x);
							//modules.alpha = 1;
							break;
					}
						
						//myTimeline.staggerTo(imageModules, 1, {alpha:1, ease:Quad.easeOut}, .1);
					//	myTimeline.to(modulo_imagem, 1, {alpha:1, ease:Quad.easeOut});
						
						//myTimeline.add(TweenLite.to(modulo_imagem.filter, 1, {blurFilter:{blurX:10, blurY:10}}));
		
					}
				
				trace('play -> timeline: ' + imageModules);
				
				myTimeline.timeScale(velTime);
				myTimeline.play();
				

				//dispatchEvent(new starling.events.Event('Modulos.CARREGADOS'));	
				this.dispatchEventWith(FINISHED, false, '');
			}catch(err){};
		}
		
		private var contReset:Number = 0;
		
		private function reset(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//printArr.push(imageModules[i]);
				contReset++
				if(contReset == 3){
					NativeApplication.nativeApplication.exit();
				}
				TweenMax.delayedCall(1, limpa);
				
			}
			
		}
		
		private function limpa():void{
			contReset = 0;
		}
		
		private function customModuleCreated(evt:starling.events.Event):void
		{
			trace('custom carregado');
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', customModuleCreated);
			
		}
		
		private var printArr:Array = new Array();
		private var jaPrintou:Boolean = false;
		
		private function travar(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as ModuloBtnDynamic, TouchPhase.ENDED)){
				//printArr.push(imageModules[i]);
				
				printArr[0] = evt.currentTarget;
				
				TweenMax.delayedCall(1, toPrint);
				for(var i:Number=1; i<imageModules.length; i++){
					//imageModules[i].alpha = 0;
					imageModules[i].touchable = false;
					
				}
					//TweenMax.delayedCall(1, alphar);
			}
			
		}
		
		private function toPrint():void{
			if(!jaPrintou){
				//trace('array: ' + printArr);
				jaPrintou = true;
				printArr[0].aperta();
			}//else if(printArr.length == 1 && !jaPrintou){
			//	trace('array: ' + printArr);
				//jaPrintou = true;
			//	printArr[0].aperta();
			//}
		}
		
		private function alphar():void{

			for(var i:Number=1; i<imageModules.length; i++){
				imageModules[i].alpha = 0;
				imageModules[i].touchable = false;
			}

		}

		
		private function finished(evt:starling.events.Event):void
		{
						
			trace('PAGINA: ' + evt.data.pagina);
			
			if(!lockTimeline){
				if(evt.data.pagina == 'timelineForward'){
					if(timelineToPlay<timelineTotal){
						myTimeline.timeScale(velTime*10);
						myTimeline.reverse();
						timelineToPlay++;
					}
				}else if(evt.data.pagina == 'timelineBackward'){
					if(timelineToPlay!=firstTimeline){
						myTimeline.timeScale(velTime*10);
						myTimeline.reverse();
						timelineToPlay--
					}
				}else{
					myTimeline.timeScale(velTime*10);
					myTimeline.reverse();
					timelineToPlay = evt.data.index;
				}
			}
			
		}
		
		private function campoModuleCreated(evt:starling.events.Event):void
		{
			trace('campoModuleCreated carregado');
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', campoModuleCreated);
			
		}
		
		private function btnDynModuleCreated(evt:starling.events.Event):void
		{
			trace('btnDyn carregado');
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', btnDynModuleCreated);
			
		}
		
		private function webcamModuleCreated(evt:starling.events.Event):void
		{
			trace('webcam carregado');
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', webcamModuleCreated);
			
		}
		
		private function btnFormModuleCreated(evt:starling.events.Event):void
		{
			trace('btn carregado');
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', btnFormModuleCreated);
			
		}
		
		private function formularioModuleCreated(evt:starling.events.Event):void
		{
			trace('formulario carregado');
			evt.currentTarget.removeEventListener('Modulos.CARREGADOS', formularioModuleCreated);
			
		}
		
		private function backTimeline():void{
			
			
			printArr = [];
			myTimeline.clear();
			myTimeline.timeScale(velTime);
			
			for(var i:Number=0; i<imageModules.length; i++){
				
				//trace('===================== TRY BACK LENGTH' + imageModules.length );
				try{
					imageModules[i].addEventListener('Modulos.CARREGADOS', ModuleCreated);
				}catch(err){};
				
				if(imageModules[i].hasEventListener(TouchEvent.TOUCH)){
					try{
						//trace('kill - avanca');
						imageModules[i].removeEventListener(TouchEvent.TOUCH, avanca);
					}catch(err){};
					
					try{
						//trace('kill - retrocede');
						imageModules[i].removeEventListener(TouchEvent.TOUCH, retrocede);
					}catch(err){}
					
					
					try{
						//trace('kill - retrocede');
						imageModules[i].removeEventListener(TouchEvent.TOUCH, jump);
					}catch(err){}
					
					try{
						imageModules[i].addEventListener(TouchEvent.TOUCH, reset);
					}catch(err){}
				}
				
			//	trace('mao ' + imageModules[i]);
				
				if(imageModules[i] is MyImageLoader2){
					//trace("************************************************");
					imageModules[i].filter.dispose();
					imageModules[i].filter = null;
				}
				
				
				//trace('===================== TRY BACK' + imageModules[i] );
				imageModules[i].dispose();
				removeChild(imageModules[i]);
				
				
			}
			
			imageModules = [];
			
		//	trace('timetoplay: ' + timelineToPlay);
			
			if(modulo_formulario){
				
				modulo_formulario.dispose();
				modulo_formulario = null;
		
			}

			
			if(modulo_custom){
				modulo_custom.removeEventListener('Modulos.CARREGADOS', customModuleCreated);
				modulo_custom.removeEventListener('Modulos.FINISHED', finished);
				printArr = [];
				jaPrintou = false;
				modulo_custom = null;
			}
			
			if(modulo_webcam){
				//modulo_webcam.dispose();
				
				modulo_webcam = null;
			}
			
			if(modulo_btnDyn){
				modulo_btnDyn.removeEventListener('Modulos.CARREGADOS', customModuleCreated);
				modulo_btnDyn.removeEventListener('Modulos.FINISHED', finished);
				printArr = [];
				jaPrintou = false;
				modulo_btnDyn.dispose();
				modulo_btnDyn = null;
			}
			
			
			if(modulo_campo){
				modulo_campo.dispose();
				modulo_campo = null;
			}
			
			
			
			
			
			

			criaTimeline(timelineToPlay);
			//myTimeline.add(timelineArr[0]);
			
			//if(timelineToPlay != myTimeline.currentLabel()){
				//myTimeline.play("timeline_1");
			//}
		}
		
		private function terminouTimelineIndividual():void{
			
			
			myTimeline.pause();
			
			//trace(myTimeline.currentLabel());
		}
		
		private function imageModuleCreated(evt:starling.events.Event):void{

			evt.target.removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
			
			var teste:String = '';
			var numero:String = '';
			
			try{
				teste = xmlRoot.menu[_local.id].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@timer;
				numero = xmlRoot.menu[_local.id].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT].@index;
			}catch(err){};
			
			//trace('new PAGE: ' + teste);
			
			if(teste != ''){
				TweenMax.delayedCall(Number(teste), function():void{
					myTimeline.timeScale(velTime*10);
					myTimeline.reverse();
					//trace('FULL ->' + xmlRoot.menu[_local.id].modulo[(evt.currentTarget as MyImageLoader2)._props.idI].item[0].modulo[(evt.currentTarget as MyImageLoader2)._props.idT]);
					timelineToPlay = Number(numero);
				});
			}
				
			/*if(teste){
				
			}*/
			//TweenLite.to((evt.target as DisplayObject) , 1, {blurFilter:{blurX:10, blurY:10}})
			//trace('CARREGOU IMAGEM');
		}
		
		protected function terminouTimeline():void{
			trace('TEMINOU TIMELINE');
			lockTimeline = false;
			//myTimeline.pause();
		}
		
		private function teclaApertada(evt:KeyboardEvent):void
		{
			//trace('TARGET: ' + evt.keyCode);
			if(myTimeline._paused){
				//trace('NOT PAUSED');
				if(evt.keyCode == 37){
					
					if(timelineToPlay!=firstTimeline){
						myTimeline.timeScale(velTime*10);
						myTimeline.reverse();
						timelineToPlay--
					}
				}
				//var keyCode:uint = Keyboard.ENTER;
				//if(evt.keyCode == Keyboard.ENTER){
				if(evt.keyCode == 39){
					
					//trace('timeline atual: ' + myTimeline.getChildren());
				
					if(timelineToPlay<timelineTotal){
						myTimeline.timeScale(velTime*10);
						myTimeline.reverse();
						timelineToPlay++;
					}
					//goNextTimeline();
					//myTimeline.play();
				}
			}
			
		}
		
		private function avanca(evt:TouchEvent):void{
			if(!lockTimeline){
				if(evt.getTouch(evt.currentTarget as ModuloBuilder, TouchPhase.ENDED)){
					printArr.push(evt);
					TweenMax.delayedCall(.5, avancaGO, [evt]);
				}
			}
		}
		
		private function avancaGO(evt):void{
			if(printArr.length == 1 ){
				trace(printArr.length + ' UMA SO!');
				//jaPrintou = true;
				
				
					try{
						//trace("------------------------------- CHOICE: CLIENTE " + globalVars.cadastro2['ccliente']);
						//trace("------------------------------- CHOICE: CLIENTE " + globalVars.cadastro['cnome']);
					}catch(err){};
					
					if(modulo_formulario){
						modulo_formulario.saveVariables();
						if(!modulo_formulario.valida()){
							printArr = [];
							return
						}
					}
					
					if(modulo_btn){
						for(var i:Number=0; i<imageModules.length; i++){
							if(imageModules[i] is ModuloBtnForm){
								if(!imageModules[i].valida()){
									printArr = [];
									return
								}else{
									trace("btn: " + imageModules[i] + " OK"  );
								}
							}
						}
					}
					
					if(modulo_custom){
						if(!modulo_custom.free){
							return
						}
						//modules.saveVariables();
					}
					
					if(modulo_webcam){
						if(!modulo_webcam.saveVariables()){
							return
						}
					}
					
					if(timelineToPlay<timelineTotal){
						myTimeline.timeScale(velTime*10);
						myTimeline.reverse();
						timelineToPlay++;
					}
				
			}else{
				printArr = [];
			}
		}
		
		private function retrocede(evt:TouchEvent):void{
			//trace('retrocede')
			if(!lockTimeline){
				if(evt.getTouch(evt.currentTarget as ModuloBuilder, TouchPhase.ENDED)){
					if(timelineToPlay!=firstTimeline){
						myTimeline.timeScale(velTime*10);
						myTimeline.reverse();
						timelineToPlay--
					}
				}
			}
		}
		
		private function jump(evt:TouchEvent):void{
			if(!lockTimeline){
				if(evt.getTouch(evt.currentTarget as ModuloBuilder, TouchPhase.ENDED)){ //{menuID:_local.id, moduloID:a, moduloIT:i}
						
					if(modulo_btnDyn){
						
						modulo_btnDyn.saveVariables();
						
						for(var a:Number=a; a<imageModules.length; a++){
							imageModules[a].touchable = false;
						}
						
						return
					}
					
					if(modulo_custom){
						if(modulo_custom.free){
							modulo_custom.saveVariables();
							
							for(var i:Number=1; i<imageModules.length; i++){
								imageModules[i].touchable = false;
							}
							
							return
						}else{
							return
						}
					}
					
					TweenMax.delayedCall(.5, delayGO, [evt.currentTarget]);
	
				}
			}
		}
		
		private function delayGO(target):void{
			myTimeline.timeScale(velTime*10);
			myTimeline.reverse();
			timelineToPlay = xmlRoot.menu[_local.id].modulo[(target as ModuloBuilder)._props.moduloID].item[0].modulo[(target as ModuloBuilder)._props.moduloIT].@index;
		}
		
		private function goNextTimeline():void
		{
			myTimeline.reverse();
			
		}
		
		protected function progresso(event:flash.events.Event):void
		{
			r = this.root as Main;
			//r.trocaPagina('home');
			
		}

		public function build():void{
			criaComponentes();
		}
		
		public function unBuild():void{
			
		}
		
		//------------------------------------------------------- Dispose Menu
		override public function dispose():void{
		

		}
	}
}
