package com.svyaznoy {	import com.flashgangsta.managers.MappingManager;	import com.svyaznoy.events.ProviderEvent;	import com.svyaznoy.gui.Paging;	import com.svyaznoy.gui.SearchLine;	import com.svyaznoy.gui.SortButton;	import flash.automation.ActionGenerator;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	/**	 * ...	 * @author Sergey Krivtsov (flashgangsta@gmail.com)	 */	public class Ratings extends Screen {				const OWNER_TEXT_COLOR:uint = 0xA28BB3;		const OWNER_BACKKGROUND_HEIGHT:int = 22;						private var rowsLength:int = 21;				private var positionsLabel:TextField;		private var namesLabel:TextField;		private var ratingLabel:TextField;		private var nameFittingLabel:TextField;		private var paging:Paging;		private var datasList:Array = [];		private var userName:String;		private var ownerRatingData:Object;		private var order:int = Array.NUMERIC;		private var userData:UserData;		private var ownerBackground:Sprite;		private var defaultTextFormatName:TextFormat;		private var ownerTextFormatName:TextFormat;		private var defaultTextFormatPosition:TextFormat;		private var ownerTextFormatPosition:TextFormat;		private var defaultTextFormatRating:TextFormat;		private var ownerTextFormatRating:TextFormat;		private var loader:ProviderURLLoader;		private var sortByPositionsButton:SortButton;		private var searchLine:SearchLine;		private var searchLoader:ProviderURLLoader;				/**		 * 		 */				public function Ratings() {			positionsLabel = getChildByName( "positionsLabel_txt" ) as TextField;			namesLabel = getChildByName( "namesLabel_txt" ) as TextField;			ratingLabel = getChildByName( "ratingLabel_txt" ) as TextField;			nameFittingLabel = getChildByName( "nameFittingLabel_txt" ) as TextField;			ownerBackground = getChildByName( "ownerBackground_mc" ) as Sprite;			paging = getChildByName( "paging_mc" ) as Paging;			searchLine = getChildByName( "search_mc" ) as SearchLine;			sortByPositionsButton = getChildByName( "sortByPositionsButton_mc" ) as SortButton;						defaultTextFormatName = namesLabel.getTextFormat();			ownerTextFormatName = nameFittingLabel.getTextFormat();			defaultTextFormatPosition = positionsLabel.getTextFormat();			ownerTextFormatPosition = positionsLabel.getTextFormat();			defaultTextFormatRating = ratingLabel.getTextFormat();			ownerTextFormatRating = ratingLabel.getTextFormat();			ownerTextFormatName.color = OWNER_TEXT_COLOR;			ownerTextFormatPosition.color = OWNER_TEXT_COLOR;			ownerTextFormatRating.color = OWNER_TEXT_COLOR;						nameFittingLabel.visible = false;			searchLine.visible = false;						positionsLabel.autoSize = TextFieldAutoSize.LEFT;			namesLabel.autoSize = TextFieldAutoSize.LEFT;			ratingLabel.autoSize = TextFieldAutoSize.LEFT;			nameFittingLabel.autoSize = TextFieldAutoSize.LEFT;						clearTable();			nameFittingLabel.text = "";						initUserName();						provider.addEventListener( ProviderEvent.ON_OWNER_RATING, onOwnerRating );			provider.addEventListener( ProviderEvent.ON_RATINGS, onData );			provider.addEventListener( ProviderEvent.ON_EMPLOYEES_LENGTH, onEmployeesLength );			provider.addEventListener( ProviderEvent.ON_RATINGS_SEARCHED, onSearched );						provider.getOwnerRating();			provider.getEmploeeLength();			loader = provider.getRatings( rowsLength, 0, order );						ownerBackground.visible = false;						sortByPositionsButton.addEventListener( MouseEvent.CLICK, changeOrder );			sortByPositionsButton.disabledAlpha = 1;			sortByPositionsButton.enabled = false;						searchLine.addEventListener( Event.CHANGE, onSearchInput );		}				/**		 * 		 * @param	event		 */				override protected function onData( event:ProviderEvent ):void {			loader = null;			super.onData( event );			datasList = super.data as Array;			addOwnerToList();			if( ownerRatingData ) {				displayData();			}		}				/**		 * 		 */				override protected function displayData():void {			super.displayData();						var item:Object;			var name:String;			var position:String;			var rating:String;			var newlineTag:String = "\n";			var fieldsToViewLength:int = datasList.length;			var ownerNameBeginIndex:int;			var ownerNameEndIndex:int;			var ownerPositionBeginIndex:int;			var ownerPositionEndIndex:int;			var ownerRatingBeginIndex:int;			var ownerRatingEndIndex:int;			var ownerLines:int = 1;						sortByPositionsButton.enabled = true;						namesLabel.setTextFormat( defaultTextFormatName );			positionsLabel.setTextFormat( defaultTextFormatPosition );			ratingLabel.setTextFormat( defaultTextFormatRating );						for ( var i:int = 0; i < fieldsToViewLength; i++ ) {				item = datasList[ i ];								name = item.last_name + " " + item.first_name;				position = item.position;				rating = item.rating;								if ( getNumLinesByName( name ) > 1 ) {					name = item.last_name + newlineTag + item.first_name;					newlineTag += "\n";					fieldsToViewLength--;					ownerLines = 2;				} else {					ownerLines = 1;				}								namesLabel.appendText( name + "\n" );				positionsLabel.appendText( position + newlineTag );				ratingLabel.appendText( rating + newlineTag );								if ( item.id === ownerRatingData.id ) {					ownerNameBeginIndex = namesLabel.length - name.length - ownerLines;					ownerNameEndIndex = ownerNameBeginIndex + name.length + ( ownerLines - 1 );										ownerPositionBeginIndex = positionsLabel.length - position.length - ownerLines;					ownerPositionEndIndex = ownerPositionBeginIndex + position.length;										ownerRatingBeginIndex = ratingLabel.length - rating.length - ownerLines;					ownerRatingEndIndex = ownerRatingBeginIndex + rating.length;										if ( ownerPositionBeginIndex === 0 ) {						ownerBackground.y = namesLabel.y - 1;					} else {						ownerBackground.y = MappingManager.getBottom( namesLabel, this ) - ownerBackground.height;					}										ownerBackground.height = ownerLines === 1 ? OWNER_BACKKGROUND_HEIGHT : OWNER_BACKKGROUND_HEIGHT * 2;										ownerBackground.visible = true;				}				newlineTag = "\n";			}						namesLabel.setTextFormat( ownerTextFormatName, ownerNameBeginIndex, ownerNameEndIndex );			positionsLabel.setTextFormat( ownerTextFormatPosition, ownerPositionBeginIndex, ownerPositionEndIndex );			ratingLabel.setTextFormat( ownerTextFormatRating, ownerRatingBeginIndex, ownerRatingEndIndex );		}				/**		 * 		 * @return		 */				private function addOwnerToList():int {			var item:Object;			var result:int = -1;						for ( var i:int = 0; i < datasList.length; i++ ) {				item = datasList[ i ];				if ( item.id === ownerRatingData.id ) {					result = i;					break;				}			}						if ( result === -1 ) {				while ( datasList.length >= rowsLength ) {					datasList.pop();				}				datasList.push( ownerRatingData );				datasList.sortOn( "position", order );				result = addOwnerToList();			}						return result;		}				/**		 * 		 */				private function initUserName():void {			userData = Helper.getInstance().getUserData();						/// Переносит имя на две строчки если не влазит в одну			userName = userData.lastName + " " + userData.firstName;			if ( getNumLinesByName( userName ) > 1 ) {				userName = userData.lastName + "\n" + userData.firstName;				rowsLength -= 1;			}		}				/**		 * 		 * @param	name		 * @return		 */				private function getNumLinesByName( name:String ):int {			nameFittingLabel.text = name;			return nameFittingLabel.numLines;		}				/**		 * 		 * @param	event		 */				private function onOwnerRating( event:ProviderEvent ):void {			ownerRatingData = event.data;						if ( data ) {				displayData();			}						searchLine.visible = true;			provider.removeEventListener( ProviderEvent.ON_OWNER_RATING, onOwnerRating );		}				/**		 * 		 * @param	event		 */				private function onEmployeesLength( event:ProviderEvent ):void {			var length:int = int( event.data );			paging.init( Math.ceil( length / rowsLength ) );			paging.x = MappingManager.getCentricPoint( width, paging.width );			if ( !paging.hasEventListener( Event.CHANGE ) ) {				paging.addEventListener( Event.CHANGE, onPagingChanged );			}			provider.removeEventListener( ProviderEvent.ON_EMPLOYEES_LENGTH, onEmployeesLength );		}				/**		 * 		 * @param	event		 */				private function onPagingChanged( event:Event = null ):void {			loadData();			paging.visible = true;		}				/**		 * 		 */				private function loadData():void {			clearTable();			addPreloader();			removeLoader();			removeSearchLoader();			loader = provider.getRatings( rowsLength, ( rowsLength - 1 ) * ( paging.value - 1 ), order );			sortByPositionsButton.enabled = false;		}				/**		 * 		 */				private function clearTable():void {			positionsLabel.text = "";			namesLabel.text = "";			ratingLabel.text = "";			ownerBackground.visible = false;		}				/**		 * 		 * @param	event		 */				private function changeOrder( event:MouseEvent ):void {			order = sortByPositionsButton.changeSortMethod();			loadData();		}				/**		 * 		 * @param	event		 */				private function onSearchInput( event:Event ):void {			var searchString:String = searchLine.value;			event.stopImmediatePropagation();			if ( !searchString ) {				onPagingChanged();				return;			}			removeLoader();			removeSearchLoader();			clearTable();			addPreloader();			searchLoader = provider.searchRatings( searchString, "", "", rowsLength, 0, order );			paging.visible = false;		}				private function removeSearchLoader():void {			if ( searchLoader ) {				searchLoader.dispose();				searchLoader = null;			}		}				private function removeLoader():void {			if ( loader ) {				loader.dispose();				loader = null;			}		}				/**		 * 		 * @param	event		 */				private function onSearched( event:ProviderEvent ):void {			onData( event );		}	}}