package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentItem extends Sprite {
		
		private var _view:CommentItemView = new CommentItemView();
		private var loader:ProviderURLLoader;
		
		
		/**
		 * 
		 * @param	data
		 */
		
		public function CommentItem( data:Object, width:int = 0 ) {
			
			var userData:UserData = Helper.getInstance().getUserData();
			if ( userData.employeeID === data.employee_id ) {
				view.avatarContainer.loadByPath( userData.photo100 );
			} else {
				loader = Provider.getInstance().getEmployeeByID( data.employee_id );
				loader.addEventListener( ProviderEvent.ON_EMPLOYEE_DATA, onUserData );
			}
			
			if ( !width ) {
				width = _view.width;
			} else if( width !== _view.width ) {
				view.background.width = width;
				view.nameLabel.width = width - view.nameLabel.x - 1;
				view.messageLabel.width = view.dateLabel.width = view.nameLabel.width;
			}
			
			view.nameLabel.autoSize = TextFieldAutoSize.LEFT;
			view.messageLabel.autoSize = TextFieldAutoSize.LEFT;
			view.dateLabel.autoSize = TextFieldAutoSize.LEFT;
			
			view.nameLabel.mouseWheelEnabled = false;
			view.messageLabel.mouseWheelEnabled = false;
			view.dateLabel.mouseWheelEnabled = false;
			
			view.nameLabel.text = data.employee.full_title;
			view.messageLabel.text = data.message;
			view.dateLabel.text = DateConverter.getFormattedDateAndTimeInNumbers( data.created_at );
			
			view.messageLabel.y = MappingManager.getBottom( view.nameLabel, this );
			view.dateLabel.y = MappingManager.getBottom( view.messageLabel, this );
			
			view.background.height = Math.round( view.dateLabel.y + view.dateLabel.height + view.nameLabel.y );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onUserData( event:ProviderEvent ):void {
			var userData:Object = event.data;
			trace( view.avatarContainer is AvatarContainer );
			view.avatarContainer.loadByVkID( userData.user.username );
			loader.removeEventListener( ProviderEvent.ON_EMPLOYEE_DATA, onUserData );
		}
		
		/**
		 * 
		 */
		
		public function get view():CommentItemView {
			return _view;
		}
		
	}

}