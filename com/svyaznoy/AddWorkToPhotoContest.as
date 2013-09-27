package com.svyaznoy {
	import by.blooddy.crypto.image.JPEGEncoder;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.utils.LocalImageLoader;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.InputTextfield;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.sampler.getSize;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import ru.inspirit.net.MultipartURLLoader;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class AddWorkToPhotoContest extends AddWorkToContestPopup {
		
		private const SELECT_PHOTO_DEFAULT_Y:int = 116;
		private const SELECT_PHOTO_SELECTED_Y:int = 180;
		private const SIZE_LIMIT_MARGIN:int = 38;
		
		private var selectPhotoButton:Button;
		private var inputLabel:InputTextfield;
		private var submitButton:Button;
		private var sizeLimitLabel:TextField;
		private var fileFiltersList:Array = [ new FileFilter( "Изображения", "*.jpg;*.jpeg;*.gif;*.png" ) ];
		private var bitmap:Bitmap;
		private var localImageLoader:LocalImageLoader;
		private var imageArea:DisplayObject;
		
		/**
		 * 
		 */
		
		public function AddWorkToPhotoContest( id:int ) {
			this.id = id;
			selectPhotoButton = getChildByName( "selectPhotoButton_mc" ) as Button;
			submitButton = getChildByName( "submitButton_mc" ) as Button;
			sizeLimitLabel = getChildByName( "sizeLimit_txt" ) as TextField;
			inputLabel = getChildByName( "descriptionInput_mc" ) as InputTextfield;
			imageArea = getChildByName( "imageArea_mc" );
			
			selectPhotoButton.setLabel( "выбрать фото для загрузки".toUpperCase() );
			
			inputLabel.title = "описание работы".toUpperCase();
			inputLabel.setErrorMessage( "Введите описание работы".toUpperCase() );
			
			submitButton.setLabel( "добавить фотографию".toUpperCase() );
			
			sizeLimitLabel.visible = false;
			
			submitButton.visible = false;
			submitButton.addEventListener( MouseEvent.CLICK, onSubmitClicked );
			selectPhotoButton.addEventListener( MouseEvent.CLICK, onSelectPhotoClicked );
			
			localImageLoader = new LocalImageLoader( fileFiltersList );
			localImageLoader.addEventListener( Event.COMPLETE, onPhotoSelected );
			//TODO: сделать dispose
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSelectPhotoClicked( event:MouseEvent ):void {
			trace( "OP" );
			// Local images loader
			localImageLoader.browse();
		}
		
		private function onPhotoSelected( event:Event ):void {
			if ( bitmap ) {
				removeChild( bitmap );
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
			
			bitmap = localImageLoader.getBitmap();
			bitmap.smoothing = true;
			MappingManager.setScaleOnlyReduce( bitmap, imageArea.width, imageArea.height );
			MappingManager.setAlign( bitmap, imageArea.getBounds( this ) );
			addChild( bitmap );
			selectPhotoButton.y = SELECT_PHOTO_SELECTED_Y;
			sizeLimitLabel.y = SELECT_PHOTO_SELECTED_Y + SIZE_LIMIT_MARGIN;
			submitButton.visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSubmitClicked( event:MouseEvent ):void {
			if ( !inputLabel.length ) {
				inputLabel.showError();
			} else {
				var bytes:ByteArray = JPEGEncoder.encode( bitmap.bitmapData, 100 );
				var size:Number =  getSize( bytes ) / 1000;
				if ( size > 2000 ) {
					sizeLimitLabel.visible = true;
				} else {
					var loader:MultipartURLLoader = Provider.getInstance().uploadPhotoToContest( bytes, inputLabel.text, id );
					loader.addEventListener( Event.COMPLETE, onUploaded );
					submitButton.enabled = false;
					selectPhotoButton.enabled = false;
					inputLabel.mouseEnabled = inputLabel.mouseChildren = false;
				}
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onUploaded( event:Event ):void {
			MultipartURLLoader( event.currentTarget ).removeEventListener( Event.COMPLETE, onUploaded );
			trace( "uploaded" );
			if ( PopupsController.getInstance().getCurrentPopup() === this ) {
				PopupsController.getInstance().hidePopup();
			}
		}
		
	}

}