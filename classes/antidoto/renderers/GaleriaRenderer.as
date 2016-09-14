package classes.app.screens.renderers
{
	import flash.geom.Point;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GaleriaRenderer extends LayoutGroupListItemRenderer
	{
		
		private var layout:VerticalLayout;		
		protected var _img:ImageLoader;		
		
		private var dpi:Number;
		private var touchHelper:Point;
		
		public function GaleriaRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			layout = new VerticalLayout();
			
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			this.layout = layout;
			
			dpi = DeviceCapabilities.dpi / 326;
			
			this.addEventListener(TouchEvent.TOUCH, itemTocado);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removido);
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
		
		override protected function commitData():void
		{
			if (this._data.img){
				if (!_img){
					_img = new ImageLoader();
					_img.source = this._data.img;
					addChild(_img);
				}
			}
		}
		
		override protected function preLayout():void
		{						
			this._img.width = (this.stage.stageWidth / 2) - 10;	
			this._img.height = (dpi * 250);
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
			//this._img.removeEventListeners(Event.COMPLETE);
			this._img.source = null;
			this._img.dispose();
			this.dispose();
		}
		
	}
}