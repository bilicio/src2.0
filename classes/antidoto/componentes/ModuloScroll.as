package classes.antidoto.componentes
{
	
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.MyImageLoader2;
	import classes.antidoto.globalVars;
	import classes.antidoto.propagaEvento;
	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ModuloScroll extends Sprite
	{
		private var _bgColor:uint;
		
		private var img:MyImageLoader2;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:XMLList;
		
		private var _h:Number;
		private var _w:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var imagem:MyImageLoader2;
		private var sombra:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var imageArr:Array = new Array();
		private var imageAvulsaArr:Array = new Array();
		
		private var _props:Object;
		
		private var cont:Number = 0;
		
		public function ModuloScroll(props:Object)
		{
			_props = props;
			
			_xml = globalVars.xml.menu[props.idM].modulo[props.idI].item;
			
			_bgColor = globalVars.xml.@color;
			
			_w = globalVars.xml.menu[_props.idM].modulo[_props.idI].@w;
			_h = globalVars.xml.menu[_props.idM].modulo[_props.idI].@h;
			
			//trace(_w + " - " + _h);
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			
		}
		
		private function criaComponente(evt:Event):void
		{
			var layout:VerticalLayout = new VerticalLayout();
			//trace('categoria: ' + _list.selectedItem.text );
			
			//for(var i:Number = 0; i<_xml.img.length(); i++){
				
				container = new ScrollContainer();
				container.height = _h;
				container.width = _w;
				
				imagem = new MyImageLoader2({idM:_props.idM, idI:_props.idI});
				//imagem.source = File.documentsDirectory.resolvePath("queiroz_galvao/img/"+_xml.img[i]).url;
				imagem.addEventListener(propagaEvento.IMAGELOADED, botaMask);
				//imagem.height = 800;
				//imageArr.push([imagem,container]);
				
				//container.addChild(imageArr[i][0]);
				container.layout = layout;
				
				addChild(container);
				
				cont++;
		//	}
			
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			
		}
		
		private function botaMask(evt:Event):void
		{
			//if(cont != _xml.img.length()){
				//return;
			//}
			
			//var DIO:MyImageLoader = evt.currentTarget as MyImageLoader;
			//DIO.validate();
			
			//new MyImageLoader2({idM:_props.idM, idI:_props.idI, idT:img, max:false});
			imagem.scaleX = imagem.scaleY = Number(globalVars.xml.menu[_props.idM].modulo[_props.idI].@scale);

		//	for(var i:Number = 0; i<_xml.img.length(); i++){
			container.addChild(imagem);
				//	if(DIO == imageArr[i][0]){
				/*if(imageArr[i][0].height>_h){
					sombra = new MyImageLoader2("sombra_scroller.png", {tiled:true, width:_w});
					
					addChild(sombra);
					
					sombra.height = 116
					sombra.y = imageArr[i][1].height - 116;
					sombra.x = imageArr[i][1].x;
					
					imageAvulsaArr.push(sombra);
					
					imagem = new MyImageLoader("seta.png", 'base');
					
					addChild(imagem);
					
					imagem.width = 40;
					imagem.height = 24
					imagem.y = imageArr[i][1].height - 116 + 60;
					imagem.x = imageArr[i][1].x + imageArr[i][1].width/2 - 20;
					
					imageAvulsaArr.push(imagem);
					
				}*/
				//}
			//}
		}
		
		
		
		override public function dispose():void{
			imagem.dispose();
			container.dispose();
			/*for(var i:Number=0; i<imageArr.length; i++){
				imageArr[i][0].dispose();
				removeChild(imageArr[i][0]);
				imageArr[i][1].dispose();
				removeChild(imageArr[i][1])
			}*/
			
		/*	for(var a:Number=0; a<imageAvulsaArr.length; a++){
				imageAvulsaArr[a].dispose();
				removeChild(imageAvulsaArr[a]);
			}*/
			
			//imageAvulsaArr = [];
			//imageAvulsaArr = null;
			
			//imageArr = [];
			//imageArr = null;
			
			/*if(img_Clima){	
			img_Clima.dispose();
			}*/
			
			//trace('disposed!!!');
		}
	}
}