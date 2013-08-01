package com.svyaznoy {
	import com.svyaznoy.events.NavigationEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ThermsOfMotivation extends ScreenWithBottomButton {
		
		public function ThermsOfMotivation() {
			provider.getThermsOfMotivation();
			provider.addEventListener( ProviderEvent.ON_THERMS_OF_MOTIVATION, onData );
			bottomButton.addEventListener( MouseEvent.CLICK, onBottomButtonClicked );
		}
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			provider.removeEventListener( ProviderEvent.ON_THERMS_OF_MOTIVATION, onData );
		}
		
		private function onBottomButtonClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new NavigationEvent( NavigationEvent.NAVIGATE_TO_LEGEND ) );
		}
		
	}

}