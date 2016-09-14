package classes.antidoto.componentes
{
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import app.Main;
	
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	//------------------------------------------------------- Eventos de retorno de função
	[Event(name="openPage",type="starling.events.Event")]
	[Event(name="cargaCompleta",type="starling.events.Event")]

	public class ModuloVideoStarling extends starling.display.Sprite
	{
		public static const OPEN_PAGE:String = "openPage";
		public static const FINISHED:String = "cargaCompleta";
		public static const DISPOSED:String = "disposed";

		private var modulo_imagem:MyImageLoader;
		
		private var r:Main;
		private var quad:Quad;
		private var quadplayer:Quad;
		
		private var xis:MyImageLoader2;
		private var _image:String;
		
		private var _props:Object;

		
		
		private var playing:Boolean = true;
		
		private var playBtn:MyImageLoader2;
		private var stopBtn:MyImageLoader2;
		private var pauseBtn:MyImageLoader2;
		
		private var _id:*;
		private var _xml:XML;
		
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		
		private var texture:Texture;
		private var video:Image;
		
		private var _duration:Number = 0;
		
		private var timer:Timer = new Timer(1, 0)
		private var scroller:Quad = new Quad(1, 1, 0xc1d62f);

		public function ModuloVideoStarling(props:MyImageLoader2)
		{
			_props = props._props;
			
			_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI];
			
			initializeHandler()
			
			//addEventListener(TouchEvent.TOUCH, teste);

		}
		
		private function teste(evt:Event):void
		{
			trace(evt.currentTarget);
			
		}		
		
		
		protected function initializeHandler():void
		{
			criaComponentes();
		}

		private function criaComponentes():void
		{

			quad = new Quad(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0x000000);
			quad.alpha = .8;
			addChild(quad);
			
			quadplayer = new Quad(1280, 53, 0x000000);
			quad.alpha = 1;
			quadplayer.x = 1920/2 - 1280/2;
			quadplayer.y = 1080/2 - 720/2 + 720;
			
			addChild(quadplayer);
			
			netConnection = new NetConnection()
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			netConnection.connect(null);
			netConnection.client = { };
			netConnection.client.onMetaData = function ():void { };
			netStream = new NetStream(netConnection);
			netStream.client = {};
			netStream.client.onMetaData = ns_onMetaData;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);

			

			netStream.play('vds/'+_xml.@file);

			texture = Texture.fromNetStream(netStream, 1, function():void
			{
				video = new Image(texture)
				addChild(video);
				
				video.x = 1920/2 - 1280/2;
				video.y = 1080/2 - 720/2;
			});

			

			pauseBtn = new MyImageLoader2({idM:0, idI:2});
			pauseBtn.x = 1920/2 - 1280/2 ;
			pauseBtn.y = 1080/2 - 720/2 + 721;
			
			pauseBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
			addChild(pauseBtn);
			
			
			stopBtn = new MyImageLoader2({idM:0, idI:3});
			stopBtn.x = 1920/2 - 1280/2 + 52;
			stopBtn.y = 1080/2 - 720/2 + 721;
			
			stopBtn.addEventListener(TouchEvent.TOUCH, toggleStop);

			addChild(stopBtn);

			xis = new MyImageLoader2({idM:0, idI:0});
			//xis.x = 1920/2 - 1280/2 + 1280+60;
			//xis.y = 1080/2 - 720/2 - 60;
			xis.x = 1800;
			xis.y = 50;
			
			xis.addEventListener(TouchEvent.TOUCH, unBuild);

			addChild(xis);
			
			scroller = new Quad(15, 40, 0xffffff);
			scroller.alpha = 1;
			scroller.x = 1920/2 - 1280/2 + 72
			scroller.y = 1080/2 - 720/2 + 726
			addChild(scroller);
			
			scroller.addEventListener(TouchEvent.TOUCH, drag);
			
			
			timer.addEventListener(TimerEvent.TIMER, moveScroller)

		}
		
		private function drag(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as Quad, TouchPhase.BEGAN)){
				//var touch:Touch = evt.getTouch(this, TouchPhase.BEGAN);
				//var localPos:Point = touch.getLocation(this);
				//trace("Touched object at position: " + localPos);
				timer.stop();
			}
			
			if(evt.getTouch(evt.currentTarget as Quad, TouchPhase.MOVED)){
				var touch:Touch = evt.getTouch(this);
				var localPos:Point = touch.getLocation(this);
				
				if(localPos.x>430 && localPos.x<1580){
					(evt.currentTarget as Quad).x = localPos.x-7;
				}
			}
			
			if(evt.getTouch(evt.currentTarget as Quad, TouchPhase.ENDED)){
				//var touch:Touch = evt.getTouch(this, TouchPhase.BEGAN);
				//var localPos:Point = touch.getLocation(this);
				//trace("Touched object at position: " + localPos);
				netStream.seek(((evt.currentTarget as Quad).x-300) * ((_duration) / 1400));
				// (mouseClickedXPos-100) * (totalTime/(controlBarControls.width-100)); netStream.seek(_duration * (scroller.x - 200)  / 1280)
				
				//TweenMax.delayedCall(2, function():void{timer.start();});
				timer.start();
			}
			
		}		
		
		protected function moveScroller(event:TimerEvent):void
		{
			scroller.x = ((1920/2 - 1200/2 + 72 + (53*2 + 5) + (1200-14) * (netStream.time / _duration))-90)*.95
			//trace('PORCENT: ' + netStream.time / _duration * 100);
			
		}
		
		private function ns_onMetaData(item:Object):void {
			for (var propName:String in item) {
				//	trace(propName + " = " + item[propName]);
			}
			_duration = item.duration;
		}
		
		private function togglePlay(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				netStream.togglePause(); 
				
				if(playing){
					
					removeChild(pauseBtn);
					pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					
					playBtn = new MyImageLoader2({idM:0, idI:1});
					playBtn.x = 1920/2 - 1280/2 ;
					playBtn.y = 1080/2 - 720/2 + 721;
					
					playBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					
					addChild(playBtn);
					
					playing = false;
					
				}else{
					removeChild(playBtn);
					playBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					
					pauseBtn = new MyImageLoader2({idM:0, idI:2});
					pauseBtn.x = 1920/2 - 1280/2 ;
					pauseBtn.y = 1080/2 - 720/2 + 721;
					
					pauseBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					
					addChild(pauseBtn);
					playing = true;
				}
			}
		}
		
		private function toggleStop(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				
				if(playing){
					
					removeChild(pauseBtn);
					pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					
					playBtn = new MyImageLoader2({idM:0, idI:1});
					playBtn.x = 1920/2 - 1280/2 ;
					playBtn.y = 1080/2 - 720/2 + 721;
					
					playBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					
					addChild(playBtn);
					
					playing = false;
					
					netStream.pause(); 
					netStream.seek(0); 
					
				}else{
					
					netStream.pause(); 
					netStream.seek(0); 
					
				}
					
				
			}
		}
		
		private function statusHandler(event:NetStatusEvent):void 
		{ 
			//trace( "Status event from " + event.target.info.uri + " at " + event.target.time ); 
			
			switch (event.info.code) 
			{ 
				case "NetConnection.Connect.Success":
					trace('play');
					break;
				
				case "NetStream.Play.Start": 
					this.dispatchEventWith(FINISHED, false, '');
					timer.start();
					//getStuff();
					
					break; 
				case "NetStream.Play.Stop": 
					
					trace('stop');
					close();
					
					break; 
				
				case "NetConnection.Connect.Closed": 
					trace('closed');
					this.dispatchEventWith(DISPOSED, false, '');
					break; 
			} 
		}
		
		private function getStuff():void
		{
			/*for(var i:Number = this.numChildren; i++;){
				trace('CHILD: ' + this.getChildAt(i))
			}*/
			
		}
	
		public function build():void{
			criaComponentes();
		}
		
		public function unBuild(evt:TouchEvent):void{

			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				
				trace('UNBUILD VIDEO');
				
				netStream.close();
				netConnection.close();
				
				removeChild(quad);
				removeChild(quadplayer);
			
				texture.dispose();

				
				try{
					
					//video.dispose();
					
					removeChild(xis);
					
					xis.removeEventListener(TouchEvent.TOUCH, unBuild);

					stopBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					removeChild(stopBtn);

				}catch(err){};
				
				try{
					playBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					removeChild(playBtn);
				}catch(err){};
				
				try{
					pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					removeChild(pauseBtn);
				}catch(err){};
			}
			
			
			
		}
		
		private function close():void{
			
			trace('CLOSE VIDEO');
			
			netStream.close();
			netConnection.close();
			
			removeChild(quad);
			removeChild(quadplayer);
			
			texture.dispose();
			
			
			try{
				
				//video.dispose();
				
				removeChild(xis);
				
				xis.removeEventListener(TouchEvent.TOUCH, unBuild);
				
				stopBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
				removeChild(stopBtn);
				
			}catch(err){};
			
			try{
				playBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
				removeChild(playBtn);
			}catch(err){};
			
			try{
				pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
				removeChild(pauseBtn);
			}catch(err){};
		}
		
		//------------------------------------------------------- Dispose Menu
		override public function dispose():void{
			
			//video.stop();
			
			try{
				netStream.close();
				netConnection.close();
			}catch(err){};
			
			try{
				video.dispose();
				removeChild(xis);
				removeChild(quad);
				xis.removeEventListener(TouchEvent.TOUCH, unBuild);
				
				texture.dispose();
				removeChild(quadplayer);
				
				stopBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
				removeChild(stopBtn);
				
			}catch(err){};
			
			try{
				playBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
				removeChild(playBtn);
			}catch(err){};
			
			try{
				pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
				removeChild(pauseBtn);
			}catch(err){};

		}
	}
}
