package com.svyaznoy {
	import com.flashgangsta.events.PopupsControllerEvent;
	import com.flashgangsta.media.video.YoutubePlayer;
	import com.flashgangsta.ui.CheckBox;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class IntroVideo extends Popup {
		
		private var player:YoutubePlayer;
		private var message:TextField;
		private var checkBox:CheckBox;
		private var tagsList:Vector.<ContentTag>;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function IntroVideo( data:Object ) {
			player = getChildByName( "player_mc" ) as YoutubePlayer;
			message = getChildByName( "message_txt" ) as TextField;
			checkBox = getChildByName( "checkBox_mc" ) as CheckBox;
			
			message.autoSize = TextFieldAutoSize.LEFT;
			
			checkBox.selected = false;
			
			tagsList = ContentParser.parse( data.content );
			
			for ( var i:int = 0; i < tagsList.length; i++ ) {
				var tag:Object = tagsList[ i ];
				if ( tag.name === "youtube" ) player.setVideo( tag.value );
				else if ( tag.name === "text" ) {
					while ( tag.value.indexOf( "\n" ) === 0 ) {
						tag.value = tag.value.substr( 2 );
					}
					message.htmlText = tag.value;
				}
			}
			
			addEventListener( PopupsControllerEvent.CLOSING, onPopupClosing );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPopupClosing( event:PopupsControllerEvent ):void {
			removeEventListener( PopupsControllerEvent.CLOSING, onPopupClosing );
			if ( checkBox.selected ) {
				Provider.getInstance().dispableIntro();
			}
		}
		
		
	}

}