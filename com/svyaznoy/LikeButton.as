package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.LabelWithIcon;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class LikeButton extends Button {
		
		private var likesLabel:LabelWithIcon;
		
		public function LikeButton() {
			likesLabel = getChildByName( "icon_mc" ) as LabelWithIcon;
		}
		
		/**
		 * 
		 */
		
		public function set likes( value:String ):void {
			likesLabel.value = value;
		}
		
	}

}