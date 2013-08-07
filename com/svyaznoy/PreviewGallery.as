package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.svyaznoy.events.PreviewEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class PreviewGallery extends PreviewItemWithImage {
		
		/**
		 * 
		 */
		
		public function PreviewGallery() {
			width = super.width;
			height = super.height;
			ButtonManager.addButton( previewImage.getZoomIcon(), this, onClicked );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		override public function displayData( data:Object ):void {
			super.displayData( data );
			previewImage.loadImage( data.photo_with_path );
			previewImage.getZoomIcon().visible = true;
		}
		
		/**
		 * 
		 */
		
		public function removeTextFields():void {
			previewImage.removeTextFields();
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return previewImage.width;
		}
		
		override public function set width(value:Number):void {
			previewImage.width = value;
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return previewImage.height;
		}
		
		override public function set height(value:Number):void {
			previewImage.height = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClicked( target:MovieClip ):void {
			if ( !data ) return;
			var outputEvent:PreviewEvent = new PreviewEvent( PreviewEvent.ON_PHOTO_REPORT_CALLED );
			outputEvent.previewData = getData();
			Dispatcher.getInstance().dispatchEvent( outputEvent );
		}
		
	}

}