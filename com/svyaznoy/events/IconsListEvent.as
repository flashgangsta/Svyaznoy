package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class IconsListEvent extends Event {
		
		static public const ICON_SELECTED:String = "iconSelected";
		
		private var _data:Object;
		
		public function IconsListEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new IconsListEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "IconsListEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
	}
	
}