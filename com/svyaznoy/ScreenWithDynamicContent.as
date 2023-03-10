package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenWithDynamicContent extends ScreenWithHeader {
		
		///
		protected var dynamicContentViewer:DynamicContentViewer = new DynamicContentViewer();
		
		/**
		 * 
		 */
		
		public function ScreenWithDynamicContent() {
			dynamicContentViewer.width = header.width;
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
			dynamicContentViewer.y = MappingManager.getBottom( header, this );
			addChild( dynamicContentViewer );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			displayData();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			
			dynamicContentViewer.clear();
			
			if ( data.hasOwnProperty( "content" ) && data.content ) {
				dynamicContentViewer.displayData( data.content );
			} else {
				//dispatchEvent( new DynamicItemEvent( DynamicItemEvent.SIZE_CHANGED ) );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			dynamicContentViewer.y = MappingManager.getBottom( header, this );
			updatePositions( DynamicContentViewer.MARGIN, dynamicContentViewer );
		}
		
	}

}