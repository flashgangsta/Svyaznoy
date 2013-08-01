package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.NavigationEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Legend extends ScreenWithBottomButton {
		
		public function Legend() {
			var helper:Helper = Helper.getInstance();
			provider.getLegend();
			provider.addEventListener( ProviderEvent.ON_LEGEND, onData );
			
			if ( !helper.isEmployeeMode ) {
				removeChild( bottomButton );
			} else {
				bottomButton.addEventListener( MouseEvent.CLICK, onBottomButtonClicked )
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			provider.removeEventListener( ProviderEvent.ON_LEGEND, onData );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBottomButtonClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new NavigationEvent( NavigationEvent.NAVIGATE_TO_THERMS_OF_MOTIVATION ) );
		}
		
	}

}