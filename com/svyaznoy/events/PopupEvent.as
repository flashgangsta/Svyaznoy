package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PopupEvent extends Event {
		
		static public const AGREE:String = "agree";
		static public const REJECT:String = "reject";
		static public const ENTER_ON_KEYBOARD_PRESS:String = "enterOnKeyboardPress";
		
		
		public function PopupEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new PopupEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "PopupEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}