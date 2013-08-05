package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.PreviewsTableEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PhotoReport extends ReportScreen {
		
		private const TITLE_BOTTOM_MARGIN:int = 15;
		
		private var photosList:Array
		
		/**
		 * 
		 */
		
		public function PhotoReport() {
			
		}
		
		/**
		 * 
		 * @param	departureData
		 */
		
		override public function showReport( departureData:Object ):void {
			super.showReport( departureData );
			if ( !needUpdate ) return;
			previewDatasList = data.galleries;
			displayData();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			title.text = data.title + ": ФОТООТЧЁТЫ";
			initPreviews();
			bottomButton.y = MappingManager.getBottom( previewsTable, this ) + ScreenWithBottomButton.MARGIN;
			dispatchHeighUpdated();
		}
		
		/**
		 * 
		 */
		
		override protected function initPreviews():void {
			super.initPreviews();
			
			previewsTable = new PreviewsTable();
			previewsTable.fill( previewDatasList, PreviewGallery );
			previewsTable.addEventListener( PreviewsTableEvent.ON_PREVIEW_SELECTED, onPreviewSelected );
			previewsTable.y = MappingManager.getBottom( title, this ) + TITLE_BOTTOM_MARGIN;
			addChild( previewsTable );
		}
		
	}

}