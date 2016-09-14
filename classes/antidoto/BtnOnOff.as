package classes.antidoto {

	//import feathers.controls.ImageLoader;
	
	//import starling.display.Image;
	
	import starling.display.Sprite;
	
	public class BtnOnOff extends starling.display.Sprite{
		
		private var _fundo:ImageLoaderBA;
		private var _errado:ImageLoaderBA;
		private var _certo:ImageLoaderBA;
		//private var textBox:caixaTexto;
		
		private var textBox:caixaTexto;
		
		private var _colorON:uint;
		private var _colorOFF:uint = 0x000000;
		
		private var selected:Boolean = false;
		
		private var _id:Number;
		
		//private var zipFile:ZipFile;
		
		public function BtnOnOff(id:Number, img_certa:String, img_errada:String, off:String, text:String = '', font:String = '', colorOFF:uint = 0x000000, colorON:uint = 0x000000, size:Number=25) {
			
			_id = id;
			_colorON = colorON;
			_colorOFF = colorOFF;
			
			_fundo = new ImageLoaderBA();
			_fundo.maintainAspectRatio = false;
			//zipFile = Assets.zip.getFileByName(fundo);
			//_fundo.source = fundo;
			_fundo.source = Assets.getImage(off);
			addChild(_fundo);
			
			_errado = new ImageLoaderBA();
			_errado.maintainAspectRatio = false;
			_errado.source = Assets.getImage(img_errada);
			addChild(_errado);
			
			_certo = new ImageLoaderBA();
			_certo.maintainAspectRatio = false;
			_certo.source = Assets.getImage(img_certa);
			addChild(_certo);
			//certo.alpha = 0;
		//	var redBlock:Image = new Image(certo.color);
			//redBlock.color = Color.RED;
			
			textBox	= new caixaTexto(0, 50, 60, text, font, colorOFF, size);
			textBox.x = 40;
			textBox.y = 38
			//addChild(textBox);

		}
		
		public function get id():Number{
			return _id;
		}
		
		public function errada():void{
			_errado.alpha = 1;
			//textBox.color = 0xFF0000;
		//	textBox.color = 0xFF0000;
		}
		
		public function certa():void{
			//certo.alpha = 1;
			_certo.alpha = 1;
			//textBox.color = 0x00FF00;
			//textBox.color = 0x00FF00;
		}
		
		public function off():void{
			//certo.alpha = 1;
			_errado.alpha = 0;
			_certo.alpha = 0;
			//textBox.color = _colorOFF;
			//textBox.color = 0x00FF00;
		}
		
		public function get select():Boolean{
			return selected;
		}

		
		override public function dispose():void{
			_fundo.dispose();
			_errado.dispose();
			_certo.dispose();
		}
	}
}
