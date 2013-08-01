package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenEvent extends Event {
		
		static public const HEIGHT_UPDATED:String = "heightUpdated";
		
		public function ScreenEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new ScreenEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "ScreenEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}