package com.svyaznoy {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.media.controls.PlayPauseButton;
	import com.flashgangsta.media.controls.Seeker;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PlayerControllBar extends Sprite {
		
		private var playPauseButton:PlayPauseButton;
		private var seeker:Seeker;
		
		public function PlayerControllBar() {
			playPauseButton = getChildByName( "playPauseButton_mc" ) as PlayPauseButton;
			seeker = getChildByName( "seeker_mc" ) as Seeker;
			
			addEventListener( MediaControllerEvent.PLAYING_COMPLETE, onPlayingComplete );
			addEventListener( MediaControllerEvent.PLAYING_STARTED, onPlayingStarted );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayingStarted( event:MediaControllerEvent ):void {
			playPauseButton.setState( PlayPauseButton.STATE_PAUSE );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayingComplete( event:MediaControllerEvent ):void {
			playPauseButton.setState( PlayPauseButton.STATE_PLAY );
		}
		
	}

}