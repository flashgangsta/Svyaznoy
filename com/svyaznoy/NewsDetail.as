package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.NewsEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
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
		
		
		/**
		 * 
		 */
		
		public function NewsDetail() {
			setVisible( false );
			bottomButton.addEventListener( MouseEvent.CLICK, onBackButtonClicked );
			provider.addEventListener( ProviderEvent.ON_NEWS_DETAIL, onData );
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function showNews( id:int ):void {
			var savedNewsData:Object = Helper.getInstance().getNewsDataByID( id );
			
			if ( this.id !== id && !savedNewsData ) {
				addPreloader();
				provider.getNewsDetail( id );
				setVisible( false );
				this.id = id;
			} else if ( savedNewsData && this.id !== id ) {
				data = savedNewsData;
				displayData();
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
		
		private function onCommentsReady( event:CommentsEvent ):void {
			addChild( comments.view );
			setPositions();
			dispatchHeighUpdated();
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
		 */
		
		private function setPositions():void {
			var lastItem:DisplayObject = dynamicContentViewer;
			if ( comments && contains( comments.view ) ) {
				comments.view.y = Math.ceil( MappingManager.getBottom( lastItem, this ) + MARGIN );
				lastItem = comments.view;
			}
			bottomButton.y = Math.ceil( MappingManager.getBottom( lastItem, this ) + MARGIN );
		}
		
		/**
		 * 
		 * @param	value
		 */
		
		private function setVisible( value:Boolean ):void {
			header.visible = value;
			bottomButton.visible = value;
			dynamicContentViewer.visible = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBackButtonClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new NewsEvent( NewsEvent.NEWS_BACK_TO_LIST_CLICKED ) );
		}
		
	}

}