package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewsTableEvent extends Event {
		static public const ON_PREVIEW_SELECTED:String = "onPreviewSelected";
		
		public function PreviewsTableEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new PreviewsTableEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "PreviewsTabEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}