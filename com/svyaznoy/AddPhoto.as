package com.svyaznoy {
	import by.blooddy.crypto.image.JPEGEncoder;
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.ui.Scrollbar;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.InputTextfield;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AddPhoto extends Popup {
		
		private var imageArea:Sprite;
		private var bitmap:Bitmap;
		private var scrollbar:ScrollbarView;
		private var titleInput:InputTextfield;
		private var submitButton:Button;
		private var departuresContainer:MovieClip;
		private var departuresMask:Sprite;
		private var departuresButtonsList:Array = [];
		private var preloader:MiniPreloader;
		private var uploadedPhotoData:Object;
		
		/**
		 * 
		 */
		
		public function AddPhoto() {
			imageArea = getChildByName( "imageArea_mc" ) as Sprite;
			titleInput = getChildByName( "titleInput_mc" ) as InputTextfield;
			submitButton = getChildByName( "submitButton_mc" ) as Button;
			departuresMask = getChildByName( "mask_mc" ) as Sprite;
			departuresContainer = getChildByName( "listContainer_mc" ) as MovieClip;
			scrollbar = getChildByName( "scrollbar_mc" ) as ScrollbarView;
			
			submitButton.setLabel( "добавить фотографию".toUpperCase() );
			submitButton.addEventListener( MouseEvent.CLICK, onSubmitButtonClicked );
			
			titleInput.autoDispose = false;
			titleInput.title = "описание ФОТОГРАФИИ...".toLocaleUpperCase();
			scrollbar.visible = false;
			titleInput.setErrorMessage( "Заполните поле «Описание фотографии»" );
		}
		
		/**
		 * 
		 * @param	bitmap
		 */
		
		public function init( bitmap:Bitmap ):void {
			removeBitmap();
			this.bitmap = bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleOnlyReduce( bitmap, imageArea.width, imageArea.height );
			MappingManager.setAlign( bitmap, imageArea.getBounds( this ) );
			bitmap.mask = imageArea;
			addChild( bitmap );
			
			titleInput.text = "";
		}
		
		/**
		 * 
		 * @param	list
		 */
		
		public function setDepartures( list:Array ):void {
			if ( departuresContainer.numChildren ) return;
			
			var year:String = "";
			var data:Object;
			var yearLabel:DepartureListYearLabel;
			var button:DepartureListButton;
			
			list.sortOn( "year", Array.NUMERIC | Array.DESCENDING );
			
			for ( var i:int = 0; i < list.length; i++ ) {
				data = list[ i ];
				if( int( data.status ) ) {
					if ( year !== data.year ) {
						year = data.year;
						yearLabel = new DepartureListYearLabel();
						yearLabel.text = year;
						yearLabel.y = departuresContainer.height;
						departuresContainer.addChild( yearLabel );
					}
					button = new DepartureListButton();
					button.id = data.id;
					button.label = data.title;
					button.y = departuresContainer.height;
					departuresContainer.addChild( button );
					departuresButtonsList.push( button );
				}
			}
			
			ButtonManager.addButtonGroup( departuresButtonsList, true, departuresButtonsList[ 0 ] );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageAfterDeparturesSet );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return MappingManager.getBottom( background, this );
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
		
		private function onAddedToStageAfterDeparturesSet( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStageAfterDeparturesSet );
			Scrollbar.setVertical( departuresContainer, departuresMask.getBounds( this ), scrollbar.getUpBtn(), scrollbar.getDownBtn(), scrollbar.getCarret(), scrollbar.getBounds( scrollbar ), departuresContainer );
			scrollbar.visible = Scrollbar.isNeeded( scrollbar.getCarret() );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSubmitButtonClicked( event:MouseEvent ):void {
			if ( !titleInput.length ) {
				titleInput.showError();
			} else {
				submitButton.enabled = false;
				departuresContainer.mouseEnabled = departuresContainer.mouseChildren = false;
				departuresContainer.alpha = submitButton.alpha;
				titleInput.mouseEnabled = titleInput.mouseChildren = false;
				titleInput.alpha = submitButton.alpha;
				scrollbar.mouseEnabled = scrollbar.mouseChildren = false;
				scrollbar.alpha = submitButton.alpha;
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
			var popupsController:PopupsController = PopupsController.getInstance();
			if ( popupsController.getCurrentPopup() === this ) {
				popupsController.hidePopup();
			}
			uploadedPhotoData = event.data;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 */
		
		private function removeBitmap():void {
			if ( !bitmap ) return;
			bitmap.bitmapData.dispose();
			bitmap.loaderInfo.loader.unloadAndStop();
			bitmap = null;
		}
		
	}

}