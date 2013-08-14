package com.svyaznoy.modules {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Answer extends Sprite {
		
		/**
		 * 
		 */
		
		public function Answer() {
			
		}
		
		/**
		 * 
		 */
		
		public function get value():String {
			return null;
		}
		
		public function set value( value:String ):void {
			
		}
		
		/**
		 * 
		 */
		
		public function get selected():Boolean {
			return false;
		}
		
		public function set selected( value:Boolean ):void {
			dispatchEvent( new Event( Event.CHANGE, true ) );
		}
		
		/**
		 * 
		 */
		
		internal function dispose():void {
			
		}
		
	}

}