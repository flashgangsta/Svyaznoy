package com.svyaznoy {
	import com.svyaznoy.events.PreviewEvent;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewDepartureImage extends PreviewItemWithImage {
		
		public function PreviewDepartureImage( data:Object ) {
			super.data = data;
			previewImage.loadImage( data.thumbnail_medium_with_path );
			previewImage.title = data.anonce;
			updateAnonce();
			buttonMode = true;
			
			addEventListener( MouseEvent.CLICK, onMouseClicked );
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return super.height;
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			trace( "PreviewDepartureImage.dispose()" );
			super.dispose();
			removeEventListener( MouseEvent.CLICK, onMouseClicked );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getBitmap():Bitmap {
			return previewImage.getBitmap();
		}
		
		/**
		 * Обновляет подпись под фото
		 * @param	anonce текст подписи, если не передать, текст будет взят из data.anonce объекта
		 */
		
		public function updateAnonce( anonce:String = null ):void {
			previewImage.title = anonce ? anonce : data.anonce;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseClicked( event:MouseEvent ):void {
			dispatchEvent( new PreviewEvent( PreviewEvent.ON_PROFILE_PHOTO_EDIT_CALLED, true ) );
		}
		
	}

}