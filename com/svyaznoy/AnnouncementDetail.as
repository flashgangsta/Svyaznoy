package com.svyaznoy {
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AnnouncementDetail extends ScreenWithBottomButton {
		
		private const MARGIN:int = 10;
		
		public function AnnouncementDetail() {
			bottomButton.addEventListener( MouseEvent.CLICK, onBackButtonClicked );
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function showAnnouncement( id:int ):void {
			if ( data && data.id === id ) return;
			provider.addEventListener( ProviderEvent.ON_ANNOUNCEMENT, onData );
			provider.getAnnouncementByID( id );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			provider.removeEventListener( ProviderEvent.ON_ANNOUNCEMENT, onData );
			super.onData( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBackButtonClicked( event:MouseEvent ):void {
			dispatchEvent( new ScreenEvent( ScreenEvent.GO_BACK ) );
		}
	}

}