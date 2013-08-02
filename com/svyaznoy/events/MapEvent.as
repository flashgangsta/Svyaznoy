package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapEvent extends Event {
		
		static public const COUNTRY_MOUSE_OVER:String = "coutryMouseOver";
		static public const COUNTRY_MOUSE_OUT:String = "coutryMouseOut";
		
		public function MapEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new MapEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "MapEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}