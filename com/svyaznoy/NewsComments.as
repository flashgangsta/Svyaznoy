package com.svyaznoy {
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.ProviderErrorEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.utils.DateParser;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class NewsComments extends Comments {
		
		private var id:int;
		
		/**
		 * 
		 * @param	id
		 */
		
		public function NewsComments( id:int ) {
			this.id = id;
			
			addEventListener( CommentsEvent.ADD_COMMENT_CALLED, onAddCalled );
			addEventListener( CommentsEvent.ON_OLD_COMMENTS_CALLED, onOldCommentsCalled );
			
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
				listLoader = provider.getNewsCommentsList( id );
				listLoader.addEventListener( ProviderEvent.ON_COMMENTS_LIST, onComments );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onComments( event:ProviderEvent ):void {
			listLoader.removeEventListener( ProviderEvent.ON_COMMENTS_LIST, onComments );
			super.onComments( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onAdded( event:ProviderEvent ):void {
			addLoader.removeEventListener( ProviderEvent.ON_COMMENT_ADDED, onAdded );
			super.onAdded( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onOldCommentsList( event:ProviderEvent ):void {
			listLoader.removeEventListener( ProviderEvent.ON_COMMENTS_LIST, onOldCommentsList );
			super.onOldCommentsList( event );
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
			
			removeEventListener( CommentsEvent.ON_OLD_COMMENTS_CALLED, onOldCommentsCalled );
			
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
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onOldCommentsCalled( event:CommentsEvent ):void {
			trace( "oldCommentsCalled from:", event.lastCommentID );
			listLoader = provider.getNewsCommentsList( id, 10, 0, 0, event.lastCommentID );
			listLoader.addEventListener( ProviderEvent.ON_COMMENTS_LIST, onOldCommentsList );
		}
		
	}

}