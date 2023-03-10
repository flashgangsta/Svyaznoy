package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.ui.Scrollbar;
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.PreloaderAnimation;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Comments extends EventDispatcher {
		
		private var _view:CommentsView = new CommentsView();
		private var input:CommentInput = new CommentInput();
		private var preloader:PreloaderAnimation = new PreloaderAnimation();
		
		protected var provider:Provider = Provider.getInstance();
		protected var listLoader:ProviderURLLoader;
		protected var countLoader:ProviderURLLoader;
		protected var addLoader:ProviderURLLoader;
		protected var commentsDatasList:Vector.<Object> = new Vector.<Object>;
		protected var count:int;
		
		/**
		 * 
		 */
		
		public function Comments() {
			preloader.hide();
			
			view.visible = false;
			
			updateInputPosition();
			view.addChild( input.view );
			
			view.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			input.view.addCommentButton.addEventListener( MouseEvent.CLICK, onAddCommentButtonClicked );
			input.view.avatarContainer.loadByPath( Helper.getInstance().getUserData().photo50 );
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
		
		public function get width():int {
			return view.background.width;
		}
		
		public function set width(value:int):void {
			view.background.width = value;
			view.scrollbarView.x = value - view.scrollbarView.width;
			view.contentMask.width = view.scrollbarView.x + 3;
			input.setWidth( view.scrollbarView.x );
		}
		
		/**
		 * 
		 */
		
		public function get height():int {
			return view.background.height;
		}
		
		public function set height(value:int):void {
			view.background.height = value;
			input.view.y = view.background.height - input.view.height - 10;
			view.contentMask.height = input.view.y - 4;
			view.scrollbarView.height = view.contentMask.height;
		}
		
		/**
		 * 
		 */
		
		public function get bottom():int {
			return _view.y + height;
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
			
			Scrollbar.removeVerticalScrollbar( view.scrollbarView.getCarret() );
			
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		protected function onComments( event:ProviderEvent ):void {
			var list:Vector.<Object> = Vector.<Object>( event.data as Array );
			commentsDatasList = list;
			addCommentsList( list );
			scrollComments();
			dispatchReady();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		protected function onOldCommentsList( event:ProviderEvent ):void {
			var list:Vector.<Object> = Vector.<Object>( event.data as Array );
			var carret:MovieClip = view.scrollbarView.getCarret();
			var oldContentHeight:int = Scrollbar.getContentHeight( carret );
			var newContentHeight:int;
			
			commentsDatasList = commentsDatasList.concat( list );
			addCommentsList( list );
			newContentHeight = Scrollbar.getContentHeight( carret );
			Scrollbar.setScrollPositionByPixels( newContentHeight - oldContentHeight, carret );
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
			count++;
			commentsDatasList.unshift( event.data );
			addComment( event.data, true );
			updateInputPosition();
			alignComments();
			scrollComments();
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
			view.scrollbarView.getCarret().addEventListener( Event.CHANGE, onScrolled );
			Scrollbar.setVertical( view.contentContainer, view.contentMask.getBounds( view ), view.scrollbarView.getUpBtn(), view.scrollbarView.getDownBtn(), view.scrollbarView.getCarret(), view.scrollbarView.getBounds( view.scrollbarView ), view );
			updateScrollbar();
			scrollComments();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onScrolled( event:Event ):void {
			var percent:Number = Scrollbar.getPercent( view.scrollbarView.getCarret() );
			if ( percent === 0 && !preloader.isPlaying && commentsDatasList.length < count ) {
				loadOldComments();
			}
		}
		
		/**
		 * 
		 */
		
		private function loadOldComments():void {
			var lastCommentData:Object = commentsDatasList[ commentsDatasList.length - 1 ];
			var event:CommentsEvent = new CommentsEvent( CommentsEvent.ON_OLD_COMMENTS_CALLED );
			
			view.contentContainer.addChild( preloader );
			preloader.x = MappingManager.getCentricPoint( view.contentContainer.width, preloader.width );
			preloader.show();
			alignComments();
			
			event.lastCommentID = lastCommentData.id;
			dispatchEvent( event );
		}
		
		/**
		 * 
		 */
		
		private function alignComments():void {
			var comment:CommentItemView;
			var container:DisplayObjectContainer = view.contentContainer;
			var commentsLenght:int = container.numChildren;
			var y:int = 0;
			
			if ( preloader.isPlaying ) {
				y += preloader.height + 3;
				commentsLenght -= 1;
			}
			
			for ( var i:int = commentsLenght - 1; i > -1; i-- ) {
				comment = container.getChildAt( i ) as CommentItemView;
				comment.y = y;
				y += Math.round( comment.height );
			}
			
			updateScrollbar();
			updateInputPosition();
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
			AchievementsController.getInstance().checkNewAchiewements();
		}
		
		/**
		 * 
		 * @param	list
		 */
		
		private function addCommentsList( list:Vector.<Object> ):void {
			
			if ( preloader.isPlaying ) {
				view.contentContainer.removeChild( preloader );
				preloader.hide();
			}
			
			for ( var i:int = 0; i < list.length; i++ ) {
				addComment( list[ i ] );
			}
			
			alignComments();
		}
		
		/**
		 * 
		 * @param	array
		 */
		
		private function addComment( data:Object, hasNew:Boolean = false ):void {
			if ( !data.employee ) return;
			var comment:CommentItem = new CommentItem( data, view.scrollbarView.x );
			
			if ( hasNew ) {
				view.contentContainer.addChildAt( comment.view, 0 );
			} else {
				view.contentContainer.addChild( comment.view );
			}
		}
		
		/**
		 * 
		 */
		
		private function scrollComments():void {
			if ( !view.parent ) return;
			if( view.scrollbarView.visible ) {
				Scrollbar.setScrollPositionByPercent( 100, view.scrollbarView.getCarret() );
			}
		}
	}

}