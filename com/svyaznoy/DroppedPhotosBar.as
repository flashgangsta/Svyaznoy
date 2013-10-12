package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProfilePhotosDepartureBarEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DroppedPhotosBar extends Sprite {
		
		private const LENGTH_TEXT_COLOR:uint = 0xFFFFFF;
		private const LENGTH_TEXT_SIZE:int = 14;
		private const MARGIN_H:int = 20;
		
		private var rowCount:int;
		
		protected var button:DroppedListTitleButton;
		protected var datasList:Vector.<Object>;
		protected var photosContainer:Sprite = new Sprite();
		protected var nameTextFormat:TextFormat;
		protected var lengthTextFormat:TextFormat;
		protected var titleName:String = "";
		protected var titleLenghName:String = "";
		protected var photoClass:Class;
		
		/**
		 * 
		 */
		
		public function DroppedPhotosBar( rowCount:int, datasList:Vector.<Object>, loadPhotos:Boolean, photoClass:Class, titleName:String = "", titleLenghName:String = "" ) {
			this.rowCount = rowCount;
			this.datasList = datasList;
			this.photoClass = photoClass;
			this.titleName = titleName;
			this.titleLenghName = titleLenghName;
			
			button = getChildByName( "button_mc" ) as DroppedListTitleButton;
			nameTextFormat = button.getLabelTextFormat();
			lengthTextFormat = button.getLabelTextFormat();
			lengthTextFormat.color = LENGTH_TEXT_COLOR;
			lengthTextFormat.size = LENGTH_TEXT_SIZE;
			
			button.addEventListener( MouseEvent.CLICK, onButtonClicked );
			
			photosContainer.y = MappingManager.getBottom( button, this ) + 10;
			addChild( photosContainer );
			
			setLabel();
			
			if( loadPhotos ) addPhotos();
		}
		
		/**
		 * 
		 */
		
		public function setLabel():void {
			trace( "setLabel", titleName );
			var length:int = datasList.length;
			if ( !length ) return;
			
			var lengthMessage:String = "(" + length + " " + titleLenghName + ")";
			var message:String = titleName + " " + lengthMessage;
			button.setLabel( message.toUpperCase() ) ;
			button.setLabelTextFormat( nameTextFormat, -1 );
			button.setLabelTextFormat( lengthTextFormat, titleName.length + 1, message.length );
			button.setLabel( message.toUpperCase() ) ;
			button.enabled = button.iconVisible = length > rowCount;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			var photo:PreviewItemWithImage;
			
			while ( photosContainer.numChildren ) {
				photo = getPhotoByIndex( 0 );
				photo.dispose();
				photosContainer.removeChild( photo );
				photo = null;
			}
			
			button.dispose();
			button = null;
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function addPhoto( data:Object ):void {
			movePhoto( createPhotoByData( data ) );
		}
		
		/**
		 * 
		 * @param	editedPhotoPreview
		 */
		
		public function movePhoto( photo:PreviewItemWithImage ):void {
			var length:int = getDisplayLength();
			
			setLabel();
			
			if ( !button.isOpened && numPhotos >= rowCount ) {
				return;
			}
			
			addPhotoToDisplay( photo );
			
			alignPhotos();
		}
		
		/**
		 * 
		 * @param	photo
		 */
		
		public function removePhoto( photo:PreviewItemWithImage ):void {
			photosContainer.removeChild( photo );
			updateDisplayList();
			setLabel();
		}
		
		/**
		 * 
		 */
		
		public function get numPhotos():int {
			return photosContainer.numChildren;
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			var result:Number = 0;
			var photo:PreviewItemWithImage;
			for ( var i:int = 0; i < photosContainer.numChildren; i++ ) {
				photo = getPhotoByIndex( i );
				result = Math.max( result, photo.y + photo.height );
			}
			return result + photosContainer.y;
		}
		
		/**
		 * 
		 */
		
		private function alignPhotos():void {
			var numPhotos:int = photosContainer.numChildren;
			var photo:PreviewItemWithImage;
			var photoY:int = 0;
			for ( var i:int = 0; i < numPhotos; i++ ) {
				photo = getPhotoByIndex( i ) as PreviewItemWithImage;
				photo.x = Math.round( ( photo.width + MARGIN_H ) * ( i % rowCount ) );
				if ( i && i / rowCount is int ) {
					photoY = height;
				}
				
				photo.y = photoY;
			}
		}
		
		/**
		 * 
		 */
		
		protected function addPhotos():void {
			var length:int = getDisplayLength();
			var photo:PreviewItemWithImage;
			
			for ( var i:int = 0; i < length; i++ ) {
				photo = createPhotoByIndex( i ) as PreviewItemWithImage;
				addPhotoToDisplay( photo );
			}
			
			alignPhotos();
		}
		
		/**
		 * 
		 */
		
		private function updateDisplayList():void {
			var length:int = getDisplayLength();
			var notDisplayedDatas:Vector.<Object> = new Vector.<Object>();
			var photo:PreviewItemWithImage;
			notDisplayedDatas = notDisplayedDatas.concat( datasList );
			
			for ( var i:int = 0; i < numPhotos; i++ ) {
				var data:Object = getPhotoByIndex( i ).getData();
				notDisplayedDatas.splice( notDisplayedDatas.indexOf( data ), 1 );
			}
			
			if ( numPhotos < length ) {
				for ( var j:int = 0; j < length; j++ ) {
					photo = createPhotoByData( notDisplayedDatas[ j ] );
					addPhotoToDisplay( photo );
					if ( numPhotos === length ) break;
				}
			} else {
				while ( numPhotos > length ) {
					photo = getPhotoByIndex( length );
					removePhotoFromDisplay( photo );
				}
			}
			alignPhotos();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onButtonClicked( event:MouseEvent ):void {
			updateDisplayList();
			dispatchEvent( new ProfilePhotosDepartureBarEvent( ProfilePhotosDepartureBarEvent.ON_BAR_DISPLAYING_CHANGED, true ) )
			
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function getDisplayLength():int {
			var result:int;
			if ( button.isOpened ) {
				result = datasList.length;
			} else {
				result = Math.min( datasList.length, rowCount );
			}
			return result;
		}
		
		/**
		 * 
		 * @param	photo
		 * @return
		 */
		
		private function addPhotoToDisplay( photo:PreviewItemWithImage ):PreviewItemWithImage {
			photosContainer.addChild( photo );
			return photo;
		}
		
		/**
		 * 
		 * @param	photo
		 */
		
		private function removePhotoFromDisplay( photo:PreviewItemWithImage ):void {
			photosContainer.removeChild( photo );
		}
		
		/**
		 * 
		 * @param	index
		 */
		
		private function createPhotoByIndex( index:int ):PreviewItemWithImage {
			return createPhotoByData( datasList[ index ] );
		}
		
		/**
		 * 
		 * @param	data
		 * @return
		 */
		
		private function createPhotoByData( data:Object ):PreviewItemWithImage {
			return new photoClass( data ) as PreviewItemWithImage;
		}
		
		/**
		 * 
		 * @param	index
		 * @return
		 */
		
		private function getPhotoByIndex( index:int ):PreviewItemWithImage {
			return photosContainer.getChildAt( index ) as PreviewItemWithImage;
		}
		
	}

}