package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class NavigationEvent extends Event {
		
		/// Главная
		static public const NAVIGATE_TO_INDEX:String = "navigate_to_index";
		/// Выезды
		static public const NAVIGATE_TO_DEPARTURES:String = "navigate_to_departures";
		/// Новости
		static public const NAVIGATE_TO_NEWS:String = "navigate_to_news";
		/// Легенда
		static public const NAVIGATE_TO_LEGEND:String = "navigate_to_legend";
		/// Конкурсы
		static public const NAVIGATE_TO_CONTESTS:String = "navigate_to_contests";
		/// Результаты
		static public const NAVIGATE_TO_RESULTS:String = "navigate_to_results";
		/// О связном
		static public const NAVIGATE_TO_ABOUT:String = "navigate_to_about";
		
		
		/**
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		
		public function NavigationEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new NavigationEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "NavigationEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}