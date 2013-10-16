package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.NavigationEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Legend extends ScreenWithTopButton  {
		
		public function Legend() {
			var helper:Helper = Helper.getInstance();
			provider.getLegend();
			provider.addEventListener( ProviderEvent.ON_LEGEND, onData );
			
			if ( !helper.isEmployeeMode ) {
				removeChild( topButton );
			} else {
				topButton.addEventListener( MouseEvent.CLICK, onTopButtonClicked )
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			provider.removeEventListener( ProviderEvent.ON_LEGEND, onData );
			topButton.visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTopButtonClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new NavigationEvent( NavigationEvent.NAVIGATE_TO_THERMS_OF_MOTIVATION ) );
		}
		
	}

}