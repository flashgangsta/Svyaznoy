package com.svyaznoy {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.events.MediaPlayingProgressEvent;
	import com.flashgangsta.media.controls.PlayPauseButton;
	import com.flashgangsta.media.controls.Seeker;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
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
			addEventListener( MediaControllerEvent.PLAYING_PAUSED, onPlayingPaused );
			addEventListener( ProgressEvent.PROGRESS, onLoadProgress );
			addEventListener( MediaPlayingProgressEvent.PROGRESS, onPlayingProgress );
		}
		
		/**
		 * 
		 */
		
		public function disable():void {
			mouseEnabled = mouseChildren = false;
			seeker.alpha = playPauseButton.alpha = .5;
		}
		
		/**
		 * 
		 */
		
		public function enable():void {
			mouseEnabled = mouseChildren = true;
			seeker.alpha = playPauseButton.alpha = 1;
		}
		
		/**
		 * 
		 */
		
		public function reset():void {
			seeker.reset();
			playPauseButton.setState();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayingProgress( event:MediaPlayingProgressEvent ):void {
			seeker.setPlayingProgress( event.currentTime, event.duration );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoadProgress( event:ProgressEvent ):void {
			seeker.setProgress( event.bytesLoaded, event.bytesTotal );
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
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayingPaused( event:MediaControllerEvent ):void {
			trace( "onPlayingPaused" );
			playPauseButton.setState( PlayPauseButton.STATE_PLAY );
		}
		
	}

}