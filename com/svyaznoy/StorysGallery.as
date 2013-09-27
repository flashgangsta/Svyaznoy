package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class StorysGallery extends Popup {
		
		private var provider:Provider = Provider.getInstance();
		private var preloader:MovieClip;
		private var nextButton:Button;
		private var prevButton:Button;
		private var comments:Comments;
		private var like:LikeComponent;
		private var author
		
		public function StorysGallery() {
			preloader = getChildByName( "preloader_mc" ) as MovieClip;
			nextButton = getChildByName( "next_mc" ) as Button;
			prevButton = getChildByName( "prev_mc" ) as Button;
		}
		
	}

}