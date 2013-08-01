package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class InputTextfieldEvent extends Event {
		
		static public const SUBMIT:String = "submit";
		
		public function InputTextfieldEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new InputTextfieldEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "InputTextfieldEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}