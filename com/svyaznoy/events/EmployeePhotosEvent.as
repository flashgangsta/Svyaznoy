package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class EmployeePhotosEvent extends Event {
		
		static public const ON_EMPLOYEE_ALBUM_UPDATED:String = "onEmployeeAlbumUpdated";
		
		private var _departureID:String;
		
		public function EmployeePhotosEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new EmployeePhotosEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "EmployeePhotosEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		public function get departureID():String {
			return _departureID;
		}
		
		public function set departureID( value:String ):void {
			_departureID = value;
		}
		
	}
	
}