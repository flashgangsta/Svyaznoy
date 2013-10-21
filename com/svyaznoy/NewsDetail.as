package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.vk.WallPostUtil;
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.NewsEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class NewsDetail extends ScreenWithComments {
		
		private const MARGIN:int = 10;
		private var id:int;
		private var shareButton:Button;
		private var backButton:Button;
		
		/**
		 * 
		 */
		
		public function NewsDetail() {
			provider.addEventListener( ProviderEvent.ON_NEWS_DETAIL, onData );
			shareButton = getChildByName( "shareButton_mc" ) as Button;
			backButton = getChildByName( "backButton_mc" ) as Button;
			setVisible( false );
			shareButton.addEventListener( MouseEvent.CLICK, onShareClicked );
			backButton.addEventListener( MouseEvent.CLICK, onBackButtonClicked );
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
				addChild( comments.view );
				setDisplayItemsAlignment();
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
			setDisplayItemsAlignment();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onShareClicked( event:MouseEvent ):void {
			var shareUtil:WallPostUtil = new WallPostUtil( Helper.getInstance().vkAPI );
			var attachments:Array = [];
			var message:String = String("" + data.content).replace( ContentParser.TEMPLATE_TAG, "" );
			var bitmapData:BitmapData = header.getBitmap() ? header.getBitmap().bitmapData : new LogoBitmapData();
			message = message.replace( / +/, " " );
			attachments.push( bitmapData );
			shareUtil.post( message, attachments, Helper.getInstance().getAppURL() );
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
		 */
		
		override protected function setDisplayItemsAlignment():void {
			dynamicContentViewer.y = MappingManager.getBottom( header, this );
			backButton.y = shareButton.y = dynamicContentViewer.getBottom() + MARGIN;
			comments.view.y = MappingManager.getBottom( backButton, this ) + MARGIN;
		}
		
		/**
		 * 
		 * @param	value
		 */
		
		private function setVisible( value:Boolean ):void {
			header.visible = value;
			backButton.visible = value;
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
			setDisplayItemsAlignment();
		}
		
	}

}