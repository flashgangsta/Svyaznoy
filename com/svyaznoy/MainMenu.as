package com.svyaznoy {
	import caurina.transitions.SpecialProperty;
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.ButtonManager;
	import com.svyaznoy.events.NavigationEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MainMenu extends Sprite {
		
		static public const ARROW_TIME:Number = .25;
		
		private var dispatcher:Dispatcher = Dispatcher.getInstance();
		private var logoButton:MovieClip;
		private var deaparturesButton:MovieClip;
		private var newsButton:MovieClip;
		private var legendButton:MovieClip;
		private var contestsButton:MovieClip;
		private var resultsButton:MovieClip;
		private var aboutButton:MovieClip;
		private var buttons:Array = [];
		private var arrow:Sprite;
		private var eventTypes:Dictionary = new Dictionary();
		
		public function MainMenu() {
			logoButton = getChildByName( "logo_mc" ) as MovieClip;
			deaparturesButton = getChildByName( "departures_mc" ) as MovieClip;
			newsButton = getChildByName( "news_mc" ) as MovieClip;
			legendButton = getChildByName( "legend_mc" ) as MovieClip;
			contestsButton = getChildByName( "contests_mc" ) as MovieClip;
			resultsButton = getChildByName( "results_mc" ) as MovieClip;
			aboutButton = getChildByName( "about_mc" ) as MovieClip;
			
			buttons.push( logoButton, deaparturesButton, newsButton, legendButton, contestsButton, resultsButton, aboutButton );
			
			eventTypes[ logoButton ] = NavigationEvent.NAVIGATE_TO_INDEX;
			eventTypes[ deaparturesButton ] = NavigationEvent.NAVIGATE_TO_DEPARTURES;
			eventTypes[ newsButton ] = NavigationEvent.NAVIGATE_TO_NEWS;
			eventTypes[ legendButton ] = NavigationEvent.NAVIGATE_TO_LEGEND;
			eventTypes[ contestsButton ] = NavigationEvent.NAVIGATE_TO_CONTESTS;
			eventTypes[ resultsButton ] = NavigationEvent.NAVIGATE_TO_RESULTS;
			eventTypes[ aboutButton ] = NavigationEvent.NAVIGATE_TO_ABOUT;
			
			arrow = getChildByName( "arrow_mc") as Sprite;
			arrow.y = Math.round( logoButton.y + logoButton.height / 2 );
			
			ButtonManager.addButtonGroup( buttons, false, logoButton, false, null, onClick );
			
		}
		
		/**
		 * 
		 */
		
		private function onClick( target:MovieClip ):void {
			var destination:int = Math.round( target.y + target.height / 2 );
			Tweener.addTween( arrow, { y: destination, time: ARROW_TIME, transition: "easeInOutCubic" } );
			
			if ( eventTypes[ target ] ) {
				dispatcher.dispatchEvent( new NavigationEvent( eventTypes[ target ] ) );
			}
		}
		
		
	}

}