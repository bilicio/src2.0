package classes.antidoto.componentes
{
	
	import classes.antidoto.Assets;
	import classes.antidoto.PegaTemperatura;
	
	import feathers.controls.Label;
	import feathers.system.DeviceCapabilities;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;

	public class bulletClima extends Sprite
	{
		private var _x:Number;
		private var _y:Number;
		private var _w:Number;
		private var _h:Number;
		private var _bgColor:uint;
		
		private static const diasSemana:Array = new Array('Domingo', 'Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 'Sabado');
		
		private var diaSem:Label;
		private var tempMin:Label;
		private var tempMax:Label;
		private var img_Clima:Image;
		private var dpi:Number;
		
		public function bulletClima(y:Number, h:Number, bgColor:uint)
		{
			dpi = DeviceCapabilities.dpi / 326
			

			trace(y + " | " + y*dpi + 'capa: ' + (DeviceCapabilities.dpi/326));
			
			this.x = 10;
			this.y = y;
			_h = h * dpi;
			_bgColor = bgColor;
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, criaComponente);
		}
		
		private function criaComponente(evt:starling.events.Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, criaComponente);
			
			_w = this.stage.stageWidth-20;
			
			var rect:Shape = new Shape();
			rect.graphics.beginFill(_bgColor, 1); //Last arg is the alpha
			rect.graphics.drawRoundRect(0, 0, _w, _h, 10);
			rect.graphics.endFill();
			this.addChild(rect);
			
			diaSem = new Label();
			diaSem.nameList.add('label-data');
			diaSem.x = 20;
			diaSem.y = _h/2 - 33 * dpi;
			this.addChild(diaSem);
			
			tempMin = new Label();
			tempMin.nameList.add('label-temp-min');
			tempMin.x = _w - 195* dpi;
			tempMin.y = _h/2 - 33 * dpi;
			this.addChild(tempMin);
			
			tempMax = new Label();
			tempMax.nameList.add('label-temp-max');
			tempMax.x = _w - 88* dpi;
			tempMax.y = _h/2 - 33 * dpi;
			this.addChild(tempMax);
			
			pegaData();
			
		}
		
		private function pegaData():void
		{
			var data:Date = new Date();
			diaSem.text = 'New York - USA\n' + data.date + ", " + diasSemana[data.day] ;
			
			pegaTemperatura();
			
		}

		protected function pegaTemperatura():void
		{
			var xmlClima:PegaTemperatura = new PegaTemperatura(recebe);
		}
		
		private function recebe(tMin:String, tMax:String, img:String):void{
			tempMin.text = tMin + ' | ';
			tempMax.text = tMax;
			
			if(img == null || img == ''){
				img_Clima = new Image(Assets.am.getTexture('nublado'));
			}else{
				try{
					img_Clima = new Image(Assets.am.getTexture(img));
				}catch(e:Error){};
			}
			
			
			img_Clima.x = _w/2 - img_Clima.width/2;
			img_Clima.y = _h/2 - img_Clima.height/2;
			addChild(img_Clima);
		}
		
		override public function dispose():void{
			if(img_Clima){	
				img_Clima.dispose();
			}
		}
	}
}