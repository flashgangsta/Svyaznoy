package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DepartureGalleriesBar extends DroppedPhotosBar {
		
		private const TITLE:String = "ФОТООТЧЁТЫ";
		private const ROW_COUNT:int = 3;
		private const TITLE_LENGTH_NAME:String = "фотогалерей";
		
		public function DepartureGalleriesBar( datasList:Vector.<Object> ) {
			super( ROW_COUNT, datasList, true, DepartureGalleryPreview, TITLE, TITLE_LENGTH_NAME );
		}
		
	}

}