package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DynamicItemEvent extends Event {
		
		static public const SIZE_CHANGED:String = "sizeChanged";
		
		public function DynamicItemEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new DynamicItemEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "DynamicItemEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}