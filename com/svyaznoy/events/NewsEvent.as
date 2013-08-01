package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class NewsEvent extends Event {
		
		static public const DETAILED_CLICKED:String = "detailedClicked";
		static public const NEWS_BACK_TO_LIST_CLICKED:String = "newsBackToListClicked";
		
		public var newsID:int;
		
		public function NewsEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new NewsEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "NewsEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}