package com.svyaznoy {
	import by.blooddy.crypto.image.JPEGEncoder;
	import com.flashgangsta.managers.ButtonManager;
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
				enabled = false;
				if ( !preloader ) {
					preloader = new MiniPreloader( "Загрузка фото", false );
					preloader.textColor = 0x232323;
					preloader.addGlow();
					MappingManager.setAlign( preloader, imageArea.getBounds( this ) );
					addChild( preloader );
				}
				
				var provider:Provider = Provider.getInstance();
				var photo:ByteArray = JPEGEncoder.encode( bitmap.bitmapData, 100 );
				var selectedDepartureButton:DepartureListButton = ButtonManager.getSelectedButtonOfGroup( departuresButtonsList[ 0 ] ) as DepartureListButton;
				
				provider.addEventListener( ProviderEvent.ON_PHOTO_UPLOADED, onPhotoUploaded );
				provider.uploadPhoto( photo, titleInput.text, selectedDepartureButton.id );
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