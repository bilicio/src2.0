package org.gestouch.examples.starling
{
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.ZoomGesture;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;


	/**
	 * @author Pavel fljot
	 */
	public class StarlingExampleBase extends Sprite
	{
		[Embed(source="/assets/images/back-button.png")]
		private static const backButtonImage:Class;
		
		private var backButton:Image;
		
		
		public function StarlingExampleBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}


		public function resize(width:int, height:int):void
		{
			const rect:Rectangle = new Rectangle(0, 0, width, height);
			const starling:Starling = Starling.current;
			starling.viewPort = rect;
			starling.stage.stageWidth = rect.width;
			starling.stage.stageHeight = rect.height;
			
			onResize(starling.stage.stageWidth, starling.stage.stageHeight);
		}
		
		
		protected function onResize(width:Number, height:Number):void
		{
			
		}


		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			init();
		}
		
		
		protected function init():void
		{			
			backButton = new Image(Texture.fromBitmap(new backButtonImage()));
			backButton.x = backButton.y = 3;
			backButton.scaleX = backButton.scaleY = 2;
			backButton.addEventListener(TouchEvent.TOUCH, backButton_touchHandler);
			var sprite:Sprite = new Sprite();
			
			sprite.addChild(backButton);
			addChild(sprite);
			
			var zoomGesture:* = new ZoomGesture( sprite );
			zoomGesture.addEventListener(GestureEvent.GESTURE_ENDED, onZoomEnded);
			
			setTimeout(resize, 1, stage.stageWidth, stage.stageHeight);
		}
		
		private function onZoomEnded(event:GestureEvent):void {
			trace("gesture ended");
		}
		

		private function backButton_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0] as Touch;
			if (touch.phase == TouchPhase.ENDED)
			{
				stage.dispatchEvent(new Event("quit"));
			}
		}
	}
}