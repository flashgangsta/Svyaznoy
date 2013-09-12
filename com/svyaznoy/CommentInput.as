package com.svyaznoy {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentInput extends Sprite {
		
		private const DEFAULT_MESSAGE:String = "Написать комментарий…";
		
		private var _view:CommentInputView = new CommentInputView();
		
		/**
		 * 
		 */
		
		public function CommentInput() {
			
		}
		
		/**
		 * 
		 */
		
		public function get view():CommentInputView {
			return _view;
		}
		
	}

}