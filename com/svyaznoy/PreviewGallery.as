package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewGallery extends PreviewItemWithImage {
		
		public function PreviewGallery() {
			
		}
		
		override public function displayData( data:Object ):void {
			super.displayData( data );
			previewImage.loadImage( data.photo_with_path );
			
		}
	}

}