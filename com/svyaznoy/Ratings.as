package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Ratings extends Screen {
		
		private var rowsLength:int = 20;
		
		private var positionsLabel:TextField;
		private var namesLabel:TextField;
		private var pointsLabel:TextField;
		private var nameFittingLabel:TextField;
		
		private var datasList:Array;
		private var userName:String;
		private var ownerRatingData:Object;
		private var sortedByPosition:Boolean = true;
		private var order:int = Array.NUMERIC;
		private var userData:UserData;
		private var ownerBackground:Sprite;
		
		/**
		 * 
		 */
		
		public function Ratings() {
			positionsLabel = getChildByName( "positionsLabel_txt" ) as TextField;
			namesLabel = getChildByName( "namesLabel_txt" ) as TextField;
			pointsLabel = getChildByName( "pointsLabel_txt" ) as TextField;
			nameFittingLabel = getChildByName( "nameFittingLabel_txt" ) as TextField;
			ownerBackground = getChildByName( "ownerBackground_mc" ) as Sprite;
			
			nameFittingLabel.visible = false;
			
			positionsLabel.autoSize = TextFieldAutoSize.LEFT;
			namesLabel.autoSize = TextFieldAutoSize.LEFT;
			pointsLabel.autoSize = TextFieldAutoSize.LEFT;
			nameFittingLabel.autoSize = TextFieldAutoSize.LEFT;
			
			positionsLabel.text = "";
			namesLabel.text = "";
			pointsLabel.text = "";
			nameFittingLabel.text = "";
			
			initUserName();
			
			provider.addEventListener( ProviderEvent.ON_RATINGS_SEARCHED, onOwnerSearched );
			provider.addEventListener( ProviderEvent.ON_RATINGS, onData );
			
			provider.searchRatings( userData.lastName, userData.middleName, userData.middleName, 1, 0, sortedByPosition ? order : 0, !sortedByPosition ? order : 0 );
			provider.getRatings( rowsLength, 0, sortedByPosition ? order : 0, !sortedByPosition ? order : 0 );
			
			ownerBackground.visible = false;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			datasList = data as Array;
			if( ownerRatingData ) {
				displayData();
			}
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			
			var item:Object;
			var name:String;
			var newlineTag:String = "\n";
			var fieldsToViewLength:int = datasList.length;
			var ownerIndex:int = getOwnerIndex();
			
			for ( var i:int = 0; i < fieldsToViewLength; i++ ) {
				item = datasList[ i ];
				
				name = item.last_name + " " + item.first_name;
				
				if ( getNumLinesByName( name ) > 1 ) {
					name = item.last_name + newlineTag + item.first_name;
					newlineTag += "\n";
					fieldsToViewLength--;
				}
				
				namesLabel.appendText( name + "\n" );
				
				trace( item.id, ownerRatingData.id );
				
				if ( item.id === ownerRatingData.id ) { 
					ownerBackground.y = MappingManager.getBottom( namesLabel, this ) - ownerBackground.height;
					ownerBackground.visible = true;
				}
				
				positionsLabel.appendText( item.position + newlineTag );
				pointsLabel.appendText( item.rating + newlineTag );
				
				newlineTag = "\n";
				
			}
			
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function getOwnerIndex():int {
			var item:Object;
			var result:int;
			var data:Array = data as Array;
			
			for ( var i:int = 0; i < data.length; i++ ) {
				item = data[ i ];
				if ( item.id === ownerRatingData.id ) {
					result = i;
					break;
				}
			}
			
			if ( result === -1 ) {
				data.push( ownerRatingData );
				if ( sortedByPosition ) { 
					data.sortOn( "position", order );
				} else {
					data.sortOn( "rating", order );
				}
				result = getOwnerIndex();
			}
			
			return result;
		}
		
		/**
		 * 
		 */
		
		private function initUserName():void {
			userData = Helper.getInstance().getUserData();
			
			/// Переносит имя на две строчки если не влазит в одну
			userName = userData.lastName + " " + userData.firstName;
			if ( getNumLinesByName( userName ) > 1 ) {
				userName = userData.lastName + "\n" + userData.firstName;
				rowsLength -= 1;
			}
		}
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		
		private function getNumLinesByName( name:String ):int {
			nameFittingLabel.text = name;
			return nameFittingLabel.numLines;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onOwnerSearched( event:ProviderEvent ):void {
			ownerRatingData = event.data[ 0 ];
			if ( data ) {
				displayData();
			}
		}
		
	}

}