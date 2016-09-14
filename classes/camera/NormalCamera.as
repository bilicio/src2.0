package classes.camera
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display3D.textures.Texture;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.media.Camera;
    import flash.media.CameraPosition;
    import flash.media.Video;

    /**
     * Handles the display of a camera in Starling
     *
     * @author mtanenbaum
     *
     * @internal
     * Argonaut is released under the MIT License
     * Copyright (C) 2012, Marc Tanenbaum
     *
     * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
     * files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
     * modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
     * Software is furnished to do so, subject to the following conditions:
     *
     * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
     *
     * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
     * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
     * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
     * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
     */
    public class NormalCamera extends Sprite
    {
        /** Minimum allowable downsample size */
        private static const DOWNSAMPLE_MIN:Number = 0.001;

        /** Maximum frame rate (not acutally enforced, just generates a warning) */
        private static const MAX_FRAME_RATE:int = 99;

        //Native
        private var camera:Camera;
        private var _video:Video;
        private var bmd:BitmapData;

        //Configs
        private var screenRect:Rectangle;
        private var fps:uint = 24;
        private var downSample:Number = 1;
        private var rotate:Boolean = false;
        private var matrix:Matrix;
        private var _mirror:Boolean = false;
		
		private const w:int = 1334;
		private const h:int = 750;

		private var retv:BitmapData
        /**
         * Class constructor
         */
        public function NormalCamera()
        {
        }

        /**
         * Set up the capture parameters
         *
         * @param screenRect The "viewport" for the camera
         * @param fps		 A uint 0-n for the camera speed. Lower fps will of course improve performance
         * @param downSample A value >0 && <=1 for reducing the size of the image. Can drastically improve performance at the cost of image quality
         * @param rotate	 Fix for bug on Air for IOS/Android. Set to true when on these platforms to correct rotation
         */
        public function init(fps:uint = 24, downSample:Number = 1, rotate:Boolean = false):void
        {
            trace("CameraView in rotate mode", rotate);

            this.fps = fps;
            if (fps == 0)
            {
                trace("WARNING::You're setting camera fps to 0. That's kinda lame.");
            }
            else if (fps > MAX_FRAME_RATE)
            {
                trace("WARNING::You're setting camera fps to", fps, "which is processor-intensive and probably too high to be useful.");
            }

            //Clamp the downsample between .1% and 1
            this.downSample = Math.max(DOWNSAMPLE_MIN, downSample);
            this.downSample = Math.min(1, this.downSample);

            this.rotate = rotate;

            matrix = new Matrix();
            matrix.scale(downSample, downSample);
            if (_mirror)
            {
                matrix.a *= -1;
                matrix.tx = (matrix.tx == 0) ? screenRect.width : 0;
            }

            if (rotate)
            {
               matrix.rotate(Math.PI/2);
            }
        }

        /**
         * Stop updates
         */
        public function shutdown():void
        {
          //  video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
        }

        /**
         * Pick a camera by id
         */
        public function selectCamera():void
        {
			_video = new Video(w, h);
			addChild(_video);
			//_video.rotation = 90; 						
			//_video.x += 700;
			//var _camera:Camera = tryGetFrontCamera();
			var _camera:Camera = Camera.getCamera('0');
			if (_camera == null) {
				trace("You can't run this sample without a camera :)");				
			} else {
				_camera.setMode(w, h, 25);
				_camera.setQuality(0, 100);
				_video.attachCamera(_camera);
				_video.parent.setChildIndex(_video, 0);			
			}
        }
		
		private function tryGetFrontCamera():Camera {

			var numCameras:uint = (Camera.isSupported) ? Camera.names.length : 0;
			for (var i:uint = 0; i < numCameras; i++) {
				var cam:Camera = Camera.getCamera(String(i));
				if (cam && cam.position == CameraPosition.BACK) {
					return cam;
				}
			} 

			return Camera.getCamera();
		}

        /**
         * Toggle the camera between reflecting & not
         *
         * Mirorring is false by default, so if you want it on, call this method directly after <code>init()</code>
         */
        public function reflect():void
        {
            _mirror = !_mirror;
            if (matrix)
            {
                matrix.a *= -1;
                matrix.tx = (_mirror) ? (screenRect.width * downSample) : 0;
            }
        }

        /**
         * Get the current reflection setting
         */
        public function get mirror():Boolean
        {
            return _mirror;
        }

        /**
         * Retrieve a still from the camera
         *
         * This method doesn't downsample, so your image is full resolution
         *
         * @return a BitmapData snapshot from the camera
         */
     /*   public function getImage():BitmapData
        {
            retv = new BitmapData(screenRect.width, screenRect.height);
            var m:Matrix = matrix.clone();
            m.scale(1/downSample, 1/downSample);

            retv.draw(video, m);
            return retv;
        }*/

        /**
         * Draw to the GPU every frame
         */
       /* private function onVideoUpdate(event:*):void
        {
           bmd.draw(video, matrix);
          // flash.display3D.textures.Texture(image.texture.base).uploadFromBitmapData(bmd);
        }*/
		
		public function dispose():void{
			//retv.dispose();
			if (_video)
			{
				_video.attachCamera(null);
				//_video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
				camera = null;
			}
			
			bmd.dispose();
			//video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
			_video.clear();
		}
    }
}