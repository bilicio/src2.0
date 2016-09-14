﻿package classes.antidoto {
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import app.Main;
	
	import classes.antidoto.globalVars;
	
	import feathers.display.TiledImage;
	
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;
	import org.as3commons.zip.ZipLibrary;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.RotateGesture;
	import org.gestouch.gestures.TransformGesture;
	import org.gestouch.gestures.ZoomGesture;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class MyImageLoader2 extends Sprite{
		
		private var ldr:Loader;
		private var loaderInfo:LoaderInfo;
		private var bitmapData:BitmapData;
		//private var bitmap:Bitmap;
		public var img:*;
		public var img2:Image;
		private var _image:String;
		private var texture:Texture ;
		
		public var _width:Number;
		public var _height:Number;
		private var _tiled:Boolean;
		private var _transition:String;
		private var _multitouch:Boolean = false;
		public var _id:*;
		
		private var spMask:Sprite;
		
		public var _props:Object;
		
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
		
		private var _xmlModuleImage:*;
		//private var r:Main;
		
		private var gVars:globalVars;
		
		private var item:String;
		
		private var _textureZIP:Texture;
		
		private var quad:Shape;
		
		private var quadMask:starling.display.Quad;
		
		public function MyImageLoader2(props:Object) {
			for each(var itemData:XML in globalVars.xml.menu[props.idM].modulo[props.idI].elements()) 
			{
				//trace ("itemCount " + itemData.localName()); 
				item = itemData.localName();
			}
			
			//trace('ok');
			//trace('PROPS: ' + globalVars.xml.menu[props.idM].modulo[props.idI].@img);
			
			if(item == 'item' && props.idT != 'none'){
				//trace('dentro');
				_xmlModuleImage = globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT]
				//trace('get: ' + _xmlModuleImage + " vars: " + props.idM + " - " + props.idI + " - " + props.idT + " - " + props.idW);
				
				if(_xmlModuleImage.@img != "" && !props.max){
					//trace('false');
					//trace('aqui: ' + _xmlModuleImage);
					_image = _xmlModuleImage.@img;
				}else{
					//trace('true');
					_image = _xmlModuleImage.@img2;
				}
			}else{
				_xmlModuleImage = globalVars.xml.menu[props.idM].modulo[props.idI]
					//trace('dentro2');
				if(_xmlModuleImage.@tipo == "imagem" || _xmlModuleImage.@tipo == "gif" || _xmlModuleImage.@tipo == "btn"){
					_image = _xmlModuleImage.@img2;
					//trace('aqui: ' + _xmlModuleImage.@img2);
				}else{
					//trace('aqui: ' + _xmlModuleImage.@img2);
				//	trace('aqui: ' + props.idI);
					_image = _xmlModuleImage.@img;
				}
			}
			
			if(props.idW != undefined){
				//trace('aqui');
				//TIMELINE _xmlModuleImage = globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].item[0].modulo[props.idW];
				_xmlModuleImage = globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT];
				if(props.max){
					//trace('get: ' + _xmlModuleImage + " vars: " + props.idM + " - " + props.idI + " - " + props.idT + " - " + props.idW);
					_image = _xmlModuleImage.@img2;
				}else{
					//trace('get: ' + _xmlModuleImage + " vars: " + props.idM + " - " + props.idI + " - " + props.idT + " - " + props.idW);
					_image = _xmlModuleImage.@img;
				}
			}

			ldr = new Loader();
			
			_props = props;
			
			//getProps(props);
			try{
				//trace('imagem1: ' + _xmlModuleImage.@img);
				//trace('imagem2: ' + _xmlModuleImage.@img2);
			}catch(err:Error){};
			
			try{
				_imagePos = _props.imagePos;
			}catch(err){}
			
			
			

			xmlTitle = Assets.am.getXml("settings");
			
			if(globalVars.xml.@zip == 'none'){
				if(props.getTexture == "true"){
					returnTexture(globalVars.zipFile);
				}else{
					loaderToBitmapZip(globalVars.zipFile);
					
				}
				
				
				
			}else{
				urlImages = new URLRequest(File.documentsDirectory.resolvePath(props.zip + ".zip").url);
				
				zip = new Zip();
				zip.addEventListener(flash.events.Event.COMPLETE, loading);
				zip.load(urlImages);
			}
		}
		
		private function loading(evt:flash.events.Event):void{

			zip.removeEventListener(flash.events.Event.COMPLETE, loading);
			
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
		
		public function get textureZIP():Texture
		{
			return _textureZIP;
		}
		
		protected function loaderToBitmap(event:flash.events.Event):void
		{
			
			ldr.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loaderToBitmap);
			
			loaderInfo = LoaderInfo(event.target);
			bitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, true, 0x000000);
			bitmapData.draw(loaderInfo.loader);
			
			texture = Texture.fromBitmapData(bitmapData);
			
			if(_xmlModuleImage.@tiled == "true"){
				img = new Image( texture );
				img.tileGrid = new Rectangle();
				img.width = _width;
				img.height = _height;
			}else{
				
				img = new Image( texture )
			}
			
			if(_xmlModuleImage.@multitouch == "true"){
				
				transformGesture = new TransformGesture(img);
				transformGesture.addEventListener(GestureEvent.GESTURE_BEGAN, BEGAN);
				transformGesture.addEventListener(GestureEvent.GESTURE_CHANGED, CHANGED);
				
				img.pivotX = img.x = img.width/2;
				img.pivotY = img.y = img.height/2;
				
				spMask = new Sprite();
				spMask.addChild(img);
				
				//trace('CLIP: ' + _clip);
				if(_xmlModuleImage.@clip == 'true'){
					//spMask.clipRect = new Rectangle(0, 0, img.width, img.height);
					quadMask = new starling.display.Quad(img.width, img.height);
					//quad.y = 0;
					spMask.mask = quadMask;
				}
			}else{
				
				spMask = new Sprite();
				spMask.addChild(img);
			}
			
			try{
				
				var verString:String = String(_xmlModuleImage.@transition);
				
				switch(String(_xmlModuleImage.@transition)){
					
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
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.y = img.height;
							spMask.mask = quadMask;
							img.y = -img.height;
							TweenLite.to(img, velAnimation, {y:0, onComplete:releaseEvent});
						}else{
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							img2.x = -img.width/2;
							img2.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width;
							this.y += img.height*2;
							
							TweenLite.to(img, velAnimation, {y:0, onComplete:releaseEvent});
							
							releaseEvent();
						}
						break;
					
					case "posFromLeft" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask
							img.x = -img.width;
							TweenLite.to(img, velAnimation, {x:0, onComplete:releaseEvent});
						}else{
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							img2.x = -img.width/2;
							img2.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x -= img.width;
							this.y += img.height;
							
							TweenLite.to(img, velAnimation, {x:0, onComplete:releaseEvent});
							
							releaseEvent();
						}
						break;
					
					case "posFromRight" :
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
						img.x = img.width;
						TweenLite.to(img, velAnimation, {x:0, onComplete:releaseEvent});
						break;
					
					case "posFromBottom" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							img.y = img.height;
							TweenLite.to(img, velAnimation, {y:0, onComplete:releaseEvent});
						}else{

							img.x = -img.width/2;
							img.y = -img.height/2;
							
							img2.x = -img.width/2;
							img2.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width;
							this.y += img.height*2;
							
							TweenLite.to(img, velAnimation, {y:0, onComplete:releaseEvent});
							
							releaseEvent();
						}
						
						break;
					
					case "scaleFromCenter" :
						img.x = -img.width/2;
						img.y = -img.height/2;
						
						img2.x = -img.width/2;
						img2.y = -img.height/2;
						
						quadMask = new starling.display.Quad(img.width, img.height);
						quadMask.x = -img.width/2;
						quadMask.y = -img.height/2;
						spMask.mask = quadMask;
						
						this.x += img.width;
						this.y += img.height;
						
						releaseEvent();
						
						break;
					
					
					
					case "alpha" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							img.alpha = 0;
							TweenLite.to(img, velAnimation, {alpha:1, onComplete:releaseEvent});
						}else{
							
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							img2.x = -img.width/2;
							img2.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width;
							this.y += img.height;
							
							TweenLite.to(img, velAnimation, {alpha:1, onComplete:releaseEvent});
							
							releaseEvent();
						}
						break;
					
					case "none" :
						//trace('NONE-1')
						releaseEvent();
						break;
					
					default :
						
						//trace('NONE')
						releaseEvent();
						//quadMask = new starling.display.Quad(img.width, img.height);
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
			
			//trace(file + " | " + _image);
			
			//bitmapData = new BitmapData(0,0);
			
			var image:BitmapData = bitmapData = file.getBitmapData(_image);
			//trace("Size: " + image.width + "x" + image.height);
			//image.applyFilter(image, new Rectangle(0, 0, image.width, image.height), new Point(0, 0), new flash.filters.BlurFilter(4, 4, 1));
			
			
			texture = Texture.fromBitmapData(image);
			
			
			//trace('trace -> ' + _xmlModuleImage);
			if(_xmlModuleImage != undefined){
				if(_xmlModuleImage.@tiled == "true"){
					img = new Image( texture );
					img.tileGrid = new Rectangle(); 
					img.width = _width;
					img.height = _height;
				}else{
					
					img = new Image( texture );
					img2 = new Image( texture );
				}
			}else{
				img = new Image( texture );
				img2 = new Image( texture );
			}
			
			//trace('width1: ' + image.width);
			this.width = image.width;
			if(_xmlModuleImage != undefined){
				//if(_xmlModuleImage.@multitouch == "true" && _props.max == true){
				if(_xmlModuleImage.@multitouch == "true"){
					
					//trace('TRansform Multitouch - BEGAN');
					
					transformGesture = new TransformGesture(img);
					transformGesture.addEventListener(GestureEvent.GESTURE_BEGAN, BEGAN);
					transformGesture.addEventListener(GestureEvent.GESTURE_CHANGED, CHANGED);
					
					img.pivotX = img.x = img.width/2;
					img.pivotY = img.y = img.height/2;
					
					img2.pivotX = img.x = img.width/2;
					img2.pivotY = img.y = img.height/2;
					
					img2.x = img.x;
					img2.y = img.y;
					
					spMask = new Sprite();
					spMask.addChild(img);
					spMask.addChild(img2);
					
					img2.touchable = false;
					
					img.alpha = 0;
					//img2.alpha = 0;
					//var zoom:ZoomGesture = new ZoomGesture(img);
					//zoom.addEventListener(GestureEvent.GESTURE_BEGAN, go, false, 0, true);
					
					
					if(_xmlModuleImage.@clip == 'true'){
						quadMask = new starling.display.Quad(img.width, img.height);
						spMask.mask = quadMask;
					}
				}else{
					
					
					spMask = new Sprite();
					spMask.addChild(img);
				}
			}else{
				spMask = new Sprite();
				spMask.addChild(img);
			}
			
			//	trace("TRANSICAO: "  + String(_props.transition));
			
			try{
				
				var verString:String = String(_xmlModuleImage.@transition);
				
			//	trace("TRANSICAO: "  + verString);
				
				switch(verString){
					
					case "maskFromLeft" :
						quadMask = new starling.display.Quad(0, img.height);
						spMask.mask = quadMask;
						TweenLite.to(spMask.mask, velAnimation, {width:img.width});
						break;
					
					case "maskFromRight" :
						quadMask = new starling.display.Quad(0, img.height);
						quadMask.x = img.width;
						spMask.mask = quadMask;
						
						TweenLite.to(spMask.mask, velAnimation, {x:0, width:img.width});
						break;
					
					case "maskFromTop" :
						quadMask = new starling.display.Quad(img.width, 0);
						spMask.mask = quadMask;

						TweenLite.to(spMask.mask, velAnimation, {height:img.height});
						break;
					
					case "maskFromBottom" :
						quadMask = new starling.display.Quad(img.width, 0);
						quadMask.y = img.height;
						spMask.mask = quadMask;

						TweenLite.to(spMask.mask, velAnimation, {y:0, height:img.height});
						break;
					
					case "posFromTop" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							TweenLite.from(img, velAnimation, {y:-img.height});
						}else{
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							
							this.x += img.width*2;
							this.y += img.height*2;
							
							TweenLite.from(img, velAnimation, {y:-img.height});
							
							releaseEvent();
						}
						break;
					
					case "posFromLeft" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							TweenLite.from(img, velAnimation, {x:-img.width});
						}else{
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width*2;
							this.y += img.height*2;
							
							TweenLite.from(img, velAnimation, {x:-img.width});
							
							releaseEvent();
						}
						break;
					
					case "posFromRight" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							TweenLite.from(img, velAnimation, {x:img.width});
						}else{
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width*2;
							this.y += img.height*2;
							
							TweenLite.from(img, velAnimation, {x:img.width});
							
							releaseEvent();
						}
						break;
					
					case "posFromBottom" :
						if(_xmlModuleImage.@tipo != 'btn'){
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							TweenLite.from(img, velAnimation, {y:img.height});
						}else{
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width*2;
							this.y += img.height*2;
							
							TweenLite.from(img, velAnimation, {y:img.height});
							
							releaseEvent();
						}
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
						
						if(_xmlModuleImage.@tipo == 'btn'){
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width/2;
							this.y += img.height/2;
							
							this.alpha = 0;
							//TweenLite.to(img, velAnimation, {alpha:1});
							
						}else{					
						
							quadMask = new starling.display.Quad(img.width, img.height);
							spMask.mask = quadMask;
							img.alpha = 0;
							TweenLite.to(img, velAnimation, {alpha:1});
						}
						break;
					
					case "elastic" :
						
						if(_xmlModuleImage.@tipo == 'btn'){
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width/2;
							this.y += img.height/2;
							
							img.alpha = 1;
							TweenLite.to(img, velAnimation, {alpha:1});
							
						}else{	
							img.alpha = 0;
							TweenLite.to(img, .3, {alpha:1, delay:.1});
							
							img.x = -img.width/2;
							img.y = -img.height/2;
							
							quadMask = new starling.display.Quad(img.width, img.height);
							quadMask.x = -img.width/2;
							quadMask.y = -img.height/2;
							spMask.mask = quadMask;
							
							this.x += img.width/2;
							this.y += img.height/2;

							//quadMask = new starling.display.Quad(img.width, img.height);spMask.mask = quadMask;
							this.alpha = 0;
							TweenMax.fromTo(this, .3, {scaleX:1, scaleY:1, alpha:1, yoyo:true, repeat:1, ease:com.greensock.easing.Quad.easeInOut},{scaleX:.8, scaleY:.8, yoyo:true, repeat:1, ease:com.greensock.easing.Quad.easeInOut});
							//TweenLite.to(img, velAnimation, {alpha:1});
						}
						break;
					
					case "none" :
						
						//trace('loaded');
						releaseEvent();
						break;
					
					default :
						
						//trace('NONE')
						releaseEvent();
						//quadMask = new starling.display.Quad(img.width, img.height);spMask.mask = quadMask;
						break;
				}
				
				TweenMax.delayedCall(.02, releaseEvent);
				
				
			}catch(e:Error){
				quadMask = new starling.display.Quad(img.width, img.height);
				spMask.mask = quadMask;
				TweenMax.delayedCall(.02, releaseEvent);
			}
			
			
			//Starling.juggler.tween(spMask.filter, 1.5, { blurX: 2.0, blurY: 2.5 });
			
			//addChild(img);
			addChild(spMask);

			clear();
		}
		
		
		/*private function go(event:GestureEvent):void{
			trace();
		}*/
		
		private function returnTexture(file):void{
			var image:BitmapData = bitmapData = file.getBitmapData(_image);
			texture = Texture.fromBitmapData(image);
			
			_textureZIP = texture;
			
			TweenMax.delayedCall(.2, releaseEvent);
		}
		
		private function releaseEvent():void{
			
			//trace('releas O');
			
			TweenMax.delayedCall(.05, delayCall);
			//this.dispatchEventWith(propagaEvento.IMAGELOADED, false);
			//dispatchEvent(new starling.events.Event('Imagem.CARREGADA'));
			//dispatchEvent(new Event("TESTE"));
		}
		
		private function delayCall():void{
			try{
				_width = img.width;
				_height = img.height;
			}catch(err){};
			//trace('widthPOS: ' + this.width);
			this.dispatchEventWith(propagaEvento.IMAGELOADED, false);
		}
		
		private var touches:Number = 0;
		
		private function BEGAN(event:GestureEvent):void
		{
			
			//trace('Multitouch - BEGAN');
			const gesture:TransformGesture = event.target as TransformGesture;
			
			if(gesture.touchesCount == 1){
				touches = 1;
			}else{
				touches = 2;
			}
			
			
		}
		
		private var tween:TweenMax
		
		
		private function CHANGED(event:GestureEvent):void
		{
			
			const gesture:TransformGesture = event.target as TransformGesture;
			
			//trace('COUNT: ' + gesture.state);
			
			gesture.slop = 1;
			
			img.x += transformGesture.offsetX;
			img.y += transformGesture.offsetY;
			
			if (touches == 2)
			{
				//trace('MORE TOUCH');
				var target:DisplayObject = gesture.target as DisplayObject;
				
				var m:Matrix = target.getTransformationMatrix(target.parent);
				
				var transformPoint:Point = m.transformPoint(target.globalToLocal(gesture.location));
				m.translate(-transformPoint.x, -transformPoint.y);
				
				if(_xmlModuleImage.@rotation == 'true'){
					trace('rotation: ' + gesture.rotation);
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
			
			updateIMG2(gesture.rotation)
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
			}*/s
			
			// ------------------------------------------------------------------------------------- | Como implementar o Gestouch
			
			//trace("OFFSETX: " + transformGesture.offsetX + " \n" +"OFFSETY: " +transformGesture.offsetY+ " \n" +"ROTATION: " +transformGesture.rotation+ " \n" +"SCALE: " + transformGesture.scale+ " \n ");
		}
		
		private function updateIMG2(gesture):void
		{
			//trace("rotation: " + img.rotation + " gesture: " + gesture);
			try{
				if(!TweenMax.isTweening(img2)){
					tween = TweenMax.to(img2, .5, {scaleX:img.scaleX, scaleY:img.scaleY, x:img.x, y:img.y, rotation:img.rotation});
				}else{
					tween.updateTo({scaleX:img.scaleX, scaleY:img.scaleY, rotation:img.rotation, x:img.x, y:img.y},true);
				}
			}catch(err){};
		}
		
		/*private function getProps():void{
		_xmlModuleImage.@multitouch
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
		}*/
		
		public function clear():void{
			
			ldr.unload();
			ldr = null;
			loaderInfo = null;
			
			//bitmap = null;
			//spMask.dispose();
			//img.dispose();
			
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
				img2.dispose();
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


