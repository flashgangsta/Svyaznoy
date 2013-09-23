package com.svyaznoy {
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.ProviderEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class EmployeePhotoComments extends Comments {
		private var departureID:int;
		private var photoID:int;
		
		public function EmployeePhotoComments( departureID:int, photoID:int ) {
			this.photoID = photoID;
			this.departureID = departureID;
			
			addEventListener( CommentsEvent.ADD_COMMENT_CALLED, onAddCalled );
			addEventListener( CommentsEvent.ON_OLD_COMMENTS_CALLED, onOldCommentsCalled );
			
			countLoader = provider.getEmployeePhotosCommentsCount( departureID, photoID );
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
				listLoader = provider.getEmployeePhotosCommentsList( departureID, photoID );
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
			addLoader = provider.addEmployeePhotosComment( departureID, photoID, getMessage() );
			addLoader.addEventListener( ProviderEvent.ON_COMMENT_ADDED, onAdded );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onOldCommentsCalled( event:CommentsEvent ):void {
			listLoader = provider.getEmployeePhotosCommentsList( departureID, photoID, 10, 0, 0, event.lastCommentID );
			listLoader.addEventListener( ProviderEvent.ON_COMMENTS_LIST, onOldCommentsList );
		}
		
	}

}