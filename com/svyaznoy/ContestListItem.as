package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ContestListItem extends ContestSectionListItem {
		
		private var batterysLabel:TextField;
		private var previews:Sprite;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function ContestListItem( data:Object ) {
			super( data );
			batterysLabel = getChildByName( "batterysLabel_txt" ) as TextField;
			previews = getChildByName( "previews_mc" ) as Sprite;
			
			titleLabel.text = "КОНКУРС: " + String( data.title ).toUpperCase();
			batterysLabel.text = data.points;
			
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
				AvatarContainer( previews.getChildAt( i ) ).loadByPath( works[ i ].photo_with_path );
			}
			
			for ( i; i < previews.numChildren; i++ ) {
				previews.getChildAt( i ).visible = false;
			}
			
			previews.visible = Boolean( works.length );
		}
		
	}

}