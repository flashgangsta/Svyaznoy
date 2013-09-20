package com.svyaznoy {
	import com.flashgangsta.utils.ScreenController;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class News extends Screen {
		
		const MARGIN:int = 20;
		
		/**
		 * 
		 */
		
		public function News() {
			//TODO: сделать дозагрузску
			provider.getNewsList( 30 );
			provider.addEventListener( ProviderEvent.ON_NEWS_LIST, onData );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			var item:NewsListItem;
			
			super.onData( event );
			
			for ( var i:int = 0; i < data.length; i++ ) {
				item = new NewsListItem( data[ i ] );
				addChild( item );
			}
			
			updatePositions( MARGIN );
			
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
		}
		
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			updatePositions( MARGIN );
		}
		
	}

}