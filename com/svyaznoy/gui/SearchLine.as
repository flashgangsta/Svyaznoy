package com.svyaznoy.gui {
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class SearchLine extends Sprite {
		
		private var label:TextField;
		private var input:TextField;
		private var _value:String;
		
		public function SearchLine() {
			label = getChildByName( "label_txt" ) as TextField;
			input = getChildByName( "input_txt" ) as TextField;
			
			label.mouseEnabled = label.mouseWheelEnabled = false;
			
			input.addEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			input.addEventListener( FocusEvent.FOCUS_IN, onFocusOut );
		}
		
		/**
		 * 
		 */
		
		public function get value():String {
			return input.text;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onFocusIn( event:FocusEvent ):void {
			label.visible = false;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onFocusOut( event:FocusEvent ):void {
			input.visible = !input.length;
		}
		
		
		
	}

}