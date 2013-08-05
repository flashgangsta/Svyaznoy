package com.svyaznoy {
	import com.svyaznoy.events.PreviewsTableEvent;
	import com.svyaznoy.events.ScreenEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ReportScreen extends ScreenWithTitleAndBottomButton {
		
		protected var previewDatasList:Array;
		protected var previewsTable:PreviewsTable;
		protected var needUpdate:Boolean;
		
		/**
		 * 
		 */
		
		public function ReportScreen() {
			bottomButton.addEventListener( MouseEvent.CLICK, onBackClicked );
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
		 * @param	departureData
		 */
		
		public function showReport( departureData:Object ):void {
			if ( data && data.id === departureData.id ) {
				needUpdate = false;
				return;
			} else {
				needUpdate = true;
				clear();
			}
			data = departureData;
			removePreloader();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			title.text = data.title;
		}
		
		/**
		 * 
		 */
		
		protected function clear():void {
			if ( previewsTable ) {
				previewsTable.dispose();
			}
		}
		
		/**
		 * 
		 */
		
		protected function initPreviews():void {
			if ( previewsTable ) {
				previewsTable.dispose();
				removeChild( previewsTable );
				previewsTable = null;
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		protected function onPreviewSelected( event:PreviewsTableEvent ):void {
			
		}
		
	}

}