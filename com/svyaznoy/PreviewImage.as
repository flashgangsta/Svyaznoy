package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewImage extends PreviewItem {
		
		private const BACKGROUND_BOTTOM_MARGIN:int = 2;
		private const TITLE_BOTTOM_MARGIN:int = -1;
		
		private var titleLabel:TextField;
		private var descriptionLabel:TextField;
		private var background:Sprite;
		private var preloader:MovieClip;
		private var loader:ContentLoader = new ContentLoader();
		private var bitmap:Bitmap;
		
		/**
		 * 
		 */
		
		public function PreviewImage() {
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			descriptionLabel = getChildByName( "descriptionLabel_txt" ) as TextField;
			background = getChildByName( "background_mc" ) as Sprite;
			preloader = getChildByName( "prelaoder_mc" ) as MovieClip;
			
			preloader.gotoAndPlay( int( Math.random() * preloader.totalFrames ) );
			
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			descriptionLabel.autoSize = TextFieldAutoSize.LEFT;
			
			title = "";
			description = "";
			
			width = super.width;
			height = super.height;
			
			scaleX = scaleY = 1;
		}
		
		/**
		 * 
		 * @param	stc
		 */
		
		public function loadImage( src:String ):void {
			loader.close();
			loader.load( src );
			if ( !loader.hasEventListener( Event.COMPLETE ) ) {
				loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.addEventListener( Event.COMPLETE, onLoaded );
			}
		}
		
		/**
		 * 
		 */
		
		public function removePreloader():void {
			if ( !preloader ) return;
			preloader.stop();
			removeChild( preloader );
			preloader = null;
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return background.width;
		}
		
		override public function set width( value:Number ):void {
			background.width = value;
			titleLabel.width = descriptionLabel.width = value;
			setPositions();
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return background.height;
		}
		
		override public function set height( value:Number ):void {
			background.height = value;
			setPositions();
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			loader.close();
			if ( bitmap ) {
				bitmap.mask = null;
				bitmap.loaderInfo.loader.unloadAndStop();
				bitmap.bitmapData.dispose();
				removeChild( bitmap );
				bitmap = null;
			}
			loader = null;
			removePreloader();
		}
		
		/**
		 * 
		 */
		
		public function get title():String {
			return titleLabel.text;
		}
		
		public function set title( value:String ):void {
			titleLabel.text = value;
			titleLabel.visible = Boolean( value );
			setPositions();
		}
		
		/**
		 * 
		 */
		
		public function get description():String {
			return descriptionLabel.text;
		}
		
		public function set description( value:String ):void {
			descriptionLabel.text = value;
			descriptionLabel.visible = Boolean( value );
			setPositions();
		}
		
		override public function displayData( data:Object ):void {
			super.displayData( data );
		}
		
		/**
		 * 
		 */
		
		public function removeTextFields():void {
			title = "";
			description = "";
			titleLabel.visible = descriptionLabel.visible = false;
			descriptionLabel.y = titleLabel.y = 0;
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			if ( titleLabel.visible ) {
				titleLabel.y = MappingManager.getBottom( background, this ) + BACKGROUND_BOTTOM_MARGIN;
			} else {
				titleLabel.y = 0;
			}
			
			if ( descriptionLabel.visible && titleLabel.visible ) {
				descriptionLabel.y = MappingManager.getBottom( titleLabel, this ) + TITLE_BOTTOM_MARGIN;
			} else if ( descriptionLabel.visible ) {
				descriptionLabel.y = MappingManager.getBottom( background, this ) + BACKGROUND_BOTTOM_MARGIN;
			}
			
			if ( preloader ) {
				MappingManager.setAlign( preloader, background.getBounds( this ) );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleFillArea( bitmap, background.getBounds( this ) );
			bitmap.mask = background;
			addChildAt( bitmap, 0 );
			removePreloader();
			removeListeners();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			Errors.getInstance().previewImageLoadError( event );
			removePreloader();
			removeListeners();
		}
		/**
		 * 
		 */
		
		private function removeListeners():void {
			loader.removeEventListener( IOErrorEvent.IO_ERROR, Errors.getInstance().previewImageLoadError );
			loader.removeEventListener( Event.COMPLETE, onLoaded );
		}
		
	}

}