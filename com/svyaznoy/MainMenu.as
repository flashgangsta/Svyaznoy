package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.svyaznoy.events.NavigationEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
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
		private var aboutButton:MovieClip;
		private var radioButton:MovieClip;
		
		private var buttons:Array = [];
		private var eventTypes:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		
		public function MainMenu() {
			logoButton = getChildByName( "logo_mc" ) as MovieClip;
			deaparturesButton = getChildByName( "departures_mc" ) as MovieClip;
			newsButton = getChildByName( "news_mc" ) as MovieClip;
			legendButton = getChildByName( "legend_mc" ) as MovieClip;
			aboutButton = getChildByName( "about_mc" ) as MovieClip;
			radioButton = getChildByName( "radio_mc" ) as MovieClip;
			
			buttons.push( deaparturesButton, newsButton, legendButton, aboutButton );
			
			eventTypes[ deaparturesButton ] = NavigationEvent.NAVIGATE_TO_DEPARTURES;
			eventTypes[ newsButton ] = NavigationEvent.NAVIGATE_TO_NEWS;
			eventTypes[ legendButton ] = NavigationEvent.NAVIGATE_TO_LEGEND;
			eventTypes[ aboutButton ] = NavigationEvent.NAVIGATE_TO_ABOUT;
			
			ButtonManager.addButtonGroup( buttons, true, deaparturesButton, false, ButtonManager.STATE_PRESSED, onClick );
			ButtonManager.addButton( radioButton, null, onRadioClicked );
		}
		
		/**
		 * 
		 * @param	target
		 */
		
		private function onRadioClicked( target:MovieClip ):void {
			ButtonManager.setButtonState( radioButton, ButtonManager.STATE_NORMAL );
			navigateToURL( new URLRequest( "http://svzn.fm/" ), "_blank" );
		}
		
		/**
		 * 
		 */
		
		private function onClick( target:MovieClip ):void {
			if ( eventTypes[ target ] ) {
				dispatcher.dispatchEvent( new NavigationEvent( eventTypes[ target ] ) );
			}
		}
		
		
	}

}