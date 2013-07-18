package com.flashgangsta.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MediaControllerEvent extends Event {
		
		static public const PLAY_CLICKED:String = "playClicked";
		static public const PAUSE_CLICKED:String = "pauseClicked";
		static public const PLAY_OR_PAUSE_CLICKED:String = "playOrPauseClicked";
		static public const PLAYING_COMPLETE:String = "playingComplete";
		static public const PLAYING_STARTED:String = "playingStarted";
		
		public function MediaControllerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new MediaControllerEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "MediaControllerEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}