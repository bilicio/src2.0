/*

Copyright (c) 2013-2014, Jean-Philippe Côté (www.cote.cc)
All rights reserved.

This library is provided "as is" with no guarantees whatsoever. Use it at your own risk.

*/

package cc.cote.feathers.softkeyboard.layouts
{
	import cc.cote.feathers.softkeyboard.CharCode;
	import cc.cote.feathers.softkeyboard.Key;

	/**
	 * The <code>Qwerty</code> class defines a basic qwerty-inspired keyboard layout.
	 */
	public class Qwerty extends Layout
	{
		
		/** The label to use on <code>SWITCH_LAYOUT</code> keys pointing to this layout. */
		public static const SWITCH_KEY_LABEL:String = 'ABC';
		
		public var _width:Number = 320;
		public var _height:Number = 160;
		
		private var conta:Number = 0;
		private var divider:Number = 25;
		
		/** 
		 * Creates a new Qwerty object.
		 */
		public function Qwerty(multiplier:Number = 1):void {
			
			conta = _width * multiplier;
				
			// Define all rows of keys for that layout
			rows = new <Vector.<Key>>[
				new <Key>[
					new Key(CharCode.UPPERCASE_Q, conta/divider),
					new Key(CharCode.UPPERCASE_W, conta/divider),
					new Key(CharCode.UPPERCASE_E, conta/divider),
					new Key(CharCode.UPPERCASE_R, conta/divider),
					new Key(CharCode.UPPERCASE_T, conta/divider),
					new Key(CharCode.UPPERCASE_Y, conta/divider),
					new Key(CharCode.UPPERCASE_U, conta/divider),
					new Key(CharCode.UPPERCASE_I, conta/divider),
					new Key(CharCode.UPPERCASE_O, conta/divider),
					new Key(CharCode.UPPERCASE_P, conta/divider)
				],
				new <Key>[
					new Key(CharCode.TAB, conta/divider, null, Key.NAVIGATION_KEY, 'TAB', 1.55),
					new Key(CharCode.UPPERCASE_A, conta/divider),
					new Key(CharCode.UPPERCASE_S, conta/divider),
					new Key(CharCode.UPPERCASE_D, conta/divider),
					new Key(CharCode.UPPERCASE_F, conta/divider),
					new Key(CharCode.UPPERCASE_G, conta/divider),
					new Key(CharCode.UPPERCASE_H, conta/divider),
					new Key(CharCode.UPPERCASE_J, conta/divider),
					new Key(CharCode.UPPERCASE_K, conta/divider),
					new Key(CharCode.UPPERCASE_L, conta/divider)
				],
				new <Key>[
					new Key(CharCode.CAPS_LOCK, conta/divider, null, Key.SYSTEM_KEY, 'CAPSLOCK', 1.55),
					new Key(CharCode.UPPERCASE_Z, conta/divider),
					new Key(CharCode.UPPERCASE_X, conta/divider),
					new Key(CharCode.UPPERCASE_C, conta/divider),
					new Key(CharCode.UPPERCASE_V, conta/divider),
					new Key(CharCode.UPPERCASE_B, conta/divider),
					new Key(CharCode.UPPERCASE_N, conta/divider),
					new Key(CharCode.UPPERCASE_M, conta/divider),
					new Key(CharCode.BACKSPACE, conta/divider, null, Key.EDITING_KEY, 'BACKSPACE', 1.55)
				],
				new <Key>[
					new Key(CharCode.SPACE, conta/divider, null, Key.CHARACTER_KEY, '', 7),
					new Key(CharCode.RETURN, conta/divider, null, Key.EDITING_KEY, 'RETURN', 2.5)
				]
			];
			
		}
		
		public function get width():Number {
			return _width;
		}
		
		/** @private */
		public function set width(value:Number):void {
			_width = value;
		}
		
		public function get height():Number {
			return _height;
		}
		
		/** @private */
		public function set height(value:Number):void {
			_height = value;
		}
		
	}
	
}

