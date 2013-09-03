package com.svyaznoy {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProfilePhotos extends Sprite {
		
		private var photosDataByDeparture:Dictionary;
		private var departuresDatasList:Array;
		private var photosDataList:Array;
		
		public function ProfilePhotos() {
			
		}
		
		/**
		 * 
		 * @param	photosDataList
		 */
		
		public function init( photosDataList:Array, departuresDatasList:Array ):void {
			var data:Object;
			var departureID:String;
			
			this.photosDataList = photosDataList;
			this.departuresDatasList = departuresDatasList;
			
			// Сортируем фотографии по выездам
			photosDataByDeparture = new Dictionary();
			
			for ( var i:int = 0; i < photosDataList.length; i++ ) {
				data = photosDataList[ i ];
				departureID = data.departure_id;
				data.departureName = getDepartureNameByID( departureID );
				if ( !photosDataByDeparture[ departureID ] ) {
					photosDataByDeparture[ departureID ] = new Vector.<Object>();
				}
				photosDataByDeparture[ departureID ].push( data );
			}
			
			showPhotos();
			
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		private function getDepartureNameByID( id:String ):String {
			var result:String = id;
			if ( departuresDatasList ) {
				for each( var data:Object in departuresDatasList ) {
					if ( data.id === id ) {
						result = data.title;
						break;
					}
				}
			}
			return result;
		}
		
		/**
		 * 
		 * @param	departuresDatasList
		 */
		
		public function setDepartures( departuresDatasList:Array ):void {
			var departureBar:ProfilePhotosDepartureBar; 
			var data:Object;
			var departureID:String;
			
			this.departuresDatasList = departuresDatasList;
			
			if ( photosDataByDeparture ) {
				for ( var i:int = 0; i < photosDataList.length; i++ ) {
					data = photosDataList[ i ];
					departureID = data.departure_id;
					data.departureName = getDepartureNameByID( departureID );
				}
				
				for ( i = 0; i < numChildren; i++ ) {
					departureBar = getChildAt( i ) as ProfilePhotosDepartureBar;
					departureBar.setLabel();
					departureBar.visible = true;
				}
				dispatchEvent( new Event( Event.RESIZE ) );
			}
		}
		
		/**
		 * 
		 */
		
		private function showPhotos():void {
			for each( var departureList:Vector.<Object> in photosDataByDeparture ) {
				var departureBar:ProfilePhotosDepartureBar = new ProfilePhotosDepartureBar( departureList );
				if( height ) {
					departureBar.y = height + 30;
				}
				departureBar.visible = Boolean( departuresDatasList );
				addChild( departureBar );
			}
			
			if ( departuresDatasList ) {
				dispatchEvent( new Event( Event.RESIZE ) );
			}
		}
		
		
		
	}

}