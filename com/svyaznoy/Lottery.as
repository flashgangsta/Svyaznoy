﻿package com.svyaznoy {	import com.flashgangsta.managers.MappingManager;	import com.flashgangsta.media.video.YoutubePlayer;	import com.flashgangsta.utils.NumUtils;	import com.flashgangsta.utils.TimeConverter;	import com.svyaznoy.events.DynamicItemEvent;	import com.svyaznoy.events.IconsListEvent;	import com.svyaznoy.events.ProviderEvent;	import com.svyaznoy.events.ScreenEvent;	import com.svyaznoy.gui.Button;	import com.svyaznoy.utils.DateParser;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextField;	/**	 * ...	 * @author Sergey Krivtsov (flashgangsta@gmail.com)	 */	public class Lottery extends Screen {				private var titleLabel:TextField;		private var dynamicContentViewer:DynamicContentViewer = new DynamicContentViewer();		private var lotteriesList:LotteriesList;		private var fullDatasList:Array;		private var player:YoutubePlayer;		private var winner:LotteryWinnerPreview;		private var winnerData:Object;		private var lotteriesArchiveList:Array;		private var bottomButton:Button;				/**		 * 		 */				public function Lottery() {			titleLabel = getChildByName( "title_txt" ) as TextField;			lotteriesList = getChildByName( "lotteriesList_mc" ) as LotteriesList;			player = getChildByName( "player_mc" ) as YoutubePlayer;			winner = getChildByName( "winner_mc" ) as LotteryWinnerPreview;			bottomButton = getChildByName( "bottomButton_mc" ) as Button;						player.visible = false;			winner.visible = false;			dynamicContentViewer.visible = false;			bottomButton.visible = false;						lotteriesList.visible = false;			lotteriesList.addEventListener( IconsListEvent.ICON_SELECTED, onItemSelected );						dynamicContentViewer.width =  titleLabel.width;			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );			addChild( dynamicContentViewer );						provider.addEventListener( ProviderEvent.ON_LOTTERY, onData );						//TODO: удалить это после того как появится раздел со списком лоттерей			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );						bottomButton.addEventListener( MouseEvent.CLICK, onBackClicked );		}				/**		 * 		 * @param	event		 */				private function onBackClicked( event:MouseEvent ):void {			dispatchEvent( new ScreenEvent( ScreenEvent.GO_BACK ) );		}				/**		 * 		 * @param	event		 */				private function onAddedToStage( event:Event ):void {			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			player.visible = false;			winner.visible = false;			dynamicContentViewer.visible = false;			lotteriesList.visible = false;			bottomButton.visible = false;		}				/**		 * 		 * @param	lotteryData		 */				public function showLottery( lotteryData:Object ):void {			if ( data && data.id === lotteryData.id ) {				return;			}			super.data = lotteryData;			addPreloader();			titleLabel.text = data.title;			var winnersList:Array = data.winners as Array;						if( winnersList.length ) {				winnerData = winnersList[ Math.round( Math.random() * (winnersList.length - 1) ) ];			} else {				winnerData = null;			}						if( winnerData ) {				winner.showWinner( winnerData );			}						provider.addEventListener( ProviderEvent.ON_LOTTERIES, onLotteries );						provider.getLotteryByID( data.id );			provider.getLotteries( LotteriesList.DISPLAYED_LENGTH * 2 );					}				/**		 * 		 * @param	event		 */				override protected function onData( event:ProviderEvent ):void {			super.onData( event );			displayData();			removePreloader();		}				/**		 * 		 */				override protected function displayData():void {						super.displayData();						if ( !winnerData ) {				var lotteryDate:Date = DateParser.parseAndConvertToLocalTime( data.date );				var day:String = lotteryDate.day + "-го";				var month:String = DateParser.getMonthNameByNum( lotteryDate.month )				var time:String = TimeConverter.getTimeByDate( lotteryDate );				var lotteryStartMessage:String = "\n\nРезультаты лоттереи будут опубликованы " + day + " " + month + " в " + time + " по местному времени.";				data.content += lotteryStartMessage;			} else {				if( data.video ) {					player.setVideo( data.video );				}			}			dynamicContentViewer.displayData( data.content );			titleLabel.text = data.title;			setPositions();			winner.visible = Boolean( winnerData );			player.visible = Boolean( data.video );			dynamicContentViewer.visible = true;			bottomButton.visible = true;		}				/**		 * 		 */				private function setPositions():void {			dynamicContentViewer.y = MappingManager.getBottom( titleLabel, this );						if( winnerData ) {				lotteriesList.y = MappingManager.getBottom( player, this ) + ( MARGIN * 2 );				player.y = winner.y = MappingManager.getBottom( dynamicContentViewer, this ) + MARGIN;				bottomButton.y = MappingManager.getBottom( player, this );			} else {				player.y = winner.y = 0;				lotteriesList.y = MappingManager.getBottom( dynamicContentViewer, this ) + MARGIN;				bottomButton.y = Math.round( lotteriesList.y + lotteriesList.height );			}						dispatchHeighUpdated();		}				/**		 * 		 * @param	event		 */				private function onSizeChanged( event:DynamicItemEvent ):void {			setPositions();		}				/**		 * 		 * @param	event		 */				private function onLotteries( event:ProviderEvent ):void {			var datasList:Array = event.data as Array;			var listToShow:Array = [];			var data:Object;			var currentDate:Date = new Date();			var lotteryDate:Date			for ( var i:int = 0; i < datasList.length; i++ ) {				data = datasList[ i ];				if ( data.id !== super.data.id && data.winner ) {					listToShow.push( data );				}			}						lotteriesArchiveList = listToShow;						if( listToShow.length ) {				lotteriesList.showList( listToShow );				lotteriesList.visible = true;			}			provider.removeEventListener( ProviderEvent.ON_LOTTERIES, onLotteries );			setPositions();		}				/**		 * 		 * @param	event		 */				private function onItemSelected( event:IconsListEvent ):void {			player.visible = false;			winner.visible = false;			dynamicContentViewer.visible = false;			lotteriesList.visible = false;			bottomButton.visible = false;			showLottery( event.data );		}			}}