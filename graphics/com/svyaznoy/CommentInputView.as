package com.svyaznoy {
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
		
		/**
		 * 
		 */
		
		public function CommentInputView() {
			_avatarContainer = getChildByName( "avatarContainer_mc" ) as AvatarContainer;
			_inputLabel = getChildByName( "inputLabel_txt" ) as TextField;
			_background = getChildByName( "background_mc" );
			_inputBackground = getChildByName( "inputBackground_mc" );
		}
		
	}

}