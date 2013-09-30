 package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.LotteryEvent;
	import com.svyaznoy.events.NavigationEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Contests extends Screen {
		
		private const ITEMS_LIMIT:int = 30;
		
		private var loader:ProviderURLLoader;
		private var contestButton:MovieClip;
		private var lotteryButton:MovieClip;
		private var testsButton:MovieClip;
		private var eventType:String;
		private var itemClass:Class;
		private var container:Sprite = new Sprite();
		private var dispatcher:Dispatcher = Dispatcher.getInstance();
		private var selectedItemID:int;
		
		/**
		 * 
		 */
		
		public function Contests() {
			var buttons:Array;
			addChild( container );
			contestButton = getChildByName( "contest_mc" ) as MovieClip;
			lotteryButton = getChildByName( "lottery_mc" ) as MovieClip;
			testsButton = getChildByName( "tests_mc" ) as MovieClip;
			buttons = [ contestButton, lotteryButton, testsButton ];
			ButtonManager.addButtonGroup( buttons, false, buttons[ 0 ], false, ButtonManager.STATE_PRESSED, onSelect );
			ButtonManager.callReleaseHandler( buttons[ 0 ] );
			
			addEventListener( Event.SELECT, onItemSelect );
			addEventListener( ScreenEvent.HEIGHT_UPDATED, onHeightUpdated );
		}
		
		private function onHeightUpdated( event:ScreenEvent ):void {
			var lastY:int = 0;
			
			for ( var i:int = 0; i < container.numChildren; i++ ) {
				var item:DisplayObject = container.getChildAt( i );
				item.y = lastY;
				lastY = Math.ceil( item.height + lastY );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getSelectedItemID():int {
			return selectedItemID;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onItemSelect( event:Event ):void {
			event.stopImmediatePropagation();
			
			var selectedItem:ContestSectionListItem = event.target as ContestSectionListItem;
			trace( selectedItem );
			
			switch( ButtonManager.getSelectedButtonOfGroup( contestButton ) ) {
				case testsButton:
					var testData:Object = selectedItem.getData();
					PopupsController.getInstance().showPopup( new TestPopup( testData.id ), true );
					break;
				case contestButton:
					selectedItemID = selectedItem.getData().id;
					dispatcher.dispatchEvent( new NavigationEvent( NavigationEvent.NAVIGATE_TO_CONTEST_DETAILED ) );
					break;
				case lotteryButton:
					var outputEvent:LotteryEvent = new LotteryEvent( LotteryEvent.LOTTERY_SELECTED );
					outputEvent.lotteryData = selectedItem.getData();
					Dispatcher.getInstance().dispatchEvent( outputEvent );
					break;
			}
		}
		
		/**
		 * 
		 * @param	target
		 */
		
		private function onSelect( target:MovieClip ):void {
			if ( loader ) {
				loader.removeEventListener( eventType, onData );
				loader.dispose();
				addPreloader();
			}
			
			while ( container.numChildren ) {
				var item:ContestSectionListItem = container.getChildAt( 0 ) as ContestSectionListItem;
				item.dispose();
				container.removeChild( item );
				item = null;
			}
			
			dispatchHeighUpdated();
			
			switch( target ) {
				case contestButton:
					eventType = ProviderEvent.ON_CONTESTS_LIST;
					itemClass = ContestListItem;
					loader = provider.getContestsList( ITEMS_LIMIT );
					break;
				case lotteryButton:
					eventType = ProviderEvent.ON_LOTTERIES;
					itemClass = TestOrLotteryListItem;
					loader = provider.getLotteries( ITEMS_LIMIT );
					break;
				case testsButton:
					eventType = ProviderEvent.ON_TESTS_LIST;
					itemClass = TestOrLotteryListItem;
					loader = provider.getTestsList( ITEMS_LIMIT );
					break;
			}
			loader.addEventListener( eventType, onData );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData(event:ProviderEvent):void {
			super.onData( event );
			displayData();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			
			var list:Array = data as Array;
			var lastY:int = 0;
			container.y = contestButton.height + MARGIN;
			
			for ( var i:int = 0; i < list.length; i++ ) {
				var item:ContestSectionListItem = new itemClass( list[ i ] );
				item.y = lastY;
				lastY = Math.ceil( item.height + lastY );
				container.addChild( item );
			}
			
			removePreloader();
			
			dispatchHeighUpdated();
			trace( container.height );
		}
		
	}

}