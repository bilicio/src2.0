package classes.antidoto {
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import feathers.display.TiledImage;
	
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;
	import org.as3commons.zip.ZipLibrary;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TransformGesture;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	public class MyImageLoader extends Sprite{
		
		private var ldr:Loader;
		private var loaderInfo:LoaderInfo;
		private var bitmapData:BitmapData;
		//private var bitmap:Bitmap;
		private var img:*;
		private var _image:String;
		private var texture:Texture ;
		
		public var _width:Number;
		private var _tiled:Boolean;
		private var _transition:String;
		private var _multitouch:Boolean = false;
		public var _id:*;
		
		private var spMask:Sprite;
		
		private var _props:Object;
		
		private var zip:Zip;
		private var zipe:ZipFile;
		private var byte:ByteArray;
		
		private var xmlTitle:XML;
		
		private var velAnimation:Number = 1;
		
		private var transformGesture:TransformGesture;
		
		private var urlImages:URLRequest;
		
		private var _zipFile:ZipLibrary;
		private var _type:String;
		
		private var _tela:String;
		
		public var _imagePos:Number;
		private var _clip:String;
		private var _rotation:String;
		
		private var quadMask:starling.display.Quad;
		
		public function MyImageLoader(img:String, props:Object = undefined) {
			ldr = new Loader();
			
			_props = props;
			
			getProps(props);
			
			try{
				_imagePos = _props.imagePos;
			}catch(err){}
			
			_image = img;
			
			//	trace('PROPS: ' + _props.zipFile);
			
			xmlTitle = Assets.am.getXml("settings");
			
			if(props.zip == 'none'){
				loaderToBitmapZip(_props.zipFile);
			}else{
				urlImages = new URLRequest(File.documentsDirectory.resolvePath(props.zip + ".zip").url);
				
				zip = new Zip();
				zip.addEventListener(flash.events.Event.COMPLETE, loading);
				zip.load(urlImages);
			}
			
			
		}
		
		private function loading(evt:flash.events.Event):void{
			
			//trace(zipe.si);
			//try{
			zip.removeEventListener(flash.events.Event.COMPLETE, loading);
			//}catch(err){};
			
			zipe = new ZipFile();
			byte = new ByteArray();
			
			zipe = zip.getFileByName(_image);
			
			try{
				zipe.serialize(byte,false);
			}catch(err){trace('FALHA NA IMAGEM: ' + _image);};
			
			//ldr = new Loader();
			
			try{
				ldr.loadBytes(zipe.content);
			}catch(err){};
			
			ldr.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loaderToBitmap);
			
			//trace('carregada: ' + _image);
		}
		
		public function get tela():String
		{
			return this._tela;
		}
		
		public function get vars():Object
		{
			return this._props;
		}
		
		public function get imagePos():Number
		{
			return _imagePos;
		}
		
		public function get id():*
		{
			return _id;
		}
		
		protected function loaderToBitmap(event:flash.events.Event):void
		{
			
			ldr.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loaderToBitmap);
			
			loaderInfo = LoaderInfo(event.target);
			bitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, true, 0x000000);
			bitmapData.draw(loaderInfo.loader);
			
			texture = Texture.fromBitmapData(bitmapData);
			
			if(_tiled){
				img = new Image( texture );
				img.tileGrid = new Rectangle();
				img.width = _width;
			}else{
				
				img = new Image( texture )
			}
			
			if(_multitouch){
				
				transformGesture = new TransformGesture(img);
				transformGesture.addEventListener(GestureEvent.GESTURE_BEGAN, BEGAN);
				transformGesture.addEventListener(GestureEvent.GESTURE_CHANGED, CHANGED);
				
				img.pivotX = img.x = img.width/2;
				img.pivotY = img.y = img.height/2;
				
				spMask = new Sprite();
				spMask.addChild(img);
				
				trace('CLIP: ' + _clip);
				if(_clip == 'true'){
					quadMask = new starling.display.Quad(img.width, img.height);
					spMask.mask = quadMask;
				}
			}else{
				
				spMask = new Sprite();
				spMask.addChild(img);
			}
			
			try{
				
				var verString:String = String(_props.transition);
				
				switch(String(_props.transition)){
					
					case "maskFromLeft" :
						quadMask = new starling.display.Quad(0, img.height);
						quadMask.y = 0;
						spMask.mask = quadMask;
						TweenLite.to(spMask.mask, velAnimation, {width:img.width, onComplete:releaseEvent});
						break;
					
					case "maskFromRight" :
						quadMask = new starling.display.Quad(0, img.height);
						quadMask.x = img.width;
						spMask.mask = quadMask
						TweenLite.to(spMask.mask, velAnimation, {x:0, width:img.width, onComplete:releaseEvent});
						break;
					
					case "maskFromTop" :
						quadMask = new starling.display.Quad(img.width, 0);
						//quadMask.x = img.width;
						spMask.mask = quadMask
						TweenLite.to(spMask.mask, velAnimation, {height:img.height, onComplete:releaseEvent});
						break;
					
					case "maskFromBottom" :
						quadMask = new starling.display.Quad(img.width, 0);
						quadMask.y = img.height;
						spMask.mask = quadMask
						TweenLite.to(spMask.mask, velAnimation, {y:0, height:img.height, onComplete:releaseEvent});
						break;
					
					case "posFromTop" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.y = -img.height;
						TweenLite.to(img, velAnimation, {y:0, onComplete:releaseEvent});
						break;
					
					case "posFromLeft" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.x = -img.width;
						TweenLite.to(img, velAnimation, {x:0, onComplete:releaseEvent});
						break;
					
					case "posFromRight" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.x = img.width;
						TweenLite.to(img, velAnimation, {x:0, onComplete:releaseEvent});
						break;
					
					case "posFromBottom" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.y = img.height;
						TweenLite.to(img, velAnimation, {y:0, onComplete:releaseEvent});
						break;
					
					case "scaleFromCenter" :
						img.x = -img.width/2;
						img.y = -img.height/2;
						
						quadMask = new starling.display.Quad(img.width, img.height);
						quadMask.x = -img.width/2;
						quadMask.y = -img.height/2;
						spMask.mask = quadMask;
						
						this.x += img.width;
						this.y += img.height;
						
						releaseEvent();
						
						break;
					
					
					
					case "alpha" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.alpha = 0;
						TweenLite.to(img, velAnimation, {alpha:1, onComplete:releaseEvent});
						break;
					
					case "none" :
						//trace('NONE-1')
						releaseEvent();
						break;
					
					default :
						
						//trace('NONE')
						releaseEvent();
						//quadMask = new starling.display.Quad(img.width, img.height);
						//spMask.mask = quadMask;
						break;
				}
				
				
				
			}catch(e:Error){
				quadMask = new starling.display.Quad(img.width, img.height);
				spMask.mask = quadMask;
			}
			
			//addChild(img);
			addChild(spMask);
			
			clear();
		}
		
		protected function loaderToBitmapZip(file):void
		{
			
			trace(file + " | " + _image);
			
			//bitmapData = new BitmapData(0,0);
			
			var image:BitmapData = bitmapData = file.getBitmapData(_image);
			//trace("Size: " + image.width + "x" + image.height);
			//image.applyFilter(image, new Rectangle(0, 0, image.width, image.height), new Point(0, 0), new flash.filters.BlurFilter(4, 4, 1));
			
			
			texture = Texture.fromBitmapData(image);
			
			if(_tiled){
				img = new Image( texture );
				img.tileGrid = new Rectangle();
				img.width = _width;
			}else{
				
				img = new Image( texture )
			}
			
			//trace('width1: ' + image.width);
			this.width = image.width;
			
			if(_multitouch){
				
				transformGesture = new TransformGesture(img);
				transformGesture.addEventListener(GestureEvent.GESTURE_BEGAN, BEGAN);
				transformGesture.addEventListener(GestureEvent.GESTURE_CHANGED, CHANGED);
				
				img.pivotX = img.x = img.width/2;
				img.pivotY = img.y = img.height/2;
				
				spMask = new Sprite();
				spMask.addChild(img);
				
				
				if(_clip == 'true'){
					quadMask = new starling.display.Quad(img.width, img.height);
					spMask.mask = quadMask;
				}
			}else{
				
				spMask = new Sprite();
				spMask.addChild(img);
			}
			
			//	trace("TRANSICAO: "  + String(_props.transition));
			
			try{
				
				var verString:String = String(_props.transition);
				
				switch(String(_props.transition)){
					
					case "maskFromLeft" :
						quadMask = new starling.display.Quad(0, img.height);
						quadMask.y = 0;
						spMask.mask = quadMask;
						TweenLite.to(spMask.mask, velAnimation, {width:img.width});
						break;
					
					case "maskFromRight" :
						quadMask = new starling.display.Quad(0, img.height);
						quadMask.x = img.width;
						spMask.mask = quadMask
						TweenLite.to(spMask.mask, velAnimation, {x:0, width:img.width});
						break;
					
					case "maskFromTop" :
						quadMask = new starling.display.Quad(img.width, 0);
						//quadMask.x = img.width;
						spMask.mask = quadMask
						TweenLite.to(spMask.mask, velAnimation, {height:img.height});
						break;
					
					case "maskFromBottom" :
						quadMask = new starling.display.Quad(img.width, 0);
						quadMask.y = img.height;
						spMask.mask = quadMask
						TweenLite.to(spMask.mask, velAnimation, {y:0, height:img.height});
						break;
					
					case "posFromTop" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						TweenLite.from(img, velAnimation, {y:-img.height});
						break;
					
					case "posFromLeft" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						TweenLite.from(img, velAnimation, {x:-img.width});
						break;
					
					case "posFromRight" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						TweenLite.from(img, velAnimation, {x:img.width});
						break;
					
					case "posFromBottom" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						TweenLite.from(img, velAnimation, {y:img.height});
						break;
					
					case "scaleFromCenter" :
						img.x = -img.width/2;
						img.y = -img.height/2;
						
						quadMask = new starling.display.Quad(img.width, img.height);
						quadMask.x = -img.width/2;
						quadMask.y = -img.height/2;
						spMask.mask = quadMask;
						
						this.x += img.width/2;
						this.y += img.height/2;
						
						releaseEvent();
						
						break;
					
					case "rotation" :
						
						//trace('ROTACIONANDO');
						
						img.x = -img.width/2;
						img.y = -img.height/2;
						
						quadMask = new starling.display.Quad(img.width, img.height);
						quadMask.x = -img.width/2;
						quadMask.y = -img.height/2;
						spMask.mask = quadMask;
						
						this.x += img.width/2;
						this.y += img.height/2;
						
						releaseEvent();
						
						break;
					
					case "alpha" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.alpha = 0;
						TweenLite.to(img, velAnimation, {alpha:1});
						break;
					
					case "none" :
						//trace('NONE-1')
						releaseEvent();
						break;
					
					default :
						
						//trace('NONE')
						releaseEvent();
						//quadMask = new starling.display.Quad(img.width, img.height);
						//spMask.mask = quadMask;
						break;
				}
				
				TweenMax.delayedCall(.2, releaseEvent);
				
				
			}catch(e:Error){
				quadMask = new starling.display.Quad(img.width, img.height);
				spMask.mask = quadMask;
			}
			
			
			//Starling.juggler.tween(spMask.filter, 1.5, { blurX: 2.0, blurY: 2.5 });
			
			//addChild(img);
			addChild(spMask);
			
			
			
			clear();
		}		
		
		private function releaseEvent():void{
			
			//trace('releas O');
			
			TweenMax.delayedCall(.05, delayCall);
			//this.dispatchEventWith(propagaEvento.IMAGELOADED, false);
			//dispatchEvent(new starling.events.Event('Imagem.CARREGADA'));
			//dispatchEvent(new Event("TESTE"));
		}
		
		private function delayCall():void{
			_width = img.width;
			//trace('widthPOS: ' + this.width);
			this.dispatchEventWith(propagaEvento.IMAGELOADED, false);
		}
		
		private var touches:Number = 0;
		
		private function BEGAN(event:GestureEvent):void
		{
			const gesture:TransformGesture = event.target as TransformGesture;
			
			if(gesture.touchesCount == 1){
				touches = 1;
			}else{
				touches = 2;
			}
			
			
		}
		
		private function CHANGED(event:GestureEvent):void
		{
			
			const gesture:TransformGesture = event.target as TransformGesture;
			
			//trace('COUNT: ' + gesture.state);
			
			gesture.slop = 1;
			
			img.x += transformGesture.offsetX;
			img.y += transformGesture.offsetY;
			
			if (touches != 1)
			{
				
				var target:DisplayObject = gesture.target as DisplayObject;
				
				var m:Matrix = target.getTransformationMatrix(target.parent);
				
				var transformPoint:Point = m.transformPoint(target.globalToLocal(gesture.location));
				m.translate(-transformPoint.x, -transformPoint.y);
				
				if(_rotation == 'true'){
					//trace('rotation: ' + gesture.rotation);
					m.rotate(gesture.rotation);
					target.rotation = Math.atan2(m.b, m.a);
				}
				//m.scale(transformGesture.scale, transformGesture.scale);
				m.translate(transformPoint.x, transformPoint.y);
				
				//img.transform.matrix = m;
				
				//target.x = m.tx;
				//target.y = m.ty;
				//target.rotation = Math.atan2(m.b, m.a);
				//target.scaleX = target.scaleY  = transformGesture.scale
				
				
				var minS:Number = .99;
				var maxS:Number = 2;
				var s:Number = Math.max(minS, Math.min(gesture.scale, maxS));
				m.scale(s, s);
				
				//target.scaleX = target.scaleY  = 
				var d:Number = Math.sqrt(m.a*m.a + m.b*m.b);
				
				//trace(d);
				
				if(d > maxS){
					target.scaleX = target.scaleY = maxS;
				}else if(d < minS){
					target.scaleX = target.scaleY = minS;
				}else{
					target.scaleX = target.scaleY = Math.sqrt(m.a*m.a + m.b*m.b);
				}
				
			}
			
			// ------------------------------------------------------------------------------------- | Como implementar o Gestouch
			
			/*private function onGesture(event:org.gestouch.events.GestureEvent):void
			{
			const gesture:TransformGesture = event.target as TransformGesture;
			var matrix:Matrix = image.transform.matrix;
			
			// Panning
			matrix.translate(gesture.offsetX, gesture.offsetY);
			image.transform.matrix = matrix;
			
			if (gesture.scale != 1 || gesture.rotation != 0)
			{
			// Scale and rotation.
			var transformPoint:Point = matrix.transformPoint(image.globalToLocal(gesture.location));
			matrix.translate(-transformPoint.x, -transformPoint.y);
			matrix.rotate(gesture.rotation);
			matrix.scale(gesture.scale, gesture.scale);
			matrix.translate(transformPoint.x, transformPoint.y);
			
			image.transform.matrix = matrix;
			}
			}
			
			
			private function centerImage():void
			{
			image.transform.matrix = new Matrix();
			image.x = (width - image.width) >> 1;
			image.y = (width - image.height) >> 1;
			}*/
			
			// ------------------------------------------------------------------------------------- | Como implementar o Gestouch
			
			//trace("OFFSETX: " + transformGesture.offsetX + " \n" +"OFFSETY: " +transformGesture.offsetY+ " \n" +"ROTATION: " +transformGesture.rotation+ " \n" +"SCALE: " + transformGesture.scale+ " \n ");
		}
		
		private function getProps(prop):void{
			for (var i:String in prop){
				var value:* = prop[i];
				
				switch(i){
					case 'multitouch' :
						//trace('MULTITOUCH: ' + value);
						_multitouch = value == true?true:false;
						break;
					
					case 'tiled' :
						_tiled = value == true?true:false;
						break;
					
					case 'width' :
						_width = (value as Number);
						break;
					
					case 'transition' :
						_transition = value.toString();
						break;
					
					case 'zipFile' :
						_zipFile = value;
						break;
					
					case 'type' :
						_type = value;
						break;
					
					case 'tela' :
						_tela = value;
						break;
					
					case 'id' :
						_id = value;
						break;
					
					case 'clip' :
						_clip = value;
						break;
					
					case 'rotation' :
						_rotation = value;
						break;
					
					
				}
			}
		}
		
		public function clear():void{
			
			ldr.unload();
			ldr = null;
			loaderInfo = null;
			
			//bitmap = null;
			spMask.dispose();
			img.dispose();
			
			zipe = null;
			
			try{
				byte.clear();
			}catch(err){};
			
			try{
				
			}catch(err){};
			
			xmlTitle = null;
			
			//_props = null;
			
		}
		
		public override function dispose():void{
			//bitmapData.dispose();
			//bitmapData = null
			
			try{
				texture.dispose();
				texture = null;
			}catch(err){};
			
			try{
				img.dispose();
			}catch(err){};
			
			try{
				_props = null;
			}catch(err){};
			
			try{
				spMask.removeChild(img);
			}catch(err){};
			
			try{
				removeChild(spMask);
			}catch(err){};
			
			zip = null;
			
			if(_multitouch){
				transformGesture.removeEventListener(GestureEvent.GESTURE_BEGAN, BEGAN);
				transformGesture.removeEventListener(GestureEvent.GESTURE_CHANGED, CHANGED);
			}
			
			//trace('DISPOSED');
		}
	}
}


