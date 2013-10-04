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
		private var employeeLoader:ProviderURLLoader;
		
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
			if( employeeLoader ) {
				employeeLoader.dispose();
				employeeLoader.removeEventListener( ProviderEvent.ON_EMPLOYEE_DATA, onEmployeeData );
				employeeLoader = null;
			}
			avatar.dispose();
		}
		
		public function loadAuthorByEmployeeID( employee_id:int ):void {
			employeeLoader = Provider.getInstance().getEmployeeByID( employee_id );
			employeeLoader.addEventListener( ProviderEvent.ON_EMPLOYEE_DATA, onEmployeeData );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onEmployeeData( event:ProviderEvent ):void {
			employeeLoader.removeEventListener( ProviderEvent.ON_EMPLOYEE_DATA, onEmployeeData );
			employeeLoader = null;
			loadAvatar( event.data.user.username );
			title = event.data.full_title;
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