package com.svyaznoy {
	import com.flashgangsta.utils.TimeConverter;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TimePreview extends Sprite {
		
		private var background:DisplayObject;
		private var label:TextField;
		
		public function TimePreview() {
			background = getChildAt( 0 );
			label = getChildByName( "label_txt" ) as TextField;
			
			label.autoSize = TextFieldAutoSize.CENTER;
			visible = false;
		}
		
		public function setDurationBySeconds( seconds:int ):void {
			label.text = TimeConverter.getTime( seconds );
			background.width = Math.ceil( label.width );
		}
		
		override public function get height():Number {
			return background.height;
		}
		
	}

}