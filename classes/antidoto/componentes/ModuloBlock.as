package classes.antidoto.componentes
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	import flash.filesystem.File;
	
	import classes.antidoto.Local;
	import classes.antidoto.MyImageLoader;
	import classes.antidoto.propagaEvento;
	import classes.antidoto.renderers.ListRendererBlock;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ModuloBlock extends Sprite
	{
		private var _bgColor:uint;
		
		private var img:MyImageLoader;
		private var xis:MyImageLoader;
		
		private var _pageIndicator:PageIndicator;
		
		private var _xml:XML;
		
		private var _h:Number;
		
		private var _list:List;
		private var _listCol:ListCollection;
		
		private var _w:Number;
		
		private var imagem:MyImageLoader;
		
		private var container:ScrollContainer;
		
		private var imageArr:Array;
		
		private var blockListaLayout:TiledRowsLayout;
		
		private var quad:Shape;
		
		private var popupColor:uint = 0x151616;
		
		private var _props:Object;
		
		public function ModuloBlock(xml:XML, props:Object )
		{
			
			_props = props;
			
			_h = xml.@height;
			_xml = xml;
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			this.height = _h;
		}
		
		private function criaComponente(evt:Event):void
		{
			_listCol = new ListCollection();
			
			//trace('categoria: ' + _list.selectedItem.text );
			
			//trace('ZIPFILE' + _props.zip);
			
			for(var a:Number =_xml.item.length(); a--;){
				//trace(File.documentsDirectory.resolvePath("queiroz_galvao/img/") +xmlRoot.predio[a].@bullet);
				//_listCol.addItem(new Local(a, xmlRoot.predio[a].nome, File.documentsDirectory.resolvePath("queiroz_galvao/img/"+xmlRoot.predio[a].@bullet).url, xmlRoot.predio[a].endereco));
				_listCol.addItem({id:a, img:_xml.item[a].img[0], popup:_xml.item[a].img[1], endereco:_props.zip, props:_props});
			}
			
			if(_listCol.length == 0){
				//trace('tamanho: ' + _listCol.length);
				return
			}
			
			_list = new List();
			_list.dataProvider = _listCol;
			
			_list.height = 180
			
			_list.width = 1010;
			
			_list.x = 1080/2 - 1010/2;
			
			blockListaLayout = new TiledRowsLayout();
			blockListaLayout.useSquareTiles = false;
			blockListaLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_JUSTIFY;
			blockListaLayout.gap = 2;
			//	_list.y = _list.y + (100 * this.dpiScale) + 10;
			_list.layout = blockListaLayout;
			blockListaLayout.useVirtualLayout = true;
			
			//blockListaLayout.paddingLeft = 20
			_list.addEventListener(Event.CHANGE, list_changeHandler);
			
			//_list.addEventListener(FeathersEventType.CREATION_COMPLETE, validar);
			
			
			_list.itemRendererFactory = blockListaRendererFactory;
			
			addChild(_list);
			
			//_list.validate();
			
			//var calc:Number = stage.stageHeight - (_list.y + (100 * this.dpiScale) + 10);
			//_list.y = 300;
			
			this.dispatchEventWith(propagaEvento.COMPLETED,false,null);
			
		}
		
		private function validar(evt:Event):void
		{
			//_list.validate();
			//trace('SCROLL');
			_list.scrollToPosition(0,0)
		}
		
		private function list_changeHandler(evt:Event):void
		{
			if(_list.selectedIndex != -1){
				var list:List = List( evt.currentTarget );
				var item:Object = list.selectedItem;
				
				//trace('PRESSED');
				//this.dispatchEventWith(OPEN_PAGE, false, item as Local);
				
				openPopup(item);
				
				_list.selectedIndex = -1;
			}
			
		}
		
		private function openPopup(item:Object):void
		{
			
			if(!TweenMax.isTweening(quad)){
				
				parent.setChildIndex(this, parent.numChildren-1);
				
				quad = new Shape();
				quad.graphics.beginFill(popupColor , 1);
				quad.graphics.drawRect(0, 0, 1, 80);
				quad.graphics.endFill();
				
				quad.x = 37;
				quad.y = 0;
				
				addChild(quad);
				
				//	trace(TweenMax.isTweening(quad));
				
				TweenMax.to(quad, .5, {width:1003, onComplete:function():void{ TweenLite.to(quad, .5, {height:1330, onComplete:abreImagem, onCompleteParams:[item]});}});
			}
			
			//trace(TweenMax.isTweening(quad));
			
		}
		
		private function abreImagem(item):void{
			//trace('ID: ' + item.id);
			imageArr = new Array();
			
			img = new MyImageLoader(item.popup, _props);
			//img.maintainAspectRatio = false;
			img.x = 37
			img.alpha = 0;
			
			//img.source = item.popup;
			
			addChild(img);
			
			imageArr.push(img);
			
			TweenLite.to(img, .5, {alpha:1});
			
			xis = new MyImageLoader("xis.png", 'base');
			//img.maintainAspectRatio = false;
			xis.x = 1003 - 20;
			xis.y = 50;
			xis.pivotX = 28;
			xis.pivotY = 28;
			
			xis.addEventListener(TouchEvent.TOUCH, fechaPopup);
			
			//img.source = File.documentsDirectory.resolvePath("queiroz_galvao/img/xis.png").url;
			
			addChild(xis);
			
			imageArr.push(xis);
			
			TweenLite.from(xis, .5, {scaleX:0, scaleY:0, delay:.5, ease:Elastic.easeOut});
			
		}
		
		private function fechaPopup(evt:TouchEvent = null):void
		{
			try{
				if(evt.getTouch(evt.currentTarget as MyImageLoader, TouchPhase.ENDED)){
					img.removeEventListener(TouchEvent.TOUCH, fechaPopup);
					
					for(var i:Number=0; i<imageArr.length; i++){
						imageArr[i].dispose();
						removeChild(imageArr[i]);
					}
					
					removeChild(quad);
					
					imageArr = [];
					imageArr = null;
				}
			}catch(err){};
			
		}
		
		private function blockListaRendererFactory():IListItemRenderer
		{
			var atracaoListaRenderer:ListRendererBlock = new ListRendererBlock();
			return atracaoListaRenderer;
		}	
		
		
		
		override public function dispose():void{
			
			fechaPopup();
			
		}
	}
}