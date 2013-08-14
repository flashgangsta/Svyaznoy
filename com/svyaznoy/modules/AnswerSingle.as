package com.svyaznoy.modules {
	import com.flashgangsta.ui.CheckBox;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AnswerSingle extends Answer {
		
		private var radioButton:CheckBox;
		
		public function AnswerSingle() {
			radioButton = getChildByName( "radioButton_mc" ) as CheckBox;
			trace( getChildByName( "radioButton_mc" ), radioButton );
			radioButton.selected = false;
			radioButton.addEventListener( Event.CHANGE, onChange );
		}
		
		/**
		 * 
		 */
		
		override public function get value():String {
			return radioButton.value;
		}
		
		override public function set value(value:String):void {
			radioButton.value = value;
		}
		
		/**
		 * 
		 */
		
		override public function get selected():Boolean {
			return radioButton.selected;
		}
		
		override public function set selected(value:Boolean):void {
			radioButton.selected = value;
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