package com.flashgangsta.ui {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Sergey Krivtsov
	 * @version 1.00.01
	 */
	
	/**
	 * Dispatched when a user change selection of group
	 * @eventType	flash.events.Event.CHANGED
	 */
	[Event(name="change", type="flash.events.Event")] 
	
	public class RadioButtonGroup extends EventDispatcher {
		
		private var currentButton:CheckBox;
		
		/**
		 * Создаёт группу кнопок
		 * @param	...rest кнопки группы
		 */
		
		public function RadioButtonGroup( selectedButton:CheckBox, ...buttons ) {
			currentButton = selectedButton;
			
			for ( var i:int = 0; i < buttons.length; i++ ) {
				var button:CheckBox = buttons[ i ];
				button.selected = false;
				button.mouseChildren = true;
				button.mouseEnabled = true;
				button.addEventListener( Event.CHANGE, onChange );
			}
			
			if ( selectedButton ) {
				currentButton.selected = true;
				currentButton.mouseChildren = false;
				currentButton.mouseEnabled = false;
			}
			
		}
		
		/**
		 * Возвращает выбранную кнопку
		 */
		
		public function get selectedButton():CheckBox {
			return currentButton;
		}
		
		/**
		 * Обработчик выбора кнопки
		 * @param	event
		 */
		
		private function onChange( event:Event ):void {
			if ( currentButton ) {
				currentButton.mouseChildren = true;
				currentButton.mouseEnabled = true;
				currentButton.selected = false;
			}
			
			currentButton = event.currentTarget as CheckBox;
			
			currentButton.mouseChildren = false;
			currentButton.mouseEnabled = false;
			
			dispatchEvent( event );
		}
		
	}

}