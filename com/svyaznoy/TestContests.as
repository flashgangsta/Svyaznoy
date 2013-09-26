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
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
		private var contest:ContestDetailed;
		
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
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
			
			Dispatcher.getInstance().addEventListener( ScreenEvent.GO_BACK, goBack );
		}
		
		private function goBack( event:ScreenEvent ):void {
			removeChildAt( numChildren - 1 );
			for ( var i:int = 0; i < contestsList.length; i++ ) {
				getChildAt( i ).visible = true;
			}
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
			
			var contestListItem:ContestListItem;
			var lastY:int = 0;
			
			for ( var i:int = 0; i < contestsList.length; i++ ) {
				contestListItem = new ContestListItem( contestsList[ i ] );
				contestListItem.y = lastY;
				lastY = Math.round( contestListItem.height + lastY );
				addChild( contestListItem );
			}
			
			addEventListener( Event.SELECT, onContestSelect );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onContestSelect( event:Event ):void {
			var contestData:Object = ContestListItem( event.target ).getData();
			event.stopImmediatePropagation();
			
			for ( var i:int = 0; i < contestsList.length; i++ ) {
				getChildAt( i ).visible = false;
			}
			
			if( !contest ) contest = new ContestDetailed();
			contest.showContest( contestData.id );
			addChild( contest );
			
		}
		
		
	}

}