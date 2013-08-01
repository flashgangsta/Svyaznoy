package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProviderErrorEvent extends Event {
		
		static public const ON_EMPLOYEE_SET_ERROR:String = "onEmployeeSetError";
		static public const ON_EMPLOYEE_CONFIRMATION_ERROR:String = "onEmployeeConfirmationError";
		
		public function ProviderErrorEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new ProviderErrorEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "ProviderErrorEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}