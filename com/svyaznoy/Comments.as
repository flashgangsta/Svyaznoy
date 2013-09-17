package com.svyaznoy {
	import com.flashgangsta.ui.Scrollbar;
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Comments extends EventDispatcher {
		
		protected var provider:Provider = Provider.getInstance();
		protected var listLoader:ProviderURLLoader;
		protected var countLoader:ProviderURLLoader;
		protected var addLoader:ProviderURLLoader;
		protected var count:int;
		protected var commentsDatasList:Vector.<Object> = new Vector.<Object>;
		
		private var _view:CommentsView = new CommentsView();
		private var input:CommentInput = new CommentInput();
		
		/**
		 * 
		 */
		
		public function Comments() {
			view.visible = false;
			
			updateInputPosition();
			view.addChild( input.view );
			
			view.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			input.view.addCommentButton.addEventListener( MouseEvent.CLICK, onAddCommentButtonClicked );
		}
		
		/**
		 * 
		 */
		
		public function get view():CommentsView {
			return _view;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			if ( view.hasEventListener( Event.ADDED_TO_STAGE ) ) {
				view.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
			
			if ( listLoader ) {
				listLoader.dispose();
				listLoader = null;
			}
			
			if ( countLoader ) {
				countLoader.dispose();
				countLoader = null;
			}
			
			if ( addLoader ) {
				addLoader.dispose();
				addLoader = null;
			}
			
			commentsDatasList = null;
			
			provider = null;
			
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		protected function onComments( event:ProviderEvent ):void {
			var list:Vector.<Object> = Vector.<Object>( event.data as Array );
			commentsDatasList = commentsDatasList.concat( list );
			
			for ( var i:int = list.length - 1; i >= 0; i-- ) {
				addComment( list[ i ] );
			}
			
			dispatchReady();
		}
		
		/**
		 * 
		 */
		
		protected function dispatchReady():void {
			view.visible = true;
			dispatchEvent( new CommentsEvent( CommentsEvent.ON_COMMENTS_READY ) );
		}
		
		/**
		 * 
		 */
		
		protected function getMessage():String {
			return input.getMessage();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		protected function onCount( event:ProviderEvent ):void {
			count = int( event.data );
			if ( !count ) {
				dispatchReady();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		protected function onAdded( event:ProviderEvent ):void {
			event.data.employee = {
				full_title: Helper.getInstance().getUserData().fullName
			}
			commentsDatasList.push( event.data );
			addComment( event.data );
		}
		
		/**
		 * 
		 */
		
		private function updateInputPosition():void {
			input.view.y = view.contentMask.y + Math.min( view.contentMask.height + 5, view.contentContainer.height );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			view.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			Scrollbar.setVertical( view.contentContainer, view.contentMask.getBounds( view ), view.scrollbarView.getUpBtn(), view.scrollbarView.getDownBtn(), view.scrollbarView.getCarret(), view.scrollbarView.getBounds( view.scrollbarView ), view );
			updateScrollbar();
			scrollComments();
		}
		
		/**
		 * 
		 */
		
		private function updateScrollbar():void {
			if ( !view.parent ) return;
			Scrollbar.update( view.scrollbarView.getCarret() );
			view.scrollbarView.visible = Scrollbar.isNeeded( view.scrollbarView.getCarret() );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddCommentButtonClicked( event:MouseEvent ):void {
			input.reset();
			dispatchEvent( new CommentsEvent( CommentsEvent.ADD_COMMENT_CALLED ) );
		}
		
		/**
		 * 
		 * @param	array
		 */
		
		private function addComment( data:Object ):void {
			trace( view.contentContainer.height );
			var comment:CommentItem = new CommentItem( data );
			comment.view.y = Math.round( view.contentContainer.height );
			view.contentContainer.addChild( comment.view );
			updateScrollbar();
			updateInputPosition();
			scrollComments();
		}
		
		private function scrollComments():void {
			if ( !view.parent ) return;
			if( view.scrollbarView.visible ) {
				Scrollbar.setScrollPositionByPercent( 100, view.scrollbarView.getCarret() );
			}
		}
	}

}