package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.flashgangsta.ui.Scrollbar;
	import com.flashgangsta.utils.PopupsController;
	import com.flashgangsta.utils.ScreenController;
	import com.svyaznoy.events.CommentsEvent;
	import com.svyaznoy.events.LoginSectionEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import com.svyaznoy.gui.Paging;
	import com.svyaznoy.modules.Voting;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestContests extends Sprite {
		
		private var screenController:ScreenController = new ScreenController();
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		private var popupsController:PopupsController;
		private var contestsList:Array;
		
		/**
		 * 
		 */
		
		public function TestContests() {
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function init( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			//Helper
			helper.isDebug = ( loaderInfo.url.indexOf( "http" ) !== 0 );
			helper.isEmployeeMode = true;
			ContentLoader.context = helper.loaderContext;
			
			//Provider
			provider.init();
			
			// PopupsController
			popupsController = PopupsController.getInstance();
			popupsController.init( stage, 0x2b2927, .85 );
			
			provider.login();
			provider.addEventListener( ProviderEvent.ON_LOGGED_IN, onLoggedIn );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoggedIn( event:ProviderEvent ):void {
			provider.addEventListener( ProviderEvent.ON_CONTESTS_LIST, onContestsList );
			provider.getContestsList();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onContestsList( event:ProviderEvent ):void {
			contestsList = event.data as Array;
			
			for ( var i:int = 0; i < contestsList.length; i++ ) {
				trace( "contest:", i + 1 );
			}
		}
		
		
	}

}