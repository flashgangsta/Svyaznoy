package com.svyaznoy {
	import com.flashgangsta.utils.PopupsController;
	import com.flashgangsta.utils.ScreenController;
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestTests extends Sprite {
		
		private var screenController:ScreenController = new ScreenController();
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		private var questions:Array;
		private var answers:Array = [];
		private var data:Object;
		private var list:Array;
		private var popupsController:PopupsController;
		
		/**
		 * 
		 */
		
		public function TestTests() {
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function init( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			//Helper
			helper.isDebug = true;
			helper.isEmployeeMode = true;
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
			var loader:ProviderURLLoader = provider.getTestsList();
			loader.addEventListener( ProviderEvent.ON_TESTS_LIST, onTestsList );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTestsList( event:ProviderEvent ):void {
			list = event.data as Array;
			var lastY:int = 0;
			for ( var i:int = 0; i < list.length; i++ ) {
				var item:TestOrLotteryListItem = new TestOrLotteryListItem( list[ i ], true );
				item.y = lastY;
				lastY = Math.round( item.height + lastY );
				addChild( item );
			}
			addEventListener( Event.SELECT, onTestSelect );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTestSelect( event:Event ):void {
			var testData:Object = TestOrLotteryListItem( event.target ).getData();
			var popup:TestPopup = new TestPopup( testData.id );
			popupsController.showPopup( popup, true );
		}
	}

}