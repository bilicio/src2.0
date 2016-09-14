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
	 * The <code>QwertySwitch</code> class defines a basic qwerty-inspired keyboard layout. It also
	 * provides a <code>SWITCH_LAYOUT</code> key.
	 */
	public class QwertySwitch extends Layout
	{
		
		/** The label to use on <code>SWITCH_LAYOUT</code> keys pointing to this layout. */
		public static const SWITCH_KEY_LABEL:String = 'ABC';
			
		public var _width:Number = 320;
		public var _height:Number = 160;
		
		private var conta:Number = 0;
		private var divider:Number = 25;
		/** 
		 * Creates a new <code>QwertySwitch</code> object.
		 * 
		 * @param switchKeyClass The class to instantiate when the <code>SWITCH_LAYOUT</code> key is
		 * pressed.
		 */
		public function QwertySwitch(switchKeyClass:Class, multiplier:Number = 1):void {
			
			conta = _width * multiplier;
				
			// Define all rows of keys for that layout
			rows = new <Vector.<Key>>[
				new <Key>[
					new Key(CharCode.DIGIT_1, conta/divider),
					new Key(CharCode.DIGIT_2, conta/divider),
					new Key(CharCode.DIGIT_3, conta/divider),
					new Key(CharCode.DIGIT_4, conta/divider),
					new Key(CharCode.DIGIT_5, conta/divider),
					new Key(CharCode.DIGIT_6, conta/divider),
					new Key(CharCode.DIGIT_7, conta/divider),
					new Key(CharCode.DIGIT_8, conta/divider),
					new Key(CharCode.DIGIT_9, conta/divider),
					new Key(CharCode.DIGIT_0, conta/divider),
				],
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
					new Key(CharCode.UPPERCASE_P, conta/divider),
				],
				new <Key>[
					new Key(CharCode.UNDERSCORE, conta/divider),
					new Key(CharCode.UPPERCASE_A, conta/divider),
					new Key(CharCode.UPPERCASE_S, conta/divider),
					new Key(CharCode.UPPERCASE_D, conta/divider),
					new Key(CharCode.UPPERCASE_F, conta/divider),
					new Key(CharCode.UPPERCASE_G, conta/divider),
					new Key(CharCode.UPPERCASE_H, conta/divider),
					new Key(CharCode.UPPERCASE_J, conta/divider),
					new Key(CharCode.UPPERCASE_K, conta/divider),
					new Key(CharCode.UPPERCASE_L, conta/divider),
				],
				new <Key>[
					new Key(CharCode.HYPHEN, conta/divider),
					new Key(CharCode.UPPERCASE_Z, conta/divider),
					new Key(CharCode.UPPERCASE_X, conta/divider),
					new Key(CharCode.UPPERCASE_C, conta/divider),
					new Key(CharCode.UPPERCASE_V, conta/divider),
					new Key(CharCode.UPPERCASE_B, conta/divider),
					new Key(CharCode.UPPERCASE_N, conta/divider),
					new Key(CharCode.UPPERCASE_M, conta/divider),
					new Key(CharCode.BACKSPACE, conta/divider, null, Key.EDITING_KEY, '', 2.1,1,null, 6)
				],
				new <Key>[
					new Key(CharCode.AT_SIGN, conta/divider),
					new Key(CharCode.PERIOD, conta/divider),
					new Key(CharCode.DOTCOM, conta/divider, null, Key.EDITING_KEY, '.com', 1.65),
					new Key(CharCode.DOTBR, conta/divider, null, Key.EDITING_KEY, '.br', 1.65),
					new Key(CharCode.SPACE, conta/divider, null, Key.CHARACTER_KEY, 'espaço', 5.2)
				]
			];
			
		}					
		
	}
	
}

