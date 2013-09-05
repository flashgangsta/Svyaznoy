package com.svyaznoy {
	import com.flashgangsta.events.PopupsControllerEvent;
	import com.svyaznoy.events.EditPhotoEvent;
	import com.svyaznoy.events.PreviewEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class EditPhoto extends ProfilePhotoPopup {
		
		private var photoPreview:PreviewDepartureImage;
		private var saveButton:Button;
		private var deleteButton:Button;
		
		/**
		 * 
		 */
		
		public function EditPhoto() {
			saveButton = getChildByName( "saveButton_mc" ) as Button;
			deleteButton = getChildByName( "deleteButton_mc" ) as Button;
			
			saveButton.addEventListener( MouseEvent.CLICK, onSaveButtonClick );
			deleteButton.addEventListener( MouseEvent.CLICK, onDeleteButtonClick );
			
			addEventListener( PopupsControllerEvent.CLOSING, onClosing );
		}
		
		/**
		 * 
		 * @param	photoPreview
		 */
		
		public function init( photoPreview:PreviewDepartureImage ):void {
			this.photoPreview = photoPreview;
			var previewBitmap:Bitmap = photoPreview.getBitmap();
			
			selectDepartureByID( photoPreview.getData().departure_id );
			
			titleInput.text = photoPreview.getData().anonce;
			
			if ( previewBitmap ) {
				addBitmap( getBitmapCopy( previewBitmap ) );
			} else {
				removeBitmap();
				photoPreview.addEventListener( PreviewEvent.ON_PREVIEW_LOADED, onBitmapLoaded );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getPhotoPreview():PreviewDepartureImage {
			return photoPreview;
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClosing( event:PopupsControllerEvent ):void {
			if ( photoPreview ) {
				photoPreview.removeEventListener( PreviewEvent.ON_PREVIEW_LOADED, onBitmapLoaded );
				photoPreview = null;
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
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSaveButtonClick( event:MouseEvent ):void {
			var data:Object = photoPreview.getData();
			var newAnonce:String;
			var newDeparture:String;
			
			if ( data.anonce !== titleInput.text ) {
				data.anonce = newAnonce = titleInput.text;
				photoPreview.updateAnonce();
				dispatchEvent( new EditPhotoEvent( EditPhotoEvent.ON_ANONCE_CHANGED ) );
			}
			
			if ( data.departure_id !== getSelectedDeparture() ) {
				data.departure_id = newDeparture = getSelectedDeparture();
				dispatchEvent( new EditPhotoEvent( EditPhotoEvent.ON_DEPARTURE_CHANGED ) );
			}
			
			if ( newAnonce || newDeparture ) {
				provider.updatePhoto( data.id, newAnonce, newDeparture );
			}
			
			close();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onDeleteButtonClick( event:MouseEvent ):void {
			provider.deletePhoto( photoPreview.getData().id );
			dispatchEvent( new EditPhotoEvent( EditPhotoEvent.ON_PHOTO_DELETED ) );
			close();
		}
		
	}

}