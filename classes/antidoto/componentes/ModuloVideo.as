package classes.antidoto.componentes
{

	
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import app.Main;
	
	import classes.antidoto.Local;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	//------------------------------------------------------- Eventos de retorno de função
	[Event(name="openPage",type="starling.events.Event")]
	[Event(name="cargaCompleta",type="starling.events.Event")]

	public class ModuloVideo extends starling.display.Sprite
	{
		public static const OPEN_PAGE:String = "openPage";
		public static const FINISHED:String = "cargaCompleta";

		private var _props:Object;
		
		private var _id:*;
		private var _xml:XML;
		
		private var texture:Texture;
		private var video:Image;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _color:uint

		public function ModuloVideo(props:Object)
		{
			_props = props;
			
			_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI];
			
			_width = _xml.@width;
			_height = _xml.@height;
			
			_color = _xml.@color;
			
			initializeHandler()
		}

		
		private var xmlRoot:XMLList;

		private var _local:Local;
		
		private var r:Main;
		//private var zipFile:ZipFile;
		private var quad:Shape
		
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		
		private var playing:Boolean = true;
		
		private var playBtn:MyImageLoader2;
		private var stopBtn:MyImageLoader2;
		private var pauseBtn:MyImageLoader2;
		private var quadplayer:Shape;
		
		private var tabPlayer:Sprite = new Sprite();
		
		private var bar:Shape = new Shape();
		
		private var scroller:Shape = new Shape();
		
		private var _duration:Number = 0;
		
		private var timer:Timer = new Timer(1, 0)
		
		protected function initializeHandler():void
		{
			criaComponentes();
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
			//this.invalidate( INVALIDATION_FLAG_DATA );
			
		}

		private function criaComponentes():void
		{

			netConnection = new NetConnection()
		//	netConnection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			netConnection.connect(null);
			netConnection.client = { };
			netConnection.client.onMetaData = function ():void { };
			netStream = new NetStream(netConnection);
			
			netStream.client = {};
			netStream.client.onMetaData = ns_onMetaData;
			//netStream.client.onCuePoint = ns_onCuePoint;
			
			netStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);

			netStream.play('vds/'+_xml.@file);
			
			texture = Texture.fromNetStream(netStream, 1, function():void
			{
				video = new Image(texture)
				addChild(video);
				
				video.addEventListener(TouchEvent.TOUCH, toggleTab);
				
				createPlayerController();
				
				
				
			});
			
			
			timer.addEventListener(TimerEvent.TIMER, moveScroller)
		
			
			netStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			
			
		}
		
		protected function moveScroller(event:TimerEvent):void
		{
			scroller.x = (53*2 + 5) + (bar.width-14) * (netStream.time / _duration)
			//trace('PORCENT: ' + netStream.time / _duration * 100);
			
		}
		
		private function ns_onMetaData(item:Object):void {
			for (var propName:String in item) {
			//	trace(propName + " = " + item[propName]);
			}
			_duration = item.duration;
		}
		
		private function toggleTab(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as Image, TouchPhase.ENDED)){
				if(!TweenMax.isTweening(tabPlayer) && tabPlayer.alpha == 0){
					TweenMax.to(tabPlayer, 1, {alpha:1});
					
					//TweenMax.delayedCall(5, volta)
				}else if(!TweenMax.isTweening(tabPlayer) && tabPlayer.alpha == 1){
					TweenMax.to(tabPlayer, 1, {alpha:0});
				}
			}
			
		}
		
		private function volta():void
		{
			if(!TweenMax.isTweening(tabPlayer)){
				TweenMax.to(tabPlayer, 1, {alpha:0});
			}
			
		}
		
		private function statusHandler(event:NetStatusEvent):void 
		{ 
			switch (event.info.code) 
			{ 
				case "NetConnection.Connect.Success":
					trace('play');
					break;
				
				case "NetStream.Play.Start": 
					trace('PLAYING START');
					timer.start();
					this.dispatchEventWith(FINISHED, false, '');

					break; 
				case "NetStream.Play.Stop": 
						trace('STOP');
					break; 
				
				case "NetStream.Buffer.Empty": 
					trace('EMPTY');
					timer.stop();
					//netStream.bufferTime=0;
					
					removeChild(pauseBtn);
					pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					playBtn = new MyImageLoader2({idM:0, idI:1});
					playBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					tabPlayer.addChild(playBtn);
					playing = false;
					
					netStream.pause(); 
					netStream.seek(0); 
					
					scroller.x = 53*2 + 5;
					break
				
				case "NetConnection.Connect.Closed": 
					trace('closed');
					//this.dispatchEventWith(DISPOSED, false, '');
					break; 
			} 
		}
		
		private function createPlayerController():void{
			quadplayer = new Shape();
			quadplayer.graphics.beginFill(_color, 1);
			quadplayer.graphics.drawRect(0, 0, _width, 53);
			quadplayer.graphics.endFill();
			tabPlayer.addChild(quadplayer);
			
			pauseBtn = new MyImageLoader2({idM:0, idI:2});
			pauseBtn.x = 0;
			pauseBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
			tabPlayer.addChild(pauseBtn);
			
			
			stopBtn = new MyImageLoader2({idM:0, idI:3});
			stopBtn.x = 52;
			stopBtn.addEventListener(TouchEvent.TOUCH, toggleStop);
			tabPlayer.addChild(stopBtn);
			
			bar.graphics.beginFill(0xffffff, 1);
			bar.graphics.drawRect(0, 0, _width - 53*2 - 10, 20);
			bar.graphics.endFill();
			bar.x = 53*2 + 5
			bar.y = 17
			tabPlayer.addChild(bar);
			
			
			scroller.graphics.beginFill(0xffffff, 1);
			scroller.graphics.drawRect(0, 0, 15, 40);
			scroller.graphics.endFill();
			scroller.x = 53*2 + 5
			scroller.y = 6
			tabPlayer.addChild(scroller);
			
			scroller.addEventListener(TouchEvent.TOUCH, drag);
			
			tabPlayer.y = _height - 53;
			tabPlayer.alpha = 1;
			
			TweenMax.delayedCall(2, volta)
				
			addChild(tabPlayer);
			
		}
		
		private function drag(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as Shape, TouchPhase.BEGAN)){
				//var touch:Touch = evt.getTouch(this, TouchPhase.BEGAN);
				//var localPos:Point = touch.getLocation(this);
				//trace("Touched object at position: " + localPos);
				timer.stop();
			}
			
			if(evt.getTouch(evt.currentTarget as Shape, TouchPhase.MOVED)){
				var touch:Touch = evt.getTouch(this);
				var localPos:Point = touch.getLocation(this);
				
				if(localPos.x>110 && localPos.x<_width){
					(evt.currentTarget as Shape).x = localPos.x-7;
				}
			}
			
			if(evt.getTouch(evt.currentTarget as Shape, TouchPhase.ENDED)){
				//var touch:Touch = evt.getTouch(this, TouchPhase.BEGAN);
				//var localPos:Point = touch.getLocation(this);
				//trace("Touched object at position: " + localPos);
				netStream.seek(_duration * (scroller.x - 53 + 5)  / bar.width)
				
				//TweenMax.delayedCall(2, function():void{timer.start();});
				timer.start();
			}
			
		}		
		
		
		private function togglePlay(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				netStream.togglePause(); 
				
				if(playing){
					timer.stop();
					removeChild(pauseBtn);
					pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					
					playBtn = new MyImageLoader2({idM:0, idI:1});
					
					playBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					
					tabPlayer.addChild(playBtn);
					
					playing = false;
					
				}else{

					timer.start();
					removeChild(playBtn);
					playBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					
					pauseBtn = new MyImageLoader2({idM:0, idI:2});
					
					pauseBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					
					tabPlayer.addChild(pauseBtn);
					playing = true;
				}
			}
		}
		
		private function toggleStop(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				
				if(playing){
					timer.stop();
					scroller.x = 53*2 + 5
						
					removeChild(pauseBtn);
					pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
					
					playBtn = new MyImageLoader2({idM:0, idI:1});
					
					playBtn.addEventListener(TouchEvent.TOUCH, togglePlay);
					
					tabPlayer.addChild(playBtn);
					
					playing = false;
					
					netStream.pause(); 
					netStream.seek(0); 
					
				}else{
					
					netStream.pause(); 
					netStream.seek(0); 
					
				}
				
				
			}
		}
		
		private function videoCarregado():void{
			//this.dispatchEventWith(FINISHED, false, '');
		}

		public function build():void{
			criaComponentes();
		}
		
		public function unBuild(evt:MouseEvent):void{
			trace('UNBUILD VIDEO');
			try{
				texture.dispose();
				video.dispose();
			}catch(err){};
		}
		
		//------------------------------------------------------- Dispose Menu
		override public function dispose():void{
			trace('DISPOSE');
			try{
				netStream.close();
				netConnection.close();
			}catch(err){};
			
			try{
				netStream.dispose();
				texture.dispose();
				video.dispose();
			}catch(err){};
			
			timer.stop();
			
			try{
				removeChild(pauseBtn);
				pauseBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
			}catch(err){};
			
			try{
				removeChild(playBtn);
				playBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
			}catch(err){};
			
			try{
				removeChild(stopBtn);
				stopBtn.removeEventListener(TouchEvent.TOUCH, togglePlay);
			}catch(err){};
			
			try{
				quadplayer.dispose();
				scroller.dispose();
				bar.dispose();
				
				removeChild(tabPlayer);
			}catch(err){};

		}
	}
}
