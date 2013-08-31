package com.svyaznoy {
	import com.svyaznoy.events.LotteryEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Contests extends Screen {
		
		public function Contests() {
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( event:Event ):void {
			trace( "onAddedToStage" );
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			provider.getLotteries( 1 );
			provider.addEventListener( ProviderEvent.ON_LOTTERIES, onLottery );
		}
		
		private function onLottery( event:ProviderEvent ):void {
			var outputEvent:LotteryEvent = new LotteryEvent( LotteryEvent.LOTTERY_SELECTED );
			outputEvent.lotteryData = event.data[ 0 ];
			Dispatcher.getInstance().dispatchEvent( outputEvent );
			provider.removeEventListener( ProviderEvent.ON_LOTTERIES, onLottery );
		}
		
	}

}