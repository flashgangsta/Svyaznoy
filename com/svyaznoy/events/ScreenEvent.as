package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenEvent extends Event {
		
		static public const HEIGHT_UPDATED:String = "heightUpdated";
		static public const RESET_SCROLL_NEEDED:String = "resetScrollNeeded";
		static public const GO_BACK:String = "goBack";
		static public const ON_OFFSET_LOADING_STARTED:String = "onOffsetLoadingStarted";
		
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