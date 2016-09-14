package workers
{
	import com.adobe.images.JPGEncoder;
	import com.greensock.events.LoaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	import workers.WorkerSaveImage;
	
	public class SaveImage extends Sprite
	{	
		
		private var result:BitmapData;
		private var canvasBlurredTexture:Texture;
		private var canvasBlurred:Image;
		private var bitmapGot:Bitmap;
		private var myParentSquareBitmap:BitmapData;
		
		//private var myImage:ImageLoader;
		
		private var fotoBD:BitmapData;
		
		private var fileStream:FileStream;
		
		private var btArray:ByteArray;
		private var tempImg:BitmapData;
		
		private var spriteSave:Sprite
		
		private var useWorker:Boolean = true;
		
		private var w2m:MessageChannel;
		private var m2w:MessageChannel;
		
		private var imageBytes:ByteArray;
		
		public function SaveImage(image:Sprite)
		{
			saveImage();
		}
		
		private function saveImage():void{
			spriteSave = new Sprite();
			addChild(spriteSave);
			
			//myImage = new ImageLoader("img/photo_test.jpg", {name:"photo1", container:spriteSave, x:0, y:0, width:1864, height:1228, scaleMode:"proportionalInside", centerRegistration:false, onComplete:onImageLoad});
			//myImage.load();
			


		}
		
		private function onImageLoad(event:LoaderEvent):void{

			var rect:Rectangle = spriteSave.parent.getBounds(spriteSave.parent);
			var bmp:BitmapData = new BitmapData(rect.width, rect.height, true, 0);

			var matrix:Matrix = new Matrix();
			matrix.translate(-rect.x, -rect.y);

			bmp.draw(spriteSave.parent, matrix);
			
			if(!useWorker){
				savePhotoPC(bmp);
			}else{
				var worker:Worker = WorkerFactory.getWorkerFromClass(WorkerSaveImage, Starling.current.nativeStage.loaderInfo.bytes);
				
				w2m = worker.createMessageChannel(Worker.current);
				m2w = Worker.current.createMessageChannel(worker);
				
				worker.setSharedProperty("w2m", w2m);
				worker.setSharedProperty("m2w", m2w);
				
				w2m.addEventListener(Event.CHANNEL_MESSAGE, onMessage)
				
				worker.start();
				
				imageBytes = new ByteArray();
				imageBytes.shareable = true;
				bmp.copyPixelsToByteArray(bmp.rect, imageBytes);
				worker.setSharedProperty("imageBytes", imageBytes);
				
				m2w.send('SENDED');
			}
			
		}
		
		protected function onMessage(event:Event):void
		{
			trace(w2m.receive());
			
		}
		
		private function savePhotoPC(bmp):void{
			var folder:File = new File();
			var arquivo:File;
			
			tempImg = new BitmapData(1864,1228);	
			var matrizSalva:Matrix = new Matrix();
			matrizSalva.scale(1,1);
			tempImg.draw(bmp ,matrizSalva);
			
			var jpg:JPGEncoder = new JPGEncoder(100);
			btArray = jpg.encode(tempImg);
			
			arquivo = folder.resolvePath("c:\\photoSalva.jpg");
			fileStream = new FileStream();
			fileStream.open(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			trace('FOTO SALVA!');
		}
		
		/*public function copyAsBitmapData(displayObject:starling.display.DisplayObject, transparentBackground:Boolean = true, backgroundColor:uint = 0xcccccc):BitmapData
		{
			if (displayObject == null || isNaN(displayObject.width)|| isNaN(displayObject.height))
				return null;
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			
			result = new BitmapData(displayObject.width, displayObject.height, transparentBackground, backgroundColor);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setProjectionMatrix(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.applyBlendMode(true);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			support.pushMatrix();
			support.blendMode = displayObject.blendMode;
			displayObject.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}*/
	}
}