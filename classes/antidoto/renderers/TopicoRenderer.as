package classes.antidoto.renderers
{

	import flash.geom.Point;
	import flash.text.TextFormat;

	import classes.antidoto.MyImageLoader;
	import classes.antidoto.propagaEvento;

	import feathers.controls.Label;
	import feathers.controls.TextArea;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;
	
	import org.as3commons.zip.ZipFile;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class TopicoRenderer extends LayoutGroupListItemRenderer
	{
		public function TopicoRenderer()
		{
			super();
		}
		
		private var container:Shape;
		protected var _larguraItem:Number;		
		
		protected var _titulo:TextArea;
		protected var _img:MyImageLoader;
		protected var _texto:Label;
		
		private var tituloTextFormat:TextFormat;
		private var textotextFormat:TextFormat;
		
		private static const MARGEM_ESQUERAD_DO_TEXTO:int = 10;
		
		private var layout:VerticalLayout;
		
		private var touchHelper:Point;
		
		private var num:Number = 0
		
		private var dpi:Number;
		
		private var sprite:Sprite;
		
		private var zipFile:ZipFile;
		
		override protected function initialize():void
		{
			
			layout = new VerticalLayout();
			
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			this.layout = layout;
			
			
			sprite = new Sprite()
			
			desenharTela();
			
			dpi = DeviceCapabilities.dpi / 326;
			
			//trace('DPI: ' + dpi);
			
			//this.height = this.stage.stageWidth /  (2 * dpi) ;
			this.height = 400;
			this.width = 951;
			
			this.addEventListener(TouchEvent.TOUCH, itemTocado);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removido);
			
			//trace('-1');
		}
		
		private function itemTocado(evt:TouchEvent):void
		{
			var touchInicio:Touch = evt.getTouch(this, TouchPhase.BEGAN);
			var touchFim:Touch = evt.getTouch(this, TouchPhase.ENDED);
			
			if (touchInicio){
				touchHelper = new Point();
				touchInicio.getLocation(this.stage, touchHelper);
			}
			
			if (touchFim){	
				if (ProcessaTouchComTolerancia(touchFim.getLocation(this.stage),touchHelper)){
					
					this.isSelected = true;
				}
			}
		}		
		
		public function get larguraItem():Number
		{
			return this._larguraItem;
		}
		
		public function set larguraItem(value:Number):void
		{
			if (this._larguraItem == value){
				return;
			}
			this._larguraItem = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		
		
		private function desenharTela():void
		{
			container = new Shape();
			container.graphics.beginFill(0xFFFFFF, 0);
			container.graphics.drawRect(0,0,1,1);
			container.graphics.endFill();			
			this.addChild(container);
			
		}
		
		override protected function commitData():void
		{
			//sprite = new Sprite();
			//trace('lala');
			
			if (this._data.img){
				if(!_img){
					//zipFile = Assets.zip.getFileByName(this._data.img);
					
					_img = new MyImageLoader(this._data.img, this._data.endereco);	
					
					_img.addEventListener(propagaEvento.IMAGELOADED, arrumaImagens);
					//_img.addEventListener(Event.COMPLETE, arrumaImagens);
					//sprite.addChild(_img);	
					//addChild(sprite);
				}
				//_img.source = File.documentsDirectory.resolvePath("queiroz_galvao/img/"+this._data.img).url;
				//_img.source = Assets.getImage(this._data.img);
				
				//	var image:BitmapData =  Assets.lib.getBitmapData(this._data.img);
				//var bitm:Bitmap = new Bitmap(image);
				//_img.source = Texture.fromBitmap(bitm);
				
			}
			
			/*if (this._data.titulo){
			if(!_titulo){
			_titulo = new TextArea();
			_titulo.textEditorFactory = function():ITextEditorViewPort
			{
			var textArea:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
			textArea.textFormat = new TextFormat('HelveticaNeue', 25*(dpi), 0x000000);
			textArea.embedFonts = true;
			
			return textArea;
			};
			
			this._titulo.width = 50;
			//this._titulo.height = 65;
			this._titulo.minHeight = 35
			this._titulo.isEnabled = false;
			//	_titulo.nameList.add('titulo-info-list');
			
			addChild(_titulo);
			}
			this._titulo.text = this._data.titulo;
			
			}
			
			
			if (this._data.preco_dur){
			
			var hotelXml:XML = Assets.am.getXml('atracoes');
			var hotelLat:Number = hotelXml.hotel.node.@lat;
			var hotelLng:Number = hotelXml.hotel.node.@lng;
			
			if(!_texto){
			_texto = new Label();
			_texto.nameList.add('label-info-roteiro');
			addChild(_texto);
			}
			_texto.text = this._data.preco_dur;
			_texto.text += "\n" + Math.round(GeoUtils.distanceDeg(hotelLng,hotelLat,this._data.lng, this._data.lat)/1000) + 'km do hotel';
			}*/
		}
		
		override protected function preLayout():void
		{
			if (this._data.img){
				this._img.width = 951;
				this._img.height = 334;
				//this._img.maintainAspectRatio = false;
			}
			
			/*if (this._data.titulo){
			if (this._img){
			this._titulo.width = this._img.width - 10;
			//if(this._titulo.text.length>21){
			this._titulo.height = 65 * dpi;
			//}
			
			
			this._titulo.y = this._img.height + 8;
			this._titulo.x = MARGEM_ESQUERAD_DO_TEXTO;
			}
			}
			*/
			/*if (this._larguraItem){
			container.width = this._larguraItem;
			}else{*/
			container.width = 951;				
			//}
			
			/*if (this._data.preco_dur){
			this._texto.width = ((this.stage.stageWidth / 2) - 10) - MARGEM_ESQUERAD_DO_TEXTO;
			//	this._texto.wordWrap = true;
			this._texto.y = this._titulo.y + this._titulo.height - 5;
			this._texto.x = MARGEM_ESQUERAD_DO_TEXTO;
			}*/
			
			
			
		}
		
		override protected function postLayout():void
		{
			this.height = 334 ;
			container.height = 334 ;
			this.actualHeight = 334;
			
			//this._img.y = 0;
			
		}
		
		private function arrumaImagens(evt:Event):void
		{
			//trace('FLATTEN');
			//sprite.flatten();
			addChild(_img);
			_img.removeEventListener(propagaEvento.IMAGELOADED, arrumaImagens);
			//this._img.validate();
			
		}
		
		private function ProcessaTouchComTolerancia(ponto1:Point,ponto2:Point,tolerancia:int = 50):Boolean
		{
			
			if(Math.abs(ponto1.x - ponto2.x) < tolerancia && Math.abs(ponto1.y - ponto2.y) < tolerancia ){
				return true;
			}else{
				return true;				
			}
		}
		
		
		private function removido():void
		{
			this.removeEventListeners(Event.REMOVED_FROM_STAGE);
			this.removeEventListeners(TouchEvent.TOUCH);
			this._img.removeEventListeners(Event.COMPLETE);
			//this._img.source = null;
			this._img.dispose();
			
			removeChild(_img);
			this.dispose();
		}
		
		
	}
}