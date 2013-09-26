package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
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
	public class ContestListItem extends Sprite {
		
		private var titleLabel:TextField;
		private var dateLabel:TextField;
		private var messageLabel:TextField;
		private var batterysLabel:TextField;
		private var previewIcon:AvatarContainer;
		private var previews:Sprite;
		private var detailsButton:Button;
		private var data:Object;
		private var provider:Provider = Provider.getInstance();
		private var loader:ProviderURLLoader;
		private var divider:DisplayObject;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function ContestListItem( data:Object ) {
			this.data = data;
			
			divider = getChildByName( "divider_mc" );
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			dateLabel = getChildByName( "dateLabel_txt" ) as TextField;
			messageLabel = getChildByName( "messageLabel_txt" ) as TextField;
			batterysLabel = getChildByName( "batterysLabel_txt" ) as TextField;
			previewIcon = getChildByName( "preview_mc" ) as AvatarContainer;
			previews = getChildByName( "previews_mc" ) as Sprite;
			detailsButton = getChildByName( "detailsButton_mc" ) as Button;
			
			messageLabel.autoSize = TextFieldAutoSize.LEFT;
			
			titleLabel.text = "КОНКУРС: " + String( data.title ).toUpperCase();
			dateLabel.text = DateConverter.getFormattedDate( data.date );
			messageLabel.text = data.anonce;
			batterysLabel.text = data.points;
			
			previewIcon.loadByPath( data.image_with_path );
			
			var lastItem:DisplayObject = messageLabel.y + messageLabel.height > batterysLabel.y + batterysLabel.height ? messageLabel : batterysLabel;
			
			if ( data.type === "photos" ) {
				previews.y = MappingManager.getBottom( lastItem, this ) + 25;
				previews.visible = false;
				lastItem = previews;
				loader = provider.getContestWorksList( data.id, previews.numChildren );
				loader.addEventListener( ProviderEvent.ON_CONTEST_WORKS_LIST, onWorks );
			} else {
				previews.visible = false;
				previews.y = 0;
			}
			
			detailsButton.y = MappingManager.getBottom( lastItem, this ) + 20;
			divider.y = MappingManager.getBottom( detailsButton, this ) + 17;
			
			detailsButton.addEventListener( MouseEvent.CLICK, onDetailsClicked );
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
		
		private function onDetailsClicked( event:MouseEvent ):void {
			dispatchEvent( new Event( Event.SELECT, true ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onWorks( event:ProviderEvent ):void {
			var works:Array = event.data as Array;
			loader.removeEventListener( ProviderEvent.ON_CONTEST_WORKS_LIST, onWorks );
			loader = null;
			
			for ( var i:int = 0; i < works.length; i++ ) {
				AvatarContainer( previews.getChildAt( i ) ).loadByPath( works[ i ].photo_with_path + "/" + works[ i ].photo );
			}
			
			for ( i; i < previews.numChildren; i++ ) {
				previews.getChildAt( i ).visible = false;
			}
			
			previews.visible = Boolean( works.length );
		}
		
	}

}