package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentInputView extends Sprite {
		
		private var _avatarContainer:AvatarContainer;
		private var _inputBackground:DisplayObject;
		private var _background:DisplayObject;
		private var _inputLabel:TextField;
		private var _addCommentButton:Button;
		
		/**
		 * 
		 */
		
		public function CommentInputView() {
			_avatarContainer = getChildByName( "avatarContainer_mc" ) as AvatarContainer;
			_inputLabel = getChildByName( "inputLabel_txt" ) as TextField;
			_background = getChildByName( "background_mc" );
			_inputBackground = getChildByName( "inputBackground_mc" );
			_addCommentButton = getChildByName( "addComment_mc" ) as Button;
		}
		
		public function get inputLabel():TextField {
			return _inputLabel;
		}
		
		public function get avatarContainer():AvatarContainer {
			return _avatarContainer;
		}
		
		public function get addCommentButton():Button {
			return _addCommentButton;
		}
		
		public function get background():DisplayObject {
			return _background;
		}
		
		public function get inputBackground():DisplayObject {
			return _inputBackground;
		}
		
	}

}