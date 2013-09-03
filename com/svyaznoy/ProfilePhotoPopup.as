package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.ui.Scrollbar;
	import com.svyaznoy.gui.InputTextfield;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProfilePhotoPopup extends Popup {
		
		protected var imageArea:Sprite;
		protected var bitmap:Bitmap;
		protected var scrollbar:ScrollbarView;
		protected var titleInput:InputTextfield;
		protected var departuresContainer:MovieClip;
		protected var departuresMask:Sprite;
		protected var departuresButtonsList:Array = [];
		protected var _enabled:Boolean;
		protected var preloader:MiniPreloader;
		
		/**
		 * 
		 */
		
		public function ProfilePhotoPopup() {
			imageArea = getChildByName( "imageArea_mc" ) as Sprite;
			titleInput = getChildByName( "titleInput_mc" ) as InputTextfield;
			departuresMask = getChildByName( "mask_mc" ) as Sprite;
			departuresContainer = getChildByName( "listContainer_mc" ) as MovieClip;
			scrollbar = getChildByName( "scrollbar_mc" ) as ScrollbarView;
			
			titleInput.autoDispose = false;
			titleInput.title = "описание ФОТОГРАФИИ...".toLocaleUpperCase();
			scrollbar.visible = false;
			titleInput.setErrorMessage( "Заполните поле «Описание фотографии»" );
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
		 * @param	bitmap
		 */
		
		protected function addBitmap( bitmap:Bitmap ):void {
			removeBitmap();
			this.bitmap = bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleOnlyReduce( bitmap, imageArea.width, imageArea.height );
			MappingManager.setAlign( bitmap, imageArea.getBounds( this ) );
			bitmap.mask = imageArea;
			addChild( bitmap );
		}
		
		/**
		 * 
		 */
		
		protected function get enabled():Boolean {
			return _enabled;
		}
		
		protected function set enabled( value:Boolean ):void {
			_enabled = value;
			departuresContainer.mouseEnabled = departuresContainer.mouseChildren = _enabled;
			titleInput.mouseEnabled = titleInput.mouseChildren = _enabled;
			scrollbar.mouseEnabled = scrollbar.mouseChildren = _enabled;
			
			departuresContainer.alpha = titleInput.alpha = scrollbar.alpha = value ? 1 : .5;
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
		
		private function removeBitmap():void {
			if ( !bitmap ) return;
			bitmap.bitmapData.dispose();
			if( bitmap.loaderInfo && bitmap.loaderInfo.loader ) bitmap.loaderInfo.loader.unloadAndStop();
			bitmap.mask = null;
			removeChild( bitmap );
			bitmap = null;
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
		
	}

}