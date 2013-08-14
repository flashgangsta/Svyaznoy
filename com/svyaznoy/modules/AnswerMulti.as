package com.svyaznoy.modules {
	import com.flashgangsta.ui.CheckBox;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AnswerMulti extends Answer {
		
		private var checkBox:CheckBox;
		
		
		/**
		 * 
		 */
		
		public function AnswerMulti() {
			checkBox = getChildByName( "checkBox_mc" ) as CheckBox;
			checkBox.selected = false;
			checkBox.addEventListener( Event.CHANGE, onChange )
		}
		
		/**
		 * 
		 */
		
		override public function get value():String {
			return checkBox.value;
		}
		
		override public function set value(value:String):void {
			checkBox.value = value;
		}
		
		/**
		 * 
		 */
		
		override public function get selected():Boolean {
			return checkBox.selected;
		}
		
		override public function set selected(value:Boolean):void {
			checkBox.selected = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onChange( event:Event ):void {
			dispatchEvent( new Event( Event.CHANGE, true ) );
		}
		
	}

}