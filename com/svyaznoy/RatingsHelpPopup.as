package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class RatingsHelpPopup extends Popup {
		
		private var cancelButton:Button;
		
		public function RatingsHelpPopup() {
			cancelButton = getChildByName( "cancelButton_mc" ) as Button;
			cancelButton.addEventListener( MouseEvent.CLICK, onCancelClicked );
			cancelButton.setLabel( "ВЕРНУТЬСЯ К ПРИЛОЖЕНИЮ" );
		}
		
		override public function dispose():void {
			cancelButton.removeEventListener( MouseEvent.CLICK, onCancelClicked );
			cancelButton.dispose();
			super.dispose();
		}
		
		private function onCancelClicked( event:MouseEvent ):void {
			close();
		}
		
	}

}