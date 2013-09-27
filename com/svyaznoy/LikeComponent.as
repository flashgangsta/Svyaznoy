package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.LabelWithIcon;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class LikeComponent extends Sprite {
		
		private var button:LikeButton;
		private var data:Object;
		
		/**
		 * 
		 */
		
		public function LikeComponent( data:Object ) {
			this.data = data;
			button = getChildByName( "button_mc" ) as LikeButton;
			button.addEventListener( MouseEvent.CLICK, onClicked );
		}
		
		private function onClicked( event:MouseEvent ):void {
			visible = false;
			data.is_can_be_voted = false;
		}
		
		public function dispose():void {
			
		}
		
		/**
		 * 
		 */
		
		public function set likes( value:String ):void {
			button.likes = value;
		}
	}
}