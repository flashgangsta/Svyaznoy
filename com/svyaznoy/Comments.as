package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Comments {
		
		private var _view:CommentsView = new CommentsView();
		
		public function Comments() {
			
		}
		
		public function get view():CommentsView {
			return _view;
		}
		
	}

}