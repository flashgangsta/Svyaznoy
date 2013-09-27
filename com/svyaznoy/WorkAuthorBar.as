package com.svyaznoy {
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class WorkAuthorBar extends Sprite {
		
		private var avatar:AvatarContainer;
		private var titleLabel:TextField;
		private var messageLabel:TextField;
		
		public function WorkAuthorBar() {
			avatar = getChildByName( "avatar_mc" ) as AvatarContainer;
			titleLabel = getChildByName( "title_txt" ) as TextField;
			messageLabel = getChildByName( "message_txt" ) as TextField;
		}
		
		
		public function loadAvatarByEmployee( employeeData:Object ):void {
			var loader:ProviderURLLoader = Provider.getInstance().getEmployeeByID( employeeData.id );
			loader.addEventListener( ProviderEvent.ON_EMPLOYEE_DATA, onEmpoyeeData );
			
		}
	}

}