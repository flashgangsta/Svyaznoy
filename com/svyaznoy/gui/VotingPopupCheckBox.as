package com.svyaznoy.gui {
	import com.flashgangsta.ui.CheckBox;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class VotingPopupCheckBox extends CheckBox {
		
		private var iconBackground:Sprite;
		
		/**
		 * 
		 */
		
		public function VotingPopupCheckBox() {
			iconBackground = getChildByName( "iconBackground_mc" ) as Sprite;
			addEventListener( Event.CHANGE, onChanged );
			selected = false;
		}
		
		override public function dispose():void {
			super.dispose();
			removeEventListener( Event.CHANGE, onChanged );
			iconBackground = null;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onChanged( event:Event ):void {
			dispatchEvent( new Event( Event.SELECT, true ) );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getIconBackground():DisplayObject {
			return iconBackground.getChildAt( 0 );
		}
		
	}

}