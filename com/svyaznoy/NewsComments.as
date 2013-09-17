package com.svyaznoy {
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.utils.DateParser;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class NewsComments extends Comments {
		
		private var id:int;
		
		public function NewsComments( id:int ) {
			this.id = id;
			
			addEventListener( CommentsEvent.ADD_COMMENT_CALLED, onAddCalled );
			
			countLoader = provider.getNewsCommentsCount( id );
			countLoader.addEventListener( ProviderEvent.ON_COMMENTS_COUNT, onCount );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onCount( event:ProviderEvent ):void {
			countLoader.removeEventListener( ProviderEvent.ON_COMMENTS_COUNT, onCount );
			super.onCount( event );
			if ( count ) {
				listLoader = provider.getNewsCommentsList( id, 10, commentsDatasList.length );
				listLoader.addEventListener( ProviderEvent.ON_COMMENTS_LIST, onComments );
			}
		}
		
		override protected function onComments(event:ProviderEvent):void {
			listLoader.removeEventListener( ProviderEvent.ON_COMMENTS_LIST, onComments );
			super.onComments( event );
		}
		
		override protected function onAdded( event:ProviderEvent ):void {
			addLoader.removeEventListener( ProviderEvent.ON_COMMENT_ADDED, onAdded );
			super.onAdded( event );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			if ( countLoader && countLoader.hasEventListener( ProviderEvent.ON_COMMENTS_COUNT ) ) {
				countLoader.removeEventListener( ProviderEvent.ON_COMMENTS_COUNT, onCount );
			}
			
			if ( listLoader && listLoader.hasEventListener( ProviderEvent.ON_COMMENTS_LIST ) ) {
				listLoader.removeEventListener( ProviderEvent.ON_COMMENTS_LIST, onComments );
			}
			
			if ( addLoader && addLoader.hasEventListener( ProviderEvent.ON_COMMENT_ADDED ) ) {
				addLoader.removeEventListener( ProviderEvent.ON_COMMENT_ADDED, onAdded );
			}
			
			super.dispose();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddCalled( event:CommentsEvent ):void {
			trace( "addComment:", getMessage() );
			addLoader = provider.addNewsComment( id, getMessage() );
			addLoader.addEventListener( ProviderEvent.ON_COMMENT_ADDED, onAdded );
		}
		
	}

}