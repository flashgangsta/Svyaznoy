package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.NewsEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class NewsListItem extends Sprite {
		
		const MARGIN:int = 5;
		
		private var data:Object;
		protected var header:Header;
		private var messageLabel:TextField;
		private var moreButton:Button;
		private var border:Sprite;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function NewsListItem( data:Object ) {
			this.data = data;
			
			header = getChildByName( "header_mc" ) as Header;
			messageLabel = getChildByName( "message_txt" ) as TextField;
			moreButton = getChildByName( "more_mc" ) as Button;
			border = getChildByName( "border_mc" ) as Sprite;
			
			messageLabel.autoSize = TextFieldAutoSize.LEFT;
			
			header.displayData( data );
			messageLabel.htmlText = data.anonce;
			
			setPositionForBottomImageElements();
			
			moreButton.addEventListener( MouseEvent.CLICK, onMoreClicked );
			
			header.addEventListener( DynamicItemEvent.SIZE_CHANGED, onImageSizeSet );
		}
		
		/**
		 * 
		 * @param	event
		 * @return
		 */
		
		private function onImageSizeSet( event:DynamicItemEvent ):void {
			setPositionForBottomImageElements();
		}
		
		/**
		 * 
		 */
		
		private function setPositionForBottomImageElements():void {
			messageLabel.y =  MappingManager.getBottom( header, this ) + MARGIN;
			moreButton.y = MappingManager.getBottom( messageLabel, this ) + MARGIN;
			border.y = MappingManager.getBottom( moreButton, this ) + MARGIN * 3;
		}
		
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMoreClicked( event:MouseEvent ):void {
			var outputEvent:NewsEvent = new NewsEvent( NewsEvent.DETAILED_CLICKED );
			outputEvent.newsID = data.id;
			Dispatcher.getInstance().dispatchEvent( outputEvent );
		}
		
	}

}