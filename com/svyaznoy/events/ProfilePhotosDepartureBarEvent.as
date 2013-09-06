package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProfilePhotosDepartureBarEvent extends Event {
		static public const ON_BAR_DISPLAYING_CHANGED:String = "onBarDisplayingChanged";
		
		public function ProfilePhotosDepartureBarEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new ProfilePhotosDepartureBarEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "ProfilePhotosDepartureBarEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}