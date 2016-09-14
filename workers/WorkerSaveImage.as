package workers
{
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	public class WorkerSaveImage extends Sprite
	{
		private var fileStream:FileStream;
		
		private var btArray:ByteArray;
		private var tempImg:BitmapData;
		
		private var w2m:MessageChannel;
		private var m2w:MessageChannel;
		
		private var jpg:JPGEncoder;
		
		private var folder:File = new File();
		private var arquivo:File;
		
		private var matrizSalva:Matrix = new Matrix();
		
		private var _sprite:Sprite;
		
		private var imageBytes:ByteArray;
		
		private var imageData:BitmapData;
		
		public function WorkerSaveImage()
		{
			super();
			trace("isPrimordial: " + Worker.current.isPrimordial)
			
			w2m = Worker.current.getSharedProperty('w2m');
			m2w = Worker.current.getSharedProperty('m2w');
			imageBytes = Worker.current.getSharedProperty("imageBytes");

			m2w.addEventListener(Event.CHANNEL_MESSAGE, getMessage)
		}
		
		private function getMessage(evt:Event):void{
			trace("WORKER: working...")
			//w2m.send(m2w.receive());
			
			imageBytes.position = 0;
			imageData = new BitmapData(1864, 1228, false, 0x0);
			imageData.setPixels(imageData.rect, imageBytes);

			
			savePhoto(imageData);
		}
		
		private function savePhoto(bmp):void{

			tempImg = new BitmapData(1864,1228);	
			
			matrizSalva.scale(1,1);
			tempImg.draw(bmp as BitmapData ,matrizSalva);
			
			jpg = new JPGEncoder(100);
			btArray = jpg.encode(tempImg);
			
			arquivo = folder.resolvePath("c:\\photoSalva.jpg");
			fileStream = new FileStream();
			fileStream.open(arquivo, FileMode.WRITE);
			fileStream.writeBytes(btArray);
			fileStream.close();
			
			w2m.send('COMPLETE');
		}
	}
}