package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.media.video.YoutubePlayer;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.IconsListEvent;
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
			
			setElementsForVisibleControll( player, winner, dynamicContentViewer );
			setVisibleForElements( false );
			lotteriesList.visible = false;
			lotteriesList.addEventListener( IconsListEvent.ICON_SELECTED, onItemSelected );
			
			dynamicContentViewer.width =  titleLabel.width;
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
			addChild( dynamicContentViewer );
			
			provider.addEventListener( ProviderEvent.ON_LOTTERY, onData );
			provider.addEventListener( ProviderEvent.ON_LOTTERIES, onLotteries );
		}
		
		/**
		 * 
		 * @param	lotteryData
		 */
		
		public function showLottery( lotteryData:Object ):void {
			if ( data && data.id === lotteryData.id ) return;
			data = lotteryData;
			addPreloader();
			titleLabel.text = data.title;
			winner.showWinner( data.winner );
			provider.getLotteryByID( data.id );
			provider.getLotteries( LotteriesList.DISPLAYED_LENGTH + 2 );
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
			titleLabel.text = data.title;
			setPositions();
			setVisibleForElements( true );
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			dynamicContentViewer.y = MappingManager.getBottom( titleLabel, this );
			player.y = winner.y = MappingManager.getBottom( dynamicContentViewer, this ) + MARGIN;
			lotteriesList.y = MappingManager.getBottom( player, this ) + (MARGIN * 2);
			dispatchHeighUpdated();
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
			var datasList:Array = event.data as Array;
			var listToShow:Array;
			var data:Object;
			for ( var i:int = 0; i < datasList.length; i++ ) {
				data = datasList[ i ];
				if ( data.id === super.data.id ) {
					listToShow = datasList.slice( 0, i ).concat( datasList.slice( i + 1 ) );
					break;
				}
			}
			lotteriesList.showList( listToShow );
			lotteriesList.visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onItemSelected( event:IconsListEvent ):void {
			showLottery( event.data );
			setVisibleForElements( false );
			lotteriesList.visible = false;
		}
		
	}

}