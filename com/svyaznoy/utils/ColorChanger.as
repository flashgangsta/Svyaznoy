package com.svyaznoy.utils {
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ColorChanger {
		
		static private const COLORS:Vector.<uint> = new <uint>[ 0xA28BB3, 0xFFD868, 0xB4D58C, 0xFFAD5F, 0x8CC3E7 ];
		
		/**
		 * 
		 */
		
		public function ColorChanger() {
			
		}
		
		/**
		 * 
		 * @param	target
		 * @param	index
		 */
		
		static public function setColorByIndex( target:DisplayObject, index ):void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = getColorByIndex( index );
			target.transform.colorTransform = colorTransform;
		}
		
		/**
		 * 
		 * @param	index
		 * @return
		 */
		
		static private function getColorByIndex( index:int ):uint {
			return COLORS[ index % COLORS.length ];
		}
		
	}

}