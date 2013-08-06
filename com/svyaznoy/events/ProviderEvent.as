package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProviderEvent extends Event {
		
		static public const ON_LOGGED_IN:String = "onLoggedIn";
		static public const ON_EMPLOYEE_SET:String = "onEmployeeSet";
		static public const ON_EMPLOYEE_CONFIRMED:String = "onEmployeeConfirmed";
		static public const ON_INTRO_DATA:String = "onIntroData";
		static public const ON_NEWS_LIST:String = "onNewsList";
		static public const ON_NEWS_DETAIL:String = "onNewsDetail";
		static public const ON_LOAD_START:String = "onLoadStart";
		static public const ON_LEGEND:String = "onLegend";
		static public const ON_ABOUT:String = "onAbout";
		static public const ON_THERMS_OF_MOTIVATION:String = "onThermsOfMotivation";
		static public const ON_DEPARTURES_LIST:String = "onDeparturesList";
		static public const ON_RANDOM_GALLERIES:String = "onRandomGalleries";
		static public const ON_RANDOM_VIDEOS:String = "onRandomVideos";
		static public const ON_LAST_GALLERIES:String = "onLastGalleries";
		static public const ON_LAST_VIDEOS:String = "onLastVideos";
		static public const ON_VIDEO_REPORT:String = "onVideoReport";
		
		public var data:Object;
		
		public function ProviderEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new ProviderEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "ProviderEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}