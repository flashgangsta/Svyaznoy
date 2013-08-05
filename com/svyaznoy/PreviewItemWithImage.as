package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewItemWithImage extends PreviewItem {
		
		protected var previewImage:PreviewImage;
		
		public function PreviewItemWithImage() {
			previewImage = getChildByName( "previewImage_mc" ) as PreviewImage;
		}
		
		override public function displayData(data:Object):void {
			super.displayData( data );
			previewImage.title = data.title;
			previewImage.description = data.anonce;
		}
		
	}

}