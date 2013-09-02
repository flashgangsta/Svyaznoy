package com.svyaznoy.gui {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class LabelWithIcon extends Sprite {
		
		private const MARGIN:int = 4;
		
		private var label:TextField;
		private var icon:Sprite;
		
		public function LabelWithIcon() {
			label = getChildByName( "label_txt" ) as TextField;
			icon = getChildByName( "icon_mc" ) as Sprite;
			value = "";
			label.autoSize = TextFieldAutoSize.RIGHT;
		}
		
		public function set value( value:String ):void {
			if ( value === this.value ) return;
			var oldWidth:Number = width;
			label.text = value;
			label.x = icon.width + MARGIN;
			x = Math.round( x + oldWidth - width );
			
		}
		
		public function get value():String {
			return label.text;
		}
		
	}

}