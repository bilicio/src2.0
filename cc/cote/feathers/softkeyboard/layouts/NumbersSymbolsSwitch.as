/*

Copyright (c) 2013-2014, Jean-Philippe Côté (www.cote.cc)
All rights reserved.

This library is provided "as is" with no guarantees whatsoever. Use it at your own risk.

*/

package cc.cote.feathers.softkeyboard.layouts
{
	import cc.cote.feathers.softkeyboard.CharCode;
	import cc.cote.feathers.softkeyboard.Key;
	import cc.cote.feathers.softkeyboard.keycollections.SymbolKeyVariants;
	
	/**
	 * The <code>NumbersSymbolsSwitch</code> class defines a keyboard layout containing all 10 
	 * digits and the most useful symbol characters (including many key variants). It also features
	 * a <code>SWITCH_LAYOUT</code> key.
	 */
	public class NumbersSymbolsSwitch extends Layout
	{
		
		/** The label to use on <code>SWITCH_LAYOUT</code> keys pointing to this layout. */
		public static const SWITCH_KEY_LABEL:String = '123 @$?';
		
		public var _width:Number = 320;
		public var _height:Number = 160;
		
		private var conta:Number = 0;
		private var divider:Number = 24;
		/** 
		 * Creates a new NumbersSymbolsSwitch object.
		 * 
		 * @param switchKeyClass The class to use with the <code>SWITCH_KEY</code> defined by this
		 * layout.
		 */
		public function NumbersSymbolsSwitch(switchKeyClass:Class, multiplier:Number = 1):void {
			
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
					new Key(CharCode.DIGIT_0, conta/divider)
				],
				new <Key>[
					new Key(CharCode.HYPHEN, conta/divider, SymbolKeyVariants.MINUS),
					new Key(CharCode.SLASH, conta/divider, SymbolKeyVariants.SLASH),
					new Key(CharCode.COLON, conta/divider, SymbolKeyVariants.COLON),
					new Key(CharCode.TILDE, conta/divider),
					new Key(CharCode.LEFT_PARENTHESIS, conta/divider, SymbolKeyVariants.LEFT_PARENTHESIS), 
					new Key(CharCode.RIGHT_PARENTHESIS, conta/divider, SymbolKeyVariants.RIGHT_PARENTHESIS),
					new Key(CharCode.DOLLAR, conta/divider, SymbolKeyVariants.DOLLAR_SIGN),
					new Key(CharCode.AMPERSAND, conta/divider),
					new Key(CharCode.APOSTROPHE, conta/divider),
					new Key(CharCode.QUOTE, conta/divider)
				],
				new <Key>[
					new Key(CharCode.AT_SIGN, conta/divider, SymbolKeyVariants.AT_SIGN),
					new Key(CharCode.PERIOD, conta/divider),
					new Key(CharCode.COMMA, conta/divider),
					new Key(CharCode.QUESTION_MARK, conta/divider, SymbolKeyVariants.QUESTION_MARK),
					new Key(CharCode.EXCLAMATION_MARK, conta/divider, SymbolKeyVariants.EXCLAMATION_MARK),
					new Key(CharCode.HASH, conta/divider),
					new Key(CharCode.CIRCUMFLEX_ACCENT, conta/divider),
					new Key(CharCode.BACKTICK, conta/divider),
					new Key(CharCode.PERCENT, conta/divider, SymbolKeyVariants.PERCENT),
					new Key(CharCode.ASTERISK, conta/divider,  SymbolKeyVariants.ASTERISK),
					new Key(CharCode.BACKSPACE, conta/divider, null, Key.EDITING_KEY, 'BACKSPACE', 1.55)
				],
				new <Key>[
					new Key(CharCode.SWITCH_LAYOUT, conta/divider, null, Key.SYSTEM_KEY, switchKeyClass.SWITCH_KEY_LABEL, 2.5, 1, switchKeyClass),
					new Key(CharCode.SPACE, conta/divider, null, Key.CHARACTER_KEY, '', 5),
					new Key(CharCode.RETURN, conta/divider, null, Key.EDITING_KEY, 'RETURN', 2.5)
				]
			];
			
		}					
		
	}
	
}

