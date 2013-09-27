package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ContestSectionListItem extends Sprite {
		
		protected var titleLabel:TextField;
		protected var dateLabel:TextField;
		protected var messageLabel:TextField;
		protected var previewIcon:AvatarContainer;
		protected var detailsButton:Button;
		protected var data:Object;
		protected var provider:Provider = Provider.getInstance();
		protected var loader:ProviderURLLoader;
		protected var divider:DisplayObject;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function ContestSectionListItem( data:Object ) {
			this.data = data;
			divider = getChildByName( "divider_mc" );
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			dateLabel = getChildByName( "dateLabel_txt" ) as TextField;
			messageLabel = getChildByName( "messageLabel_txt" ) as TextField;
			previewIcon = getChildByName( "preview_mc" ) as AvatarContainer;
			detailsButton = getChildByName( "detailsButton_mc" ) as Button;
			
			messageLabel.autoSize = TextFieldAutoSize.LEFT;
			dateLabel.text = DateConverter.getFormattedDate( data.date );
			if( data.image_with_path  ) previewIcon.loadByPath( data.image_with_path );
			messageLabel.text = data.anonce ? data.anonce : "Нет параметра anonce в API";
			
			detailsButton.addEventListener( MouseEvent.CLICK, onDetailsClicked );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getData():Object {
			return data;
		}
		
		public function dispose():void {
			//TODO: заебашить
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onDetailsClicked( event:MouseEvent ):void {
			dispatchEvent( new Event( Event.SELECT, true ) );
		}
		
	}

}