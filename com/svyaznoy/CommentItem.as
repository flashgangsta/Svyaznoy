package com.svyaznoy {
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentItem extends Sprite {
		
		private var _view:CommentItemView = new CommentItemView();
		
		
		/**
		 * 
		 * @param	data
		 */
		
		public function CommentItem( data:Object ) {
			view.nameLabel.autoSize = TextFieldAutoSize.LEFT;
			view.messageLabel.autoSize = TextFieldAutoSize.LEFT;
			view.dateLabel.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * 
		 */
		
		public function get view():CommentItemView {
			return _view;
		}
		
	}

}