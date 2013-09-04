package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class EditPhotoEvent extends Event {
		static public const ON_ANONCE_CHANGED:String = "onAnonceChanged";
		static public const ON_DEPARTURE_CHANGED:String = "onDepartureChanged";
		
		public function EditPhotoEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new EditPhotoEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "EditPhotoEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}