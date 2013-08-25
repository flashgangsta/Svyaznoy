package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.media.video.YoutubePlayer;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Lottery extends Screen {
		
		private var titleLabel:TextField;
		private var dynamicContentViewer:DynamicContentViewer = new DynamicContentViewer();
		private var lotteriesList:LotteriesList;
		private var fullDatasList:Array;
		private var player:YoutubePlayer;
		private var winner:LotteryWinnerPreview;
		
		/**
		 * 
		 */
		
		public function Lottery() {
			titleLabel = getChildByName( "title_txt" ) as TextField;
			lotteriesList = getChildByName( "lotteriesList_mc" ) as LotteriesList;
			player = getChildByName( "player_mc" ) as YoutubePlayer;
			winner = getChildByName( "winner_mc" ) as LotteryWinnerPreview;
			
			setElementsForVisibleControll( player, winner );
			setVisibleForElements( false );
			lotteriesList.visible = false;
			
			dynamicContentViewer.width =  titleLabel.width;
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
			addChild( dynamicContentViewer );
		}
		
		/**
		 * 
		 * @param	lotteryData
		 */
		
		public function showLottery( lotteryData:Object ):void {
			if ( data && data.id === lotteryData.id ) return;
			data = lotteryData;
			titleLabel.text = data.title;
			winner.showWinner( data.winner );
			provider.getLotteryByID( data.id );
			provider.addEventListener( ProviderEvent.ON_LOTTERY, onData );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			displayData();
			removePreloader();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			player.setVideo( data.video );
			dynamicContentViewer.displayData( data.content );
			setPositions();
			setVisibleForElements( true );
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			dynamicContentViewer.y = MappingManager.getBottom( titleLabel, this );
			player.y = winner.y = MappingManager.getBottom( dynamicContentViewer, this ) + MARGIN;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			setPositions();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLotteries( event:ProviderEvent ):void {
			var listToShow:Array = [];
			fullDatasList = event.data as Array;
			listToShow = fullDatasList.slice( 1 );
			lotteriesList.showList( listToShow );
		}
		
	}

}