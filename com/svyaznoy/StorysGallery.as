package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
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
		private var author:WorkAuthorBar;
		private var datasList:Array;
		private var selectedIndex:int = 0;
		private var messageLabel:TextField;
		private var titleLabel:TextField;
		private var data:Object;
		
		
		public function StorysGallery( datasList:Array, index:int = 0 ) {
			selectedIndex = index;
			this.datasList = datasList;
			preloader = getChildByName( "preloader_mc" ) as MovieClip;
			nextButton = getChildByName( "next_mc" ) as Button;
			prevButton = getChildByName( "prev_mc" ) as Button;
			author = getChildByName( "author_mc" ) as WorkAuthorBar;
			titleLabel = getChildByName( "title_txt" ) as TextField;
			messageLabel = getChildByName( "message_txt" ) as TextField;
			
			nextButton.addEventListener( MouseEvent.CLICK, onNextClick );
			prevButton.addEventListener( MouseEvent.CLICK, onPrevClick );
			prevButton.visible = nextButton.visible = datasList.length > 1;
			updateButtons();
			
			preloader.stop();
			preloader.visible = false;
			
			data = datasList[ index ];
			titleLabel.text = data.title;
			messageLabel.text = data.story;
			trace( "data.employee.user.username", data.employee.user.username );
			author.loadAvatar(  data.employee.user.username );
			author.title = data.employee.full_title;
			
			comments = new ContestsComments( data.competition_id, data.id );
			comments.view.x = author.x;
			comments.view.y = author.y + author.height;
			
			if ( data.is_can_be_voted ) {
				trace( "LIKES" );
				like = new LikeComponent( data );
				like.x = author.x;
				like.y = background.y + background.height - like.height;
				like.likes = data.likes;
				addChild( like );
				comments.height = like.y - comments.view.y;
			} else {
				comments.height = background.height - comments.view.y;
			}
			
			addChild( comments.view );
		}
		
		/**
		 * 
		 */
		
		private function updateButtons():void {
			if ( !prevButton.visible && !nextButton.visible ) return;
			
			var lastPhotoIndex:int = datasList.length - 1;
			
			if ( selectedIndex === 0 && prevButton.enabled ) {
				prevButton.enabled = false;
				prevButton.setDefaultState();
			} else if ( selectedIndex && !prevButton.enabled ) {
				prevButton.enabled = true;
			}
			
			if ( selectedIndex === lastPhotoIndex && nextButton.enabled ) {
				nextButton.enabled = false;
				nextButton.setDefaultState();
			} else if ( selectedIndex !== lastPhotoIndex && !nextButton.enabled ) {
				nextButton.enabled = true;
			}
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPrevClick( event:MouseEvent ):void {
			selectedIndex--;
			updateButtons();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onNextClick( event:MouseEvent ):void {
			selectedIndex++;
			updateButtons();
		}
		
	}

}