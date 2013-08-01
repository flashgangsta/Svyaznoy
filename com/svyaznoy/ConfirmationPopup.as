package com.svyaznoy {
	import com.svyaznoy.events.PopupEvent;
	import com.svyaznoy.gui.Button;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ConfirmationPopup extends Popup {
		
		protected var agreeButton:Button;
		protected var rejectButton:Button;
		
		/**
		 * 
		 */
		
		public function ConfirmationPopup() {
			isModal = true;
			
			agreeButton = getChildByName( "agree_mc" ) as Button;
			rejectButton = getChildByName( "reject_mc" ) as Button;
			
			agreeButton.addEventListener( MouseEvent.CLICK, onButtonClicked );
			rejectButton.addEventListener( MouseEvent.CLICK, onButtonClicked );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onButtonClicked( event:MouseEvent ):void {
			var button:Button = event.currentTarget as Button;
			var eventType:String;
			if ( button === agreeButton ) {
				eventType = PopupEvent.AGREE;
			} else if ( button === rejectButton ) {
				eventType = PopupEvent.REJECT;
			}
			
			dispatchEvent( new PopupEvent( eventType ) );
		}
		
	}

}