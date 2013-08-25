package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class LotteryEvent extends Event {
		
		static public const LOTTERY_SELECTED:String = "lotterySelected";
		
		private var _lotteryData:Object;
		
		public function LotteryEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new LotteryEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "LotteryEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		public function get lotteryData():Object {
			return _lotteryData;
		}
		
		public function set lotteryData(value:Object):void {
			_lotteryData = value;
		}
		
	}
	
}