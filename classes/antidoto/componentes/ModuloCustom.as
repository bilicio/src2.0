package classes.antidoto.componentes
{
	
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Quad;
	import com.greensock.loading.MP3Loader;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import app.Main;
	
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.text.TextFieldTextRenderer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	//------------------------------------------------------- Eventos de retorno de função
	[Event(name="openPage",type="starling.events.Event")]
	[Event(name="cargaCompleta",type="starling.events.Event")]

	public class ModuloCustom extends starling.display.Sprite
	{
		public static const OPEN_PAGE:String = "openPage";
		public static const FINISHED:String = "cargaCompleta";
		public static const DISPOSED:String = "disposed";
		
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
		
		private var modulo_imagem:MyImageLoader2;
		
		private var _id:*;
		private var _xml:XMLList;
		
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		
		private var texture:Texture;
		private var video:Image;
		
		private var item:String;
		
		public var w:Number;
		public var h:Number;
		
		public var sound:MP3Loader
		
		private var videoCont:Number = 0;
		
		private var op_cidade:Array = new Array("manha.mp4","tarde.mp4","noite.mp4");
		private var op_musica:Array = new Array("rock.mp3","pop.mp3","eletronico.mp3");
		private var op_esporte:Array = new Array("radicais.mp4","ar_livre.mp4","indoor.mp4");
		private var op_programa:Array = new Array("parque.mp4","cinema.mp4","restaurante.mp4");
		private var op_programa2:Array = new Array("rock.mp4","pop.mp4","eletronico.mp4");
		
		private var imgArr:Array = new Array();
		private var sequence:Array = new Array('intro.mp4',"FOTO", "manha.mp4","eletronico.mp4","radicais.mp4","radicais.mp4","fim.mp4");
		private var back:Shape;
		private var sprite:Sprite = new Sprite();
		private var fotoTexture:Texture;
		private var fotoBlurred:Image;
		private var fotoBD:BitmapData;
		private var smallBMD:BitmapData;
		private var textRenderer:TextFieldTextRenderer;
		private var textFormat:TextFormat;
		private var scale:Number = 1.2;
		private var matrix:Matrix = new Matrix();
		private var soundMusic:MP3Loader;
		
		private var fileStream:FileStream;
		private var btArray:ByteArray;
		private var tempImg:BitmapData;
		
		public var free:Boolean = false;

		public function ModuloCustom(props:Object)
		{
			_props = props;
			
			for each(var itemData:XML in  globalVars.xml.menu[props.idM].modulo[props.idI].item[0].modulo[props.idT].elements()) 
			{
				item = itemData.localName();
			}
			
			//trace('abre custom');
			
			_props = props;
			
			if(item == 'item'){
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo[_props.idT].item[0].modulo;
			}else{
				_xml = globalVars.xml.menu[_props.idM].modulo[_props.idI].item[0].modulo;
			}
			
		//	trace('comecou a criar o video: ' + _props.idM+ ' - ' + _props.idI+ ' - ' + _props.idT);
			
			try{
				sequence[2] = op_cidade[Number(globalVars.cadastro2['cop_cidade'])];
				sequence[3] = op_programa2[Number(globalVars.cadastro2['cop_musica'])];
				sequence[4] = op_esporte[Number(globalVars.cadastro2['cop_esporte'])];
				sequence[5] = op_programa[Number(globalVars.cadastro2['cop_programa'])];
			}catch(err){}
			
			initializeHandler()

		}
		
		/*private function teste(evt:Event):void
		{
			trace(evt.currentTarget);
			
		}	*/	
		
		
		protected function initializeHandler():void
		{
			criaComponentes();
		}

		private function criaComponentes():*
		{	
			if(!soundMusic){
				soundMusic = new MP3Loader("sngs/"+op_musica[Number(globalVars.cadastro2['cop_musica'])], {name:"audio", autoPlay:true, estimatedBytes:9500});
				soundMusic.load();
			}else{
				
				trace('duas vezes')
				
				return
			}
			
			back = new Shape();
			back.graphics.beginFill(0x000000, 1);
			back.graphics.drawRect(0, 0, 1280, 720);
			back.graphics.endFill();

			back.y = 300;
			
			addChild(back);
			modulo_imagem = new MyImageLoader2({idM:0, idI:4});
			modulo_imagem.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
			modulo_imagem.y = 300;
			modulo_imagem.alpha = 0;
			this.addChild(modulo_imagem);
			
			imgArr.push(modulo_imagem);
			
			modulo_imagem = new MyImageLoader2({idM:0, idI:5});
			modulo_imagem.addEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
			modulo_imagem.x = 550;
			modulo_imagem.y = 550;
			modulo_imagem.alpha = 0;
			modulo_imagem.addEventListener(TouchEvent.TOUCH, aperta)
			this.addChild(modulo_imagem);
			
			imgArr.push(modulo_imagem);
			
			this.addChild(sprite)
			
			iniciaVideo();
			
			//timer.addEventListener(TimerEvent.TIMER, zera)
			//TweenMax.delayedCall(1, function():void{this.dispatchEventWith(FINISHED, false, '');});
				
		}
		
		private function aperta(evt:TouchEvent):void
		{
			if(evt.getTouch(evt.currentTarget as MyImageLoader2, TouchPhase.ENDED)){
				//free = false;;
				videoCont = 0;
				soundMusic.gotoSoundTime(0);
				soundMusic.playSound();
				soundMusic.volume = 1;
				iniciaVideo();
				imgArr[1].alpha = 0;
				
				
			}
			
		}
		
		private function imageModuleCreated(evt:starling.events.Event):void{
			evt.target.removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
		}
		
		private function iniciaVideo():void{

				//trace('--- ABRE VIDEO');
				
				if(sequence[videoCont] == 'fim.mp4'){
					imgArr[0].alpha = 0;
					TweenLite.to(soundMusic, 2, {volume:0, delay:14})
				}
				
				netConnection = new NetConnection()
				netConnection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				netConnection.connect(null);
				netConnection.client = { };
				netConnection.client.onMetaData = function ():void { };
				netStream = new NetStream(netConnection);
				netStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				
				//arrVideoNet.push(netStream);
				
				//arrVideoNetConn.push(netConnection);
				
				//arrVideos.push(video)
				
				//trace('nome video: ' + op_cidade[videoCont]);
				
				netStream.play('vds/' + sequence[videoCont]);
				
				texture = Texture.fromNetStream(netStream, 1, function():void
				{
					video = new Image(texture)
					
					h = video.height/2;
					w = video.width/2;
					
					video.x = 0;
					video.y = 300;
					
					sprite.addChild(video);
				});
			
			try{
				setChildIndex(imgArr[0], numChildren-1);
			}catch(err){};
		}
		
		private function mostraFoto():void
		{
			imgArr[0].alpha = .2;
			
			
			matrix.scale(scale, scale);
			
			//trace('existe? ' + globalVars.cadastro2['cbitmap'])
			
			smallBMD = new BitmapData(globalVars.cadastro2['cbitmap'].width * scale, globalVars.cadastro2['cbitmap'].height * scale, true, 0x000000);
			smallBMD.draw(globalVars.cadastro2['cbitmap'], matrix, null, null, null, true);
			
			//var bitmap:Bitmap = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
			//fotoBD = globalVars.cadastro[_xml['cbitmap'].@vr].clone();
			
			fotoTexture = Texture.fromBitmapData(smallBMD, false);
			
			fotoBlurred = new Image(fotoTexture);  
			fotoBlurred.setVertexAlpha(0, 1)
			fotoBlurred.setVertexAlpha(1, 0)
			fotoBlurred.setVertexAlpha(2, 1)
			fotoBlurred.setVertexAlpha(3, 0)
			
			fotoBlurred.x = 0;
			fotoBlurred.y = 300;
			
			fotoBlurred.alpha = 0;
			
			TweenLite.to(fotoBlurred, 1, {alpha:1});
			//videoCont++;
			
			videoCont++
				
			TweenMax.delayedCall(5, function():void{iniciaVideo(); clear();})
			
			sprite.addChild(fotoBlurred);
			
			textFormat = new TextFormat( "Gotham", 100, 0XFFFFFF);
			
			textRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = textFormat;
			textRenderer.embedFonts = true;
			textRenderer.wordWrap = true;
			textRenderer.isHTML = true;
			
			textRenderer.touchable = false;

			textRenderer.y =  850;
			//textRenderer.filter = BlurFilter.createDropShadow(4,.7,0x666666,1,0,.5)
			
			TweenLite.fromTo(textRenderer, 9, {x:300},{x:100})
				
			textRenderer.text = globalVars.cadastro["cnome"].toUpperCase();
			
			//textRenderer.addEventListener(TouchEvent.TOUCH, escolheCampo);
			
			sprite.addChild(textRenderer);
			
		
			
		}
		
		private function clear():void{

			try{
				smallBMD.dispose();
				fotoTexture.dispose();
			}catch(err){};
			
			try{
				fotoBlurred.dispose();
				sprite.removeChild(fotoBlurred);
			}catch(err){};
			
			
			try{
				textRenderer.dispose();
			}catch(err){};
			
			try{
				//soundMusic.dispose();
			}catch(err){};
			
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
					
					//setChildIndex(modulo_imagem, numChildren-1);
					//getStuff();
					
					break; 
				case "NetStream.Play.Stop": 
					//netStream.play('vds/'+_xml[_props.idT]);
				//	netStream.seek(0)
					//trace('stop');
					//close();
					
					break; 
				
				case "NetStream.Buffer.Empty": 
					try{
						netStream.close();
						netStream = null;
						netConnection.close();
						netConnection = null;
						video.dispose();
						removeChild(video);
						texture.dispose();
						
						//trace('TEXTURE DISPOSED');
					}catch(err){}
					
					if(sequence[videoCont] == 'fim.mp4'){
						imgArr[1].alpha = 1;
						free = true;
						try{
							setChildIndex(imgArr[1], numChildren-1);
						}catch(err){}
					}
					
					videoCont++
					//netStream.play('vds/'+_xml[_props.idT]);
					if(videoCont != sequence.length && sequence[videoCont] != 'FOTO'){
						iniciaVideo();
					}else if(sequence[videoCont] == 'FOTO'){
						mostraFoto();
					}
					
					
					//netStream.seek(0)
					//trace('stop');
					//close();
					
					break; 
				
				case "NetConnection.Connect.Closed": 
					trace('closed');
					
					this.dispatchEventWith(DISPOSED, false, '');
					break; 
			} 
		}

	
		public function build():void{
			criaComponentes();
		}
		
		public function unBuild(evt:TouchEvent):void{
			
				
		}
		
		public function saveVariables():void{
			if(free){
				
				try{
					netStream.close();
					netStream = null;
					netConnection.close();
					netConnection = null;
					video.dispose();
					removeChild(video);
					texture.dispose();
				}catch(err){}
				
				try{
					soundMusic.dispose();
				}catch(err){}
				
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
			
		}
		
		private function inserido(evt:flash.events.Event):void{
			
			var folder:File = new File();
			var arquivo:File;
			
			tempImg = new BitmapData(600,600);	
			var matrizSalva:Matrix = new Matrix();
			matrizSalva.scale(1,1);
			tempImg.draw(globalVars.cadastro2['cbitmap'], matrizSalva);
			
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
			fileStream.openAsync(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			evt.target.removeEventListener(flash.events.Event.COMPLETE, inserido);
			
			trace('DISPATCH');
			
			tempImg.dispose();
			btArray.clear();
			
			dispatchEvent(new starling.events.Event('Modulos.FINISHED',true,{pagina:_xml.parent().parent().@pagina, index:1}));
		}
		
		
		public function onIOError(e:IOErrorEvent):void
		{

			var urlRequest:URLRequest = new URLRequest("http://localhost/bmw/inserir.php");
			var urlLoader:URLLoader = new URLLoader;	
			
			var urlVars:URLVariables;
			
			trace('cliente 2: '  + globalVars.cadastro2["ccliente"]);
			
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
		
			evt.target.removeEventListener(flash.events.Event.COMPLETE, inseridoLocal);
			
			dispatchEvent(new starling.events.Event('Modulos.FINISHED',true,{pagina:_xml.parent().parent().@pagina, index:1}));
		}
		
		private function close():void{

			try{
				netStream.close();
				netConnection.close();
				texture.dispose();
			}catch(err){};
			
			try{

				removeChild(xis);

			}catch(err){};

		}
		
		//------------------------------------------------------- Dispose Menu
		override public function dispose():void{

			try{
				soundMusic.dispose();
			}catch(err){}
			
			try{
				for(var i:Number=0; i<imgArr.length; i++){
					
					
					if(imgArr[i].hasEventListener(TouchEvent.TOUCH)){
						imgArr[i].removeEventListener(TouchEvent.TOUCH, aperta)
					}
					
					if(imgArr[i].hasEventListener(propagaEvento.IMAGELOADED)){
						imgArr[i].removeEventListener(propagaEvento.IMAGELOADED, imageModuleCreated);
					}
					
					imgArr[i].dispose();
					removeChild(imgArr[i]);
				}
			}catch(err){}
			
			try{
			clear();
			}catch(err){}
			
			try{
				sprite.dispose();
			}catch(err){}
			
			try{
				tempImg.dispose();
			}catch(err){}
			
			try{
				netStream.close();
				netConnection.close();
			}catch(err){};
			
			try{
				video.dispose();
				texture.dispose();
			}catch(err){};
			
			try{
				back.dispose();
			}catch(err){}

		}
	}
}
