package classes.antidoto.componentes
{
	
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.core.mx_internal;
	
	import cc.cote.feathers.softkeyboard.KeyEvent;
	
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.data.ListCollection;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.getNextPowerOfTwo;
	
	public class ModuloBtnDynamic extends Sprite
	{
		
		
		private var _bgColor:uint;
		
		//private var img:MyImageLoader;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:XMLList;
		
		private var _h:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var _w:Number;
		
		//private var imagem:MyImageLoader;
		//private var sombra:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var fieldArr:Array = new Array();
		private var imageAvulsaArr:Array = new Array();
		
		private var _props:Object;
		
		private var cont:Number = 0;
		
		private var campo:TextInput;
		
		private var textRenderer:TextFieldTextRenderer;
		
		private var textInput:TextInput = new TextInput()
			
		private var item:String;
		
		private var ldr:MyImageLoader2;
		
		private var imgArr:Array;
		public var fieldsArr:Array = new Array();
		
		private var _keyboardSize:Number = 2;
		private var _fontSize:Number = 20;
		
		private var textFormat:TextFormat;
		
		
		
		private var modulo_campo:ModuloCampo;
		
		private var fotoTexture:Texture;
		private var fotoBlurred:Image;
		private var fotoBD:BitmapData;
		
		private var fileStream:FileStream;
		
		private var btArray:ByteArray;
		private var tempImg:BitmapData;
		
		private var smallBMD:BitmapData;
		private var result:BitmapData;
		
		private var pressed:Boolean = false;

		
		public function ModuloBtnDynamic(props:Object)
		{
			trace('--- | modulo BTNDYNAMIC');
			for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
			{
				//trace ("itemCount " + itemData.localName()); 
				item = itemData.localName();
			}
			
			//trace('issa');

			_props = props;
			
			if(item == 'item'){
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
			//	_keyboardSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@keyboardSize);
				_fontSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].@fontSize);
				
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo;
				//_keyboardSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@keyboardSize);
				_fontSize = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@fontSize);
			}
				
			_h = _xml[0].@height;
			_w = _xml[0].@width;
			
			
	
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, criaComponente);
			
			//this.addEventListener(TouchEvent.TOUCH, aperta);
			this.height = _h;
		}
		
		public function aperta(evt:TouchEvent = null):void
		{
			//if(evt.getTouch(evt.currentTarget as ModuloBtnDynamic, TouchPhase.ENDED)){

				//TweenMax.to(this, .2, {alpha:.5, ease:Quad.easeOut});
				//this.removeEventListener(TouchEvent.TOUCH, aperta);
				TweenMax.to(this, 0, {x:-1000, ease:Quad.easeOut});

				TweenMax.delayedCall(2, salvaFotoPrint)

			//}
			
		}
		
		private function salvaFotoPrint():void{
		//	if(_xml.parent().parent().@func == 'print'){
			var folder:File = new File();
			var arquivo:File;
			
				try{
					//this.flatten();
	
					trace('PRINT');
					tempImg = new BitmapData(1864, 1228);	
					var matrizSalva:Matrix = new Matrix();
					matrizSalva.scale(1.1381,1.1381);
					//matrizSalva.scale(1,1.1382);
					//matrizSalva.translate(0,+100);
					//tempImg.draw(copyAsBitmapData(this) ,matrizSalva, null, null, null, true);
					tempImg.draw(copyAsBitmapData(this,true,0x000000,1864,1228) ,matrizSalva, null, null, null, true);
					
					var jpg:JPGEncoder = new JPGEncoder(100);
					btArray = jpg.encode(tempImg);
					
				}catch(err){}
					
				try{
					arquivo = folder.resolvePath("C:\\xampp\\htdocs\\bmw\\print\\foto.jpg");
					fileStream = new FileStream();
					fileStream.open(arquivo, FileMode.WRITE);
					fileStream.writeBytes(btArray);
					fileStream.close();
					
					imprime();
				}catch(err){};
				
				

				saveVariables();
		//	}
			
			
		}
		
		public function saveVariables(event:flash.events.Event = null):void{

			var urlRequest:URLRequest = new URLRequest("http://"+globalVars.cadastro2["cip"]+"/bmw/inserir.php");
			var urlLoader:URLLoader = new URLLoader;	
			
			var urlVars:URLVariables;
			
			trace('cliente: '  + globalVars.cadastro2["ccliente"]);
			
			urlVars = new URLVariables;
			urlVars.nome = globalVars.cadastro["cnome"];
			urlVars.sobrenome = globalVars.cadastro["csobrenome"]
			urlVars.email = globalVars.cadastro["cemail"];
			urlVars.telefone = globalVars.cadastro["ctelefone"];
			urlVars.sexo = globalVars.cadastro2["csexo"] == 0?'M':'F';
			urlVars.idade = globalVars.cadastro2["cidade"];
			urlVars.cliente = globalVars.cadastro2["ccliente"];
			urlVars.moto = globalVars.cadastro2["cmoto"];
			urlVars.optin = globalVars.cadastro2["coptin"];
			urlVars.op_cidade = globalVars.cadastro2["cop_cidade"];
			urlVars.op_musica = globalVars.cadastro2["cop_musica"];
			urlVars.op_esporte = globalVars.cadastro2["cop_esporte"];
			urlVars.op_programa = globalVars.cadastro2["cop_programa"];
			urlVars.status = 0;
			
			urlRequest.data = urlVars;
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(flash.events.Event.COMPLETE, inserido);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			urlLoader.load(urlRequest);	
				
				
				
		}
		
		private function imprime():void{

			var proc:File = File.desktopDirectory.resolvePath("imprimidor/ConsoleImprimidor.exe");
			var nap:NativeProcess = new NativeProcess();
			var napInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			napInfo.executable = proc;
			nap.start(napInfo);
		}
		
		private function inserido(evt:flash.events.Event):void{
			
			evt.target.removeEventListener(flash.events.Event.COMPLETE, inserido);
			var folder:File = new File();
			var arquivo:File;
			
			tempImg = new BitmapData(600,600);	
			var matrizSalva:Matrix = new Matrix();
			matrizSalva.scale(1,1);
			tempImg.draw(globalVars.cadastro2['cbitmap'] ,matrizSalva);
			
			var jpg:JPGEncoder = new JPGEncoder(100);
			btArray = jpg.encode(tempImg);
			
			/*arquivo = folder.resolvePath("Z:\\foto.jpg");
			fileStream = new FileStream();
			fileStream.openAsync(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			var destination:File = new File();
			destination =  destination.resolvePath("Z:\\" + evt.target.data + ".jpg");
			
			arquivo.moveToAsync(destination); */
			
			arquivo = folder.resolvePath("Z:\\" + evt.target.data + ".jpg");
			fileStream = new FileStream();
			fileStream.open(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			trace('DISPATCH');
			
			tempImg.dispose();
			btArray.clear();
			
			TweenMax.delayedCall(8, volta);
		}
		
		private function onIOError(e:IOErrorEvent):void
		{

			e.target.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);

				
			var urlRequest:URLRequest = new URLRequest("http://localhost/bmw/inserir.php");
			var urlLoader:URLLoader = new URLLoader;	
			
			var urlVars:URLVariables;
			
			trace('cliente2: '  + globalVars.cadastro2["ccliente"]);
			
			urlVars = new URLVariables;
			urlVars.nome = globalVars.cadastro["cnome"];
			urlVars.sobrenome = globalVars.cadastro["csobrenome"]
			urlVars.email = globalVars.cadastro["cemail"];
			urlVars.telefone = globalVars.cadastro["ctelefone"];
			urlVars.sexo = globalVars.cadastro2["csexo"] == 0?'M':'F';
			urlVars.idade = globalVars.cadastro2["cidade"];
			urlVars.cliente = globalVars.cadastro2["ccliente"];
			urlVars.moto = globalVars.cadastro2["cmoto"];
			urlVars.optin = globalVars.cadastro2["coptin"];
			urlVars.op_cidade = globalVars.cadastro2["cop_cidade"];
			urlVars.op_musica = globalVars.cadastro2["cop_musica"];
			urlVars.op_esporte = globalVars.cadastro2["cop_esporte"];
			urlVars.op_programa = globalVars.cadastro2["cop_programa"];
			urlVars.status = 0;
			
			urlRequest.data = urlVars;
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(flash.events.Event.COMPLETE, inseridoLocal);
			
			urlLoader.load(urlRequest);	
			
			
		}
		
		private function inseridoLocal(evt:flash.events.Event):void{
			
			
			evt.target.removeEventListener(flash.events.Event.COMPLETE, inseridoLocal);
			
			var folder:File = new File();
			var arquivo:File;
			
			tempImg = new BitmapData(600,600);	
			var matrizSalva:Matrix = new Matrix();
			matrizSalva.scale(1,1);
			tempImg.draw(globalVars.cadastro2['cbitmap'], matrizSalva);
			
			var jpg:JPGEncoder = new JPGEncoder(100);
			btArray = jpg.encode(tempImg);
			
			/*arquivo = folder.resolvePath("C:\\xampp\\htdocs\\bmw\\pics\\foto.jpg");
			fileStream = new FileStream();
			fileStream.open(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			var destination:File = new File();
			destination =  destination.resolvePath("C:\\xampp\\htdocs\\bmw\\pics\\" + evt.target.data + ".jpg");
			
			arquivo.moveToAsync(destination);*/
			
			arquivo = folder.resolvePath("C:\\xampp\\htdocs\\bmw\\pics\\" + evt.target.data + ".jpg");
			fileStream = new FileStream();
			fileStream.open(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			TweenMax.delayedCall(8, volta);
		}
		
		private function volta():void{
			dispatchEvent(new starling.events.Event('Modulos.FINISHED',true,{pagina:_xml.parent().parent().@pagina, index:1}));
		}
		
		public function copyAsBitmapData(displayObject:starling.display.DisplayObject, transparentBackground:Boolean = true, backgroundColor:uint = 0xcccccc, w=0, h=0):BitmapData
		{
			if (displayObject == null || isNaN(displayObject.width)|| isNaN(displayObject.height))
				return null;
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			
			result = new BitmapData(w==0?displayObject.width:w, h==0?displayObject.height:h, transparentBackground, backgroundColor);
			var context:Context3D = Starling.context;
			//var support:RenderSupport = new RenderSupport();
			//RenderSupport.clear();
			//support.pushClipRect(new Rectangle(0,0,w,h))
			//support.setOrthographicProjection(0,0, Starling.current.stage.stageWidth , Starling.current.stage.stageHeight)
			//support.setProjectionMatrix(0,0, w+320, h, w, h);
			//support.setProjectionMatrix(0,0, Starling.current.stage.stageWidth , Starling.current.stage.stageHeight);
			//support.transformMatrix(
			//support.applyBlendMode(true);
			//support.translateMatrix( -resultRect.x, -resultRect.y);
			//support.scaleMatrix(1,1.1);
			//support.pushMatrix();
			//support.blendMode = displayObject.blendMode;
			//support.transformMatrix(displayObject);
			//displayObject.render(support, 1);
			//support.popMatrix();
			//support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}
		
		private function criaComponente(evt:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, criaComponente);
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			criaCampos();
			
		}
		
		private function criaCampos():void
		{
			imgArr = new Array();
			
			for(var i:Number=0; i<_xml.length(); i++){
				
				
				
				switch(String(_xml[i].@tipo)){
					case "imagem" :
						if(String(_xml[i].@type) == "get"){
							//var scale:Number = 0.61;
							var scale:Number = 1.34;
							var matrix:Matrix = new Matrix();
							matrix.scale(scale, scale);
							
							smallBMD = new BitmapData(globalVars.cadastro2[_xml[i].@vr].width * scale, globalVars.cadastro2[_xml[i].@vr].height * scale, true, 0x000000);
							smallBMD.draw(globalVars.cadastro2[_xml[i].@vr], matrix, null, null, null, true);
							
							//var bitmap:Bitmap = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
							fotoBD = globalVars.cadastro2[_xml[i].@vr].clone();
							
							fotoTexture = Texture.fromBitmapData(smallBMD, false);
							fotoBlurred = new Image(fotoTexture);  
							
							fotoBlurred.x = Number(_xml[i].@x);
							fotoBlurred.y = Number(_xml[i].@y);
							
							fotoBlurred.alpha = 0;
							
							TweenMax.delayedCall(1, function():void{TweenLite.to(fotoBlurred, 1, {alpha:1});});
							
							
							
							addChild(fotoBlurred);
						}else{
							ldr = new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:i, max:true});
							ldr.addEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
							imgArr[i] = ldr;
							
							
							//ldr.scaleX = .48;
							//ldr.scaleY = .48;
							//ldr.touchable = false;
							
							addChild(ldr);
						}
						
						
						
						//imgArr[i].x = Number(_xml[i].@x);
						//imgArr[i].y = Number(_xml[i].@y);
					break;
					
					case "campo" :
						try{
							trace("PARA CAMPO var -> " + globalVars.cadastro[_xml[i].@vr]);
							
							modulo_campo = new ModuloCampo({idM:_props.idM, idI:_props.idI, idT:_props.idT, idW:i});
							//modulo_campo.addEventListener('Modulos.CARREGADOS', campoModuleCreated);
							addChild(modulo_campo);
	
							trace("var -> " + globalVars.cadastro[_xml[i].@vr]);
						}catch(err){};
						//}
					break;
					
				}
				
				trace('TIPO: ' + _xml[i].@tipo);

			}
			
			this.scaleX = .45;
			this.scaleY = .45;
			
			this.dispatchEventWith(propagaEvento.COMPLETED, false);
			
		}
			
		private function imagemCarregada(evt:starling.events.Event):void
		{
			//trace('img OK')
			evt.currentTarget.removeEventListener(propagaEvento.IMAGELOADED, imagemCarregada);
			
		}


		
		override public function dispose():void{
			try{
				for(var i:Number=0; i<imgArr.length; i++){
					imgArr[i].dispose();
					removeChild(imgArr[i]);
				}
			}catch(err){}
			
			try{
				modulo_campo.dispose();
				removeChild(modulo_campo);
			}catch(err){}
			
			try{
				fotoBD.dispose();
				fotoTexture.dispose();
				fotoBlurred.dispose();
			}catch(err){}
			
			imgArr = [];
			imgArr = null;
			
			try{
			smallBMD.dispose();
			}catch(err){}
			
			try{
			result.dispose();
			}catch(err){}
			
			try{
			tempImg.dispose();
			}catch(err){}

			globalVars.cadastro["cnome"] = null;
			globalVars.cadastro["csobrenome"] = null
			globalVars.cadastro["cemail"] = null;
			globalVars.cadastro["ctelefone"] = null;
			globalVars.cadastro2["ccliente"] = null;
			globalVars.cadastro2["cmoto"] = null;
			globalVars.cadastro2["coptin"] = null;
			globalVars.cadastro2["cop_cidade"] = null;
			globalVars.cadastro2["cop_musica"] = null;
			globalVars.cadastro2["cop_esporte"] = null;
			globalVars.cadastro2["cop_programa"] = null;
			try{
				globalVars.cadastro2["cbitmap"].dispose();
			}catch(err){}
			
			try{
				globalVars.cadastro2["cbitmap"] = null;
			}catch(err){}
			
			try{
				btArray.clear();
			}catch(err){}

		}
	}
}