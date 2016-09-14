package classes.antidoto.componentes
{

	import com.greensock.TweenMax;
	
	import flash.geom.Vector3D;
	
	import classes.antidoto.MyImageLoader2;
	
	import starling.display.Sprite3D;
	import starling.events.Event;

	
	//------------------------------------------------------- Eventos de retorno de função
	[Event(name="openPage",type="starling.events.Event")]
	[Event(name="cargaCompleta",type="starling.events.Event")]

	public class ModuloCard3D extends Sprite3D
	{
		public static const OPEN_PAGE:String = "openPage";
		public static const FINISHED:String = "cargaCompleta";
		
		public static const TURNED:String = "turned";
		
		public var _cod:Number;

		private var _props:Object;
		
		private var _front:MyImageLoader2;
		private var _back:MyImageLoader2;
		
		private static var sHelperPoint3D:Vector3D = new Vector3D();

		public function ModuloCard3D(props:Object)
		{
			_cod = props.cod;
			
			_props = props;
			
			_front = _props.tex2;
			_back = _props.tex1;
			
			initializeHandler()
		}

		
		protected function initializeHandler():void
		{
			
			_front.alignPivot();
			_back.alignPivot();
			//_front.pivotX = 113;
			_front.scaleX=-1
			//_back.pivotX = 104;

			addChild(_front);
			addChild(_back);
			
			
			
		}
		
		public function updateVisibility():void
		{
			stage.getCameraPosition(this, sHelperPoint3D);
			
			_front.visible = sHelperPoint3D.z >= 0;
			_back.visible  = sHelperPoint3D.z <  0;

		}
		
		public function vira():void{
			if(this.rotationY == 0){
				TweenMax.to(this, 1,{rotationY:Math.PI, onComplete:endTurn});
			}else{
				TweenMax.to(this, 1,{rotationY:0, onComplete:endTurn});
			}
			addEventListener(Event.ENTER_FRAME, updateVisibility);
			
			
		}
		
		private function endTurn():void{
			removeEventListener(Event.ENTER_FRAME, updateVisibility);
			this.dispatchEventWith(TURNED, false, '');
		}


		public function build():void{
			updateVisibility();
		}
		
		

		
		//------------------------------------------------------- Dispose Menu
		override public function dispose():void{
			//trace('DISPOSE');
			_front.dispose();
			removeChild(_front)
			
			_back.dispose();
			removeChild(_back)
		}
	}
}
