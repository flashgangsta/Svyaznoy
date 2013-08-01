package com.svyaznoy {
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenWithHeader extends Screen {
		
		protected var header:Header;
		
		/**
		 * 
		 */
		
		public function ScreenWithHeader() {
			header = getChildByName( "header_mc" ) as Header;
			header.addEventListener( DynamicItemEvent.SIZE_CHANGED, onHeaderImageSizeChanged );
			addChild( header );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onHeaderImageSizeChanged( event:DynamicItemEvent ):void {
			dispatchHeighUpdated();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			header.displayData( data );
		}
		
	}

}