package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
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
			photosTitle = getChildByName( "photosTitle_mc" );
			videosTitle = getChildByName( "videosTitle_mc" );
			
			photosTitle.visible = false;
			videosTitle.visible = false;
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
				photosTitle.visible = true;
				galleriesList = new PreviewsTable();
				galleriesList.fill( data.galleries, PreviewGallery );
				addChild( galleriesList );
			}
			
			if ( data.videos.length ) {
				videosTitle.visible = true;
				videosList = new PreviewsTable();
				videosList.fill( data.videos, PreviewVideo );
				videosList.makeNavigationToVideoReport();
				addChild( videosList );
			}
			
			setPositions();
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