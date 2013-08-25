package com.svyaznoy {
	import com.svyaznoy.events.LotteryEvent;
	import com.svyaznoy.events.ProviderEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Contests extends Screen {
		
		public function Contests() {
			provider.getLotteries( 1 );
			provider.addEventListener( ProviderEvent.ON_LOTTERIES, onLottery );
		}
		
		private function onLottery( event:ProviderEvent ):void {
			var outputEvent:LotteryEvent = new LotteryEvent( LotteryEvent.LOTTERY_SELECTED );
			outputEvent.lotteryData = event.data[ 0 ];
			Dispatcher.getInstance().dispatchEvent( outputEvent );
		}
		
	}

}