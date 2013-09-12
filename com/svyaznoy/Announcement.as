package com.svyaznoy {
	import com.svyaznoy.events.NavigationEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Announcement extends Sprite {
		
		private var titleLabel:TextField;
		private var messageLabel:TextField;
		private var dateLabel:TextField;
		private var data:Object;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function Announcement( data:Object ) {
			this.data = data;
			if ( !data ) {
				trace( "Announcement data is null" );
				visible = false;
				alpha = 0;
				return;
			}
			
			titleLabel = getChildByName( "title_txt" ) as TextField;
			messageLabel = getChildByName( "message_txt" ) as TextField;
			dateLabel = getChildByName( "date_txt" ) as TextField;
			
			titleLabel.text = String( data.title ).toUpperCase();
			messageLabel.text = data.anonce;
			dateLabel.text = DateConverter.getFormattedDate( data.date );
			
			titleLabel.mouseEnabled = titleLabel.mouseWheelEnabled = false;
			messageLabel.mouseEnabled = messageLabel.mouseWheelEnabled = false;
			dateLabel.mouseEnabled = dateLabel.mouseWheelEnabled = false;
			
			buttonMode = true;
			
			addEventListener( MouseEvent.CLICK, onClicked );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getData():Object {
			return data;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new NavigationEvent( NavigationEvent.NAVIGATE_TO_ANNOUNCEMENT ) );
		}
	}
}