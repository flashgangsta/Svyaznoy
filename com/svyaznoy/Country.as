package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import com.svyaznoy.utils.DateParser;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Country extends ScreenWithBottomButton {
		
		private const MARGIN:int = 10;
		
		private var galleriesList:PreviewsTable;
		private var videosList:PreviewsTable;
		private var photosTitle:DisplayObject;
		private var videosTitle:DisplayObject;
		
		public function Country() {
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
			
			setElementsForVisibleControll( header, dynamicContentViewer, bottomButton );
			
			photosTitle = getChildByName( "photosTitle_mc" );
			videosTitle = getChildByName( "videosTitle_mc" );
			
			photosTitle.visible = false;
			videosTitle.visible = false;
			setVisibleForElements( false );
		}
		
		/**
		 * 
		 * @param	itemData
		 */
		
		public function showCountry( itemData:Object ):void {
			if ( galleriesList ) {
				photosTitle.visible = false;
				galleriesList.dispose();
				removeChild( galleriesList );
				galleriesList = null;
			}
			
			if ( videosList ) {
				videosTitle.visible = false;
				videosList.dispose();
				removeChild( videosList );
				videosList = null;
			}
			
			setVisibleForElements( false );
			addPreloader();
			
			provider.getDeparture( itemData.id, "galleries,videos" );
			if( !provider.hasEventListener( ProviderEvent.ON_DEPARTURE ) ) {
				provider.addEventListener( ProviderEvent.ON_DEPARTURE, onData );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			
			bottomButton.addEventListener( MouseEvent.CLICK, onBackClicked );
			
			if ( data.galleries.length ) {
				var sortedGalleries:Array = sortByDate( data.galleries );
				photosTitle.visible = true;
				galleriesList = new PreviewsTable();
				galleriesList.fill( data.galleries, PreviewGallery, 3 );
				addChild( galleriesList );
			}
			
			if ( data.videos.length ) {
				var sortedVideos:Array = sortByDate( data.videos );
				videosTitle.visible = true;
				videosList = new PreviewsTable();
				videosList.fill( sortedVideos, PreviewVideo, 3 );
				videosList.makeNavigationToVideoReport();
				addChild( videosList );
			}
			
			setVisibleForElements( true );
			
			setPositions();
		}
		
		private function sortByDate( list:Array ):Array {
			var result:Array = [];
			var item:Object;
			for ( var i:int = 0; i < list.length; i++ ) {
				item = list[ i ];
				item.time_of_updated_at = DateParser.parse( item.updated_at ).time;
				result.push( item );
			}
			
			result.sortOn( "time_of_updated_at", Array.NUMERIC | Array.DESCENDING );
			
			return result;
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			var lastItem:DisplayObject = dynamicContentViewer.numChildren ? dynamicContentViewer : header;
			
			if ( galleriesList ) {
				photosTitle.y =  MappingManager.getBottom( lastItem, this ) + MARGIN;
				lastItem = photosTitle;
				galleriesList.y = MappingManager.getBottom( lastItem, this ) + MARGIN;
				lastItem = galleriesList;
			}
			
			if ( videosList ) {
				videosTitle.y =  MappingManager.getBottom( lastItem, this ) + MARGIN;
				lastItem = videosTitle;
				videosList.y = MappingManager.getBottom( lastItem, this ) + MARGIN;
				lastItem = videosList;
			}
			
			bottomButton.y = MappingManager.getBottom( lastItem, this ) + ScreenWithBottomButton.MARGIN;
			
			dispatchHeighUpdated();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBackClicked( event:MouseEvent ):void {
			dispatchEvent( new ScreenEvent( ScreenEvent.GO_BACK ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:Event ):void {
			setPositions();
		}
		
	}

}