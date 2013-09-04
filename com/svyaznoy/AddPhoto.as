package com.svyaznoy {
	import by.blooddy.crypto.image.JPEGEncoder;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class AddPhoto extends ProfilePhotoPopup {
		private var submitButton:Button;
		private var uploadedPhotoData:Object;
		
		/**
		 * 
		 */
		
		public function AddPhoto() {
			submitButton = getChildByName( "submitButton_mc" ) as Button;
			submitButton.setLabel( "добавить фотографию".toUpperCase() );
			submitButton.addEventListener( MouseEvent.CLICK, onSubmitButtonClicked );
		}
		
		/**
		 * 
		 * @param	bitmap
		 */
		
		public function init( bitmap:Bitmap ):void {
			addBitmap( bitmap );
			titleInput.text = "";
			enabled = true;
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			
		}
		
		/**
		 * 
		 */
		
		override protected function set enabled( value:Boolean ):void {
			super.enabled = value;
			submitButton.enabled = value;
			submitButton.alpha = departuresContainer.alpha;
		}
		
		/**
		 * 
		 */
		
		public function getUploadedPhotoData():Object {
			return uploadedPhotoData;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSubmitButtonClicked( event:MouseEvent ):void {
			if ( !titleInput.length ) {
				titleInput.showError();
			} else {
				var photo:ByteArray = JPEGEncoder.encode( bitmap.bitmapData, 100 );
				
				enabled = false;
				addPreloader();
				
				provider.addEventListener( ProviderEvent.ON_PHOTO_UPLOADED, onPhotoUploaded );
				provider.uploadPhoto( photo, titleInput.text, getSelectedDeparture() );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPhotoUploaded( event:ProviderEvent ):void {
			close();
			uploadedPhotoData = event.data;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}

}