package com.flashgangsta.ui {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01
	 */
	
	public class Label extends Sprite {
		
		private var label:TextField;
		
		public function Label() {
			label = getChildByName( "label_txt" ) as TextField;
			label.mouseEnabled = false;
			label.mouseWheelEnabled = false;
		}
		
		/**
		 * 
		 */
		
		public function get text():String {
			return label.text;
		}
		
		public function set text(value:String):void {
			label.text = value;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			
		}
		
	}

}