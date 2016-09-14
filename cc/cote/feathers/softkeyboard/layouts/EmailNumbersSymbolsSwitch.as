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
	 * The <code>EmailNumbersSymbolsSwitch</code> class defines a keyboard layout containing all 10 
	 * digits and the symbols allowed in email addresses. It also features a 
	 * <code>SWITCH_LAYOUT</code> key.
	 * 
	 * <p>The referencee used to determine which symbols should be included is the following: 
	 * http://en.wikipedia.org/wiki/E-mail_address#RFC_specification</p>
	 */
	public class EmailNumbersSymbolsSwitch extends Layout
	{
		
		/** The label to use on <code>SWITCH_LAYOUT</code> keys pointing to this layout. */
		public static const SWITCH_KEY_LABEL:String = '123 &+$';
		
		
		public var _width:Number = 320;
		public var _height:Number = 160;
		
		private var conta:Number = 0;
		private var divider:Number = 25;
		/** 
		 * Creates a new EmailNumbersSymbolsSwitch object.
		 * 
		 * @param switchKeyClass The class to use with the <code>SWITCH_KEY</code> defined by this
		 * layout.
		 */
		public function EmailNumbersSymbolsSwitch(switchKeyClass:Class, multiplier:Number = 1):void {
			
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
					new Key(CharCode.BACKSPACE, conta/divider, null, Key.EDITING_KEY, 'BACKSPACE', 2.5)
				],
				new <Key>[
					new Key(CharCode.HYPHEN, conta/divider),
					new Key(CharCode.UNDERSCORE, conta/divider),
					new Key(CharCode.PLUS, conta/divider),
					new Key(CharCode.EQUAL, conta/divider),
					new Key(CharCode.SLASH, conta/divider),
					new Key(CharCode.TILDE, conta/divider),
					new Key(CharCode.LEFT_BRACE, conta/divider), 
					new Key(CharCode.RIGHT_BRACE, conta/divider),
					new Key(CharCode.DOLLAR, conta/divider),
					new Key(CharCode.AMPERSAND, conta/divider),
					new Key(CharCode.BACKTICK, conta/divider),
					new Key(CharCode.CIRCUMFLEX_ACCENT)
				],
				new <Key>[
					new Key(CharCode.AT_SIGN, conta/divider),
					new Key(CharCode.PIPE, conta/divider),
					new Key(CharCode.QUESTION_MARK, conta/divider),
					new Key(CharCode.EXCLAMATION_MARK, conta/divider),
					new Key(CharCode.HASH, conta/divider),
					new Key(CharCode.PERCENT, conta/divider),
					new Key(CharCode.ASTERISK, conta/divider),
					new Key(CharCode.APOSTROPHE, conta/divider),
					new Key(CharCode.PERIOD, conta/divider),
					new Key(CharCode.SWITCH_LAYOUT, conta/divider, null, Key.SYSTEM_KEY, switchKeyClass.SWITCH_KEY_LABEL, 2.5, 1, switchKeyClass)
				]
			];
			
		}					
		
	}
	
}

