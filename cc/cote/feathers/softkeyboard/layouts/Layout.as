/*

Copyright (c) 2013-2014, Jean-Philippe Côté (www.cote.cc)
All rights reserved.

This library is provided "as is" with no guarantees whatsoever. Use it at your own risk.

*/

package cc.cote.feathers.softkeyboard.layouts
{
	import cc.cote.feathers.softkeyboard.Key;

	/**
	 * The <code>Layout</code> class is meant to be extended to create custom keyboard layouts. It 
	 * contains a few properties that all layouts shoud contain.
	 */
	public class Layout
	{
		
		/** 
		 * Vector of rows defined for the layout. Each row is itself a vector of <code>Key</code>
		 * objects.
		 */
		public var rows:Vector.<Vector.<Key>>;
		
		/** Vertical gap between keys (expressed as a ratio to the default key height). */
		public var verticalGap:Number = .1;

		/** Horizontal gap between keys (expressed as a ratio to the default key width) */
		public var horizontalGap:Number = .1;
		
		/** Indicates whether the caps lock key is initially engaged (true) or not (false) */
		public var capsLock:Boolean = false;
		
		/** Spacer key (fake key to leave space in a keyboard layout) */
		public var spacer:Key;
		
		/** Constructor */
		public function Layout():void {}
		
	}
	
}