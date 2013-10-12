package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScrollbarEvent extends Event {
		
		static public const ON_SCROLLED:String = "onScrolled";
		static public const ON_SET_SCROLL_BY_PIXELS_CALLED:String = "onSetScrollByPixelsCalled";
		
		private var _percent:Number;
		private var _pixels:int;
		
		public function ScrollbarEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new ScrollbarEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "ScrollbarEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		public function get percent():Number {
			return _percent;
		}
		
		public function set percent(value:Number):void {
			_percent = value;
		}
		
		public function get pixels():int {
			return _pixels;
		}
		
		public function set pixels(value:int):void {
			_pixels = value;
		}
		
	}
	
}