package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.vk.WallPostUtil;
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.NewsEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class NewsDetail extends ScreenWithBottomButtonAndComments {
		
		private const MARGIN:int = 10;
		private var id:int;
		private var shareButton:Button;
		
		/**
		 * 
		 */
		
		public function NewsDetail() {
			bottomButton.addEventListener( MouseEvent.CLICK, onBackButtonClicked );
			provider.addEventListener( ProviderEvent.ON_NEWS_DETAIL, onData );
			shareButton = getChildByName( "shareButton_mc" ) as Button;
			setVisible( false );
			shareButton.addEventListener( MouseEvent.CLICK, onShareClicked );
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function showNews( id:int ):void {
			if ( this.id !== id ) {
				addPreloader();
				provider.getNewsDetail( id );
				setVisible( false );
				this.id = id;
			}
			
			if ( comments ) {
				removeChild( comments.view );
				comments.dispose();
				comments = null;
			}
			
			if( Helper.getInstance().isEmployeeMode ) {
				comments = new NewsComments( id );
				comments.width = header.width;
				comments.addEventListener( CommentsEvent.ON_COMMENTS_READY, onCommentsReady );
			}
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			Helper.getInstance().setNewsData( data );
			displayData();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			setVisible( true );
			setPositions();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onShareClicked( event:MouseEvent ):void {
			var shareUtil:WallPostUtil = new WallPostUtil( Helper.getInstance().vkAPI );
			var attachments:Array = [];
			var message:String = String("" + data.content).replace( ContentParser.TEMPLATE_TAG, "" );
			message = message.replace( / +/, " " );
			if ( header.getBitmap() ) attachments.push( header.getBitmap() );
			shareUtil.post( message, attachments, "http://vk.com/app" + Helper.getInstance().getAppID() );
			shareUtil.addEventListener( Event.COMPLETE, onPostShared );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPostShared( event:Event ):void {
			var loader:ProviderURLLoader = provider.confirmShare();
			loader.addEventListener( ProviderEvent.ON_SHARE_CONFIRMED, onShareConfirmed );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onShareConfirmed( event:ProviderEvent ):void {
			var loader:ProviderURLLoader = event.target as ProviderURLLoader;
			loader.removeEventListener( ProviderEvent.ON_SHARE_CONFIRMED, onShareConfirmed );
			AchievementsController.getInstance().checkNewAchiewements();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onCommentsReady( event:CommentsEvent ):void {
			addChild( comments.view );
			setPositions();
			dispatchHeighUpdated();
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			var lastItem:DisplayObject = dynamicContentViewer;
			if ( comments && contains( comments.view ) ) {
				comments.view.y = Math.ceil( MappingManager.getBottom( lastItem, this ) + MARGIN );
				lastItem = comments.view;
			}
			bottomButton.y = shareButton.y = Math.ceil( MappingManager.getBottom( lastItem, this ) + MARGIN );
		}
		
		/**
		 * 
		 * @param	value
		 */
		
		private function setVisible( value:Boolean ):void {
			header.visible = value;
			bottomButton.visible = value;
			dynamicContentViewer.visible = value;
			shareButton.visible = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBackButtonClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new NewsEvent( NewsEvent.NEWS_BACK_TO_LIST_CLICKED ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			setPositions();
		}
		
	}

}