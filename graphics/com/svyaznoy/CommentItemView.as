package com.svyaznoy {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentItemView extends Sprite {
		
		private var _avatarContainer:AvatarContainer;
		private var _nameLabel:TextField;
		private var _messageLabel:TextField;
		private var _dateLabel:TextField;
		private var _background:DisplayObject;
		
		/**
		 * 
		 */
		
		public function CommentItemView() {
			_avatarContainer = getChildByName( "avatarContainer_mc" ) as AvatarContainer;
			_nameLabel = getChildByName( "nameLabel_txt" ) as TextField;
			_messageLabel = getChildByName( "messageLabel_txt" ) as TextField;
			_dateLabel = getChildByName( "dateLabel_txt" ) as TextField;
			_background = getChildByName( "background_mc" );
			
			nameLabel.text = "";
			messageLabel.text = "";
			dateLabel.text = "";
		}
		
		/**
		 * 
		 */
		
		public function get avatarContainer():AvatarContainer {
			return _avatarContainer;
		}
		
		/**
		 * 
		 */
		
		public function get nameLabel():TextField {
			return _nameLabel;
		}
		
		/**
		 * 
		 */
		
		public function get messageLabel():TextField {
			return _messageLabel;
		}
		
		/**
		 * 
		 */
		
		public function get dateLabel():TextField {
			return _dateLabel;
		}
		
	}

}