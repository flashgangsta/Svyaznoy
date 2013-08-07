package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class EmployeeFired extends Popup {
		
		private var enterHasGuestButton:Button;
		
		public function EmployeeFired() {
			enterHasGuestButton = getChildByName( "enterHasGuestButton_mc" ) as Button;
			enterHasGuestButton.addEventListener( MouseEvent.CLICK, onClicked );
			enterHasGuestButton.setLabel( "войти как гость".toUpperCase() );
		}
		
		private function onClicked( event:MouseEvent ):void {
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function dispose():void {
			super.dispose();
			enterHasGuestButton.removeEventListener( MouseEvent.CLICK, onClicked );
			enterHasGuestButton.dispose();
			enterHasGuestButton = null;
		}
		
	}

}