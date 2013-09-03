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
			previewImage.loadImage( data.photo_with_path );
			previewImage.title = data.anonce;
			
			buttonMode = true;
			
			addEventListener( MouseEvent.CLICK, onMouseClicked );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			removeEventListener( MouseEvent.CLICK, onMouseClicked );
		}
		
		public function getBitmap():Bitmap {
			return previewImage.getBitmap();
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