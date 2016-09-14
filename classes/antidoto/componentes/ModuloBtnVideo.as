package classes.antidoto.componentes
{
	
	import com.greensock.TweenMax;
	
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
	import classes.antidoto.propagaEvento;
	
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	//------------------------------------------------------- Eventos de retorno de função
	[Event(name="openPage",type="starling.events.Event")]
	[Event(name="cargaCompleta",type="starling.events.Event")]

	public class ModuloBtnVideo extends starling.display.Sprite
	{
		public static const OPEN_PAGE:String = "openPage";
		public static const FINISHED:String = "cargaCompleta";
		public static const DISPOSED:String = "disposed";

		private var modulo_imagem:MyImageLoader;
		
		private var r:Main;
		private var quad:Shape;
		private var quadplayer:Shape;
		
		private var xis:MyImageLoader2;
		private var _image:String;
		
		private var _props:Object;

		
		
		private var playing:Boolean = true;
		
		private var playBtn:MyImageLoader2;
		private var stopBtn:MyImageLoader2;
		private var pauseBtn:MyImageLoader2;
		
		private var _id:*;
		private var _xml:XMLList;
		
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		
		private var texture:Texture;
		private var video:Image;
		
		private var item:String;
		
		public var w:Number;
		public var h:Number;
		
		private var canvas:Canvas;
		
		private var pressed:Boolean = false;;
		
		private var _duration:Number = 0;
		
		private var timer:Timer = new Timer(1, 0)
		private var scroller:Shape = new Shape();
		
	//	private var timer:Timer = new Timer(100, 0);

		public function ModuloBtnVideo(props:Object)
		{
			_props = props;
			
			for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
			{
				//trace ("itemCount " + itemData.localName()); 
				item = itemData.localName();
			}
			
			
			
			_props = props;
			
			
			//trace('dentro ' + item);
			if(item == 'item'){
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo;
			}
			
			trace('comecou a criar o video: ' + _props.idM+ ' - ' + _props.idI+ ' - ' + _props.idT);
			
			canvas = new Canvas()
			canvas.beginFill(0xff0000);
			canvas.drawRectangle(0,0,628,345);
			canvas.endFill();
			
			
			
			initializeHandler()
			
			
			addEventListener(TouchEvent.TOUCH, teste);
			
			
			
			
		}
		
		private function teste(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as ModuloBtnVideo, TouchPhase.ENDED)){
				trace('APERTOU!' + evt.currentTarget);
				pressed = true;
			}
			
		}		
		
		
		protected function initializeHandler():void
		{
			criaComponentes();
		}

		private function criaComponentes():void
		{

			netConnection = new NetConnection()
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			netConnection.connect(null);
			netConnection.client = { };
			netConnection.client.onMetaData = function ():void { };
			netStream = new NetStream(netConnection);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			
			trace('nome video: ' + _xml[_props.idT]);
			
			netStream.play('vds/'+_xml[_props.idT]);

			texture = Texture.fromNetStream(netStream, 1, function():void
			{
				video = new Image(texture)
				
				h = video.height/2;
				w = video.width/2;
				
				video.x -= video.width/2;
				video.y -= video.height/2;
				
				video.mask = canvas;
				
				addChild(video);
			});
			
			scroller.graphics.beginFill(0xffffff, 1);
			scroller.graphics.drawRect(0, 0, 15, 40);
			scroller.graphics.endFill();
			scroller.x = 53*2 + 5
			scroller.y = 6
			addChild(scroller);
			
			scroller.addEventListener(TouchEvent.TOUCH, drag);
			
			
			timer.addEventListener(TimerEvent.TIMER, moveScroller)
			//timer.addEventListener(TimerEvent.TIMER, zera)
			//TweenMax.delayedCall(1, function():void{this.dispatchEventWith(FINISHED, false, '');});
				
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
				
				if(localPos.x>110 && localPos.x<video.width){
					(evt.currentTarget as Shape).x = localPos.x-7;
				}
			}
			
			if(evt.getTouch(evt.currentTarget as Shape, TouchPhase.ENDED)){
				//var touch:Touch = evt.getTouch(this, TouchPhase.BEGAN);
				//var localPos:Point = touch.getLocation(this);
				//trace("Touched object at position: " + localPos);
				netStream.seek(_duration * (scroller.x - 53 + 5)  / video.width)
				
				//TweenMax.delayedCall(2, function():void{timer.start();});
				timer.start();
			}
			
		}		
		
		protected function moveScroller(event:TimerEvent):void
		{
			scroller.x = (53*2 + 5) + (video.width-14) * (netStream.time / _duration)
			//trace('PORCENT: ' + netStream.time / _duration * 100);
			
		}
		
		private function zera(evt:TimerEvent):void{
			if(netStream.time == .005){
				netStream.seek(0)
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
					//timer.start();
					this.dispatchEventWith(FINISHED, false, '');
					//getStuff();
					
					break; 
				case "NetStream.Play.Stop": 
					//netStream.play('vds/'+_xml[_props.idT]);
				//	netStream.seek(0)
					//trace('stop');
					//close();
					
					break; 
				
				case "NetStream.Buffer.Empty": 
					//netStream.play('vds/'+_xml[_props.idT]);
					netStream.seek(0)
					//trace('stop');
					//close();
					
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

			}catch(err){};

		}
		
		//------------------------------------------------------- Dispose Menu
		override public function dispose():void{
			
			
			
			removeEventListener(TouchEvent.TOUCH, teste);
			
			//video.stop();
			if(pressed){
				//trace('btn index salvo!!! ======================== ' + _props.idT);
				globalVars.cadastro2[_xml[_props.idT].@vr] = _xml[_props.idT].@index;
			}
			
			try{
				netStream.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				netStream.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			}catch(err){};
			
			try{
				netStream.close();
				netConnection.close();
				netStream = null;
				netConnection = null;
			}catch(err){};
			
			try{
				canvas.clear();
				video.dispose();
			}catch(err){};
			
			try{
				texture.dispose();
			}catch(err){};


		}
	}
}
