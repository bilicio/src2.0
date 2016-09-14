package classes.antidoto.componentes
{

	import flash.display.Sprite;
	import flash.display3D.Context3DClearMask;
	import flash.events.Event;
	
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Pivot3D;


	
	public class Modulo3D extends Sprite
	{

		[Embed(source = "/../../../assets/objects3d/vaca.zf3d", mimeType = "application/octet-stream")]
		private var Model:Class;
		
		private var scene:Scene3D;
		private var model:Pivot3D;

		
		public function Modulo3D()
		{
			
			this.width = 550;
			this.height = 350;
			
			scene = new Viewer3D( this );
			scene.autoResize = true;
			scene.clearColor.setTo( 1, 1, 1 );
			//scene.addEventListener( Event.CONTEXT3D_CREATE, contextCreateEvent );
			scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
			
			model = scene.addChildFromFile( new Model );
			
			scene.addChild(model);
			
			
		}
		
		private function contextCreateEvent(e:Event):void 
		{
		/*	starlingBack = new Starling( StarlingBack,stage,null,);
			starlingBack.start();
			
			starlingTop = new Starling( StarlingTop, stage, null, stage.stage3Ds[ scene.stageIndex ] );
			starlingTop.start();*/
		}
		
		private function renderEvent(e:Event):void 
		{
			scene.context.enableErrorChecking = true;
			
			// prevents the 3d scene to render.
			// we'll handle the render by our own.
			//e.preventDefault();
			
			// draw starling background.
			//starlingBack.nextFrame();
			
			// starling writes the depth buffer, so we need to clear it before draw the 3D stuff.
			//scene.context.clear( 0, 0, 0, 1, 1, 0, Context3DClearMask.DEPTH );
			
			// render 3D scene.
			scene.render();
			
			

			
			// draw starling ui.
			//starlingTop.nextFrame();
		}
		

		
		
		/*override public function dispose():void{
			
		}*/
	}
}