package com.svyaznoy {
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class WorkAuthorBar extends Sprite {
		
		private var avatar:AvatarContainer;
		private var titleLabel:TextField;
		private var messageLabel:TextField;
		
		/**
		 * 
		 */
		
		public function WorkAuthorBar() {
			avatar = getChildByName( "avatar_mc" ) as AvatarContainer;
			titleLabel = getChildByName( "title_txt" ) as TextField;
			messageLabel = getChildByName( "message_txt" ) as TextField;
			
			titleLabel.text = messageLabel.text = "";
			
			titleLabel.autoSize = messageLabel.autoSize = TextFieldAutoSize.LEFT;
			messageLabel.y = 0;
		}
		
		/**
		 * 
		 * @param	userID
		 */
		
		public function loadAvatar( userID:String ):void {
			avatar.loadByVkID( userID );
		}
		
		public function dispose():void {
			avatar.dispose();
		}
		
		/**
		 * 
		 */
		
		public function set title( value:String ):void {
			titleLabel.text = value;
		}
		
		/**
		 * 
		 */
		
		public function set message( value:String ):void {
			if ( messageLabel.text !== value ) {
				messageLabel.text = value;
			}
			
			if ( value ) {
				messageLabel.y = Math.ceil( titleLabel.height );
			}
			
		}
	}

}