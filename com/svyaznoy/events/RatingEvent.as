package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class RatingEvent extends Event {
		
		static public const OWNER_RATING_CHANGED:String = "ownerRatingChanged";
		
		public function RatingEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new RatingEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "RatingEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}