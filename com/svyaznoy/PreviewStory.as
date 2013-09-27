package com.svyaznoy {
	import com.svyaznoy.utils.ColorChanger;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewStory extends PreviewItem {
		
		private var border:DisplayObject;
		private var messageLabel:TextField;
		private var descriptionLabel:TextField;
		
		public function PreviewStory() {
			border = getChildByName( "border_mc" );
			messageLabel = getChildByName( "messageLabel_txt" ) as TextField;
			descriptionLabel = getChildByName( "descriptionLabel_txt" ) as TextField;
			hit = getChildByName( "hit_mc" );
			
			descriptionLabel.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * 
		 */
		
		public function set message( value:String ):void {
			messageLabel.text = value;
		}
		
		/**
		 * 
		 */
		
		public function set description( value:String ):void {
			descriptionLabel.text = value;
			hit.height = Math.ceil( descriptionLabel.y + descriptionLabel.height );
			updateHitSize();
		}
		
		/**
		 * 
		 */
		
		public function updateColor():void {
			ColorChanger.setColorByIndex( border, parent.getChildIndex( this ) );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
		}
	}

}