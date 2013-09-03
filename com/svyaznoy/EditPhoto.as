package com.svyaznoy {
	import com.flashgangsta.events.PopupsControllerEvent;
	import com.svyaznoy.events.PreviewEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class EditPhoto extends ProfilePhotoPopup {
		
		private var photoPreview:PreviewDepartureImage;
		
		/**
		 * 
		 */
		
		public function EditPhoto() {
			addEventListener( PopupsControllerEvent.CLOSING, onClosing );
		}
		
		private function onClosing( event:PopupsControllerEvent ):void {
			if ( photoPreview ) {
				photoPreview.removeEventListener( PreviewEvent.ON_PREVIEW_LOADED, onBitmapLoaded );
				photoPreview = null;
			}
		}
		
		/**
		 * 
		 * @param	photoPreview
		 */
		
		public function init( photoPreview:PreviewDepartureImage ):void {
			this.photoPreview = photoPreview;
			var previewBitmap:Bitmap = photoPreview.getBitmap();
			if ( previewBitmap ) {
				addBitmap( getBitmapCopy( previewBitmap ) );
			} else {
				photoPreview.addEventListener( PreviewEvent.ON_PREVIEW_LOADED, onBitmapLoaded );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBitmapLoaded( event:Event ):void {
			event.stopImmediatePropagation();
			photoPreview.removeEventListener( PreviewEvent.ON_PREVIEW_LOADED, onBitmapLoaded );
			addBitmap( getBitmapCopy( photoPreview.getBitmap() ) );
		}
		
		/**
		 * 
		 * @param	originalBitmap
		 * @return
		 */
		
		private function getBitmapCopy( originalBitmap:Bitmap ):Bitmap {
			var copyBitmapData:BitmapData = originalBitmap.bitmapData.clone();
			var copyBitmap:Bitmap = new Bitmap( copyBitmapData );
			copyBitmap.smoothing = true;
			return copyBitmap;
		}
		
	}

}