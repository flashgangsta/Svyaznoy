package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class LoginSectionEvent extends Event {
		
		static public const COMPLETE:String = "loginComplete";
		static public const USER_STATUS_DEFINED:String = "userStatusDefined";
		
		public function LoginSectionEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new LoginSectionEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "LoginSectionEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}