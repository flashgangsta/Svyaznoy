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
	public class Test extends Sprite {
		
		private var screenController:ScreenController = new ScreenController();
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		private var popupsController:PopupsController;
		private var comments:NewsComments;
		
		/**
		 * 
		 */
		
		public function Test() {
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
			
			comments = new NewsComments( 3 );
			comments.width = 515;
			comments.addEventListener( CommentsEvent.ON_COMMENTS_READY, onCommentsReady );
		}
		
		private function onCommentsReady( event:Event ):void {
			addChild( comments.view );
		}
	}

}