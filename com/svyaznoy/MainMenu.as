package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
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
		private var deaparturesButton:MainMenuButton;
		private var newsButton:MainMenuButton;
		private var legendButton:MainMenuButton;
		private var aboutButton:MainMenuButton;
		private var contestsButton:MainMenuButton;
		private var ratingsButton:MainMenuButton;
		private var radioButton:MainMenuButton;
		private var divider:Sprite;
		
		private var buttons:Array = [];
		private var eventTypes:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		
		public function MainMenu() {
			logoButton = getChildByName( "logo_mc" ) as MovieClip;
			deaparturesButton = getChildByName( "departures_mc" ) as MainMenuButton;
			newsButton = getChildByName( "news_mc" ) as MainMenuButton;
			legendButton = getChildByName( "legend_mc" ) as MainMenuButton;
			aboutButton = getChildByName( "about_mc" ) as MainMenuButton;
			contestsButton = getChildByName( "contests_mc" ) as MainMenuButton;
			ratingsButton = getChildByName( "ratings_mc" ) as MainMenuButton;
			radioButton = getChildByName( "radio_mc" ) as MainMenuButton;
			divider = getChildByName( "divider_mc" ) as Sprite;
			
			buttons.push( deaparturesButton, newsButton, legendButton, aboutButton, contestsButton, ratingsButton );
			
			eventTypes[ deaparturesButton ] = NavigationEvent.NAVIGATE_TO_DEPARTURES;
			eventTypes[ newsButton ] = NavigationEvent.NAVIGATE_TO_NEWS;
			eventTypes[ legendButton ] = NavigationEvent.NAVIGATE_TO_LEGEND;
			eventTypes[ aboutButton ] = NavigationEvent.NAVIGATE_TO_ABOUT;
			eventTypes[ contestsButton ] = NavigationEvent.NAVIGATE_TO_CONTESTS;
			eventTypes[ ratingsButton ] = NavigationEvent.NAVIGATE_TO_RATINGS;
			
			ButtonManager.addButtonGroup( buttons, true, deaparturesButton, false, ButtonManager.STATE_PRESSED, onClick );
			ButtonManager.addButton( radioButton, null, onRadioClicked );
		}
		
		/**
		 * 
		 */
		
		public function init():void {
			if ( !Helper.getInstance().isEmployeeMode ) {
				contestsButton.visible = false;
				ratingsButton.visible = false;
				radioButton.y = contestsButton.y;
				radioButton.setColor( 0xA291B3 );
			}
			divider.y = MappingManager.getBottom( radioButton, this );
		}
		
		/**
		 * 
		 */
		
		public function resetSelection():void {
			ButtonManager.resetSelectionOnGroup( buttons[ 0 ] );
		}
		
		/**
		 * 
		 */
		
		public function selectDepartures():void {
			ButtonManager.setSelectionOnGroup( deaparturesButton );
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