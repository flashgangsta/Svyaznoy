package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapItemEvent extends Event {
		
		static public const VIDEO_REPORTS_CLICKED:String = "videoReportsClicked";
		
		public var itemData:Object;
		
		public function MapItemEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );			
		} 
		
		public override function clone():Event { 
			return new MapItemEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "MapItemEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}