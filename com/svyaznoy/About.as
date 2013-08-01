package com.svyaznoy {
	import com.svyaznoy.events.ProviderEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class About extends ScreenWithDynamicContent {
		
		/**
		 * 
		 */
		
		public function About() {
			provider.getAbout();
			provider.addEventListener( ProviderEvent.ON_ABOUT, onData );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			provider.removeEventListener( ProviderEvent.ON_ABOUT, onData );
		}
		
	}

}