package com.svyaznoy {
	import com.flashgangsta.media.video.YoutubePlayer;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DynamicVideo extends DynamicItem {
		
		var player:YoutubePlayer = new YoutubePlayer();
		
		public function DynamicVideo( videoID:String ) {
			addChild( player );
			player.setVideo( videoID );
		}
		
		override public function dispose():void {
			super.dispose();
			player.dispose();
			removeChild( player );
		}
		
	}

}