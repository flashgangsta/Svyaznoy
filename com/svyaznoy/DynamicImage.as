package com.svyaznoy {
	import com.anttikupila.utils.JPGSizeExtractor;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DynamicImage extends DynamicItem {
		
		///
		private var loader:ContentLoader;
		///
		private var bitmap:Bitmap;
		///
		private var background:Sprite;
		///
		private var preloader:MiniPreloader;
		///
		private var sizeExtractor:JPGSizeExtractor;
		
		
		/**
		 * 
		 * @param	node
		 */
		
		public function DynamicImage( src:String = null ) {
			background = getChildByName( "background_mc" ) as Sprite;
			background.visible = false;
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			if ( src ) {
				load( src );
			}
		}
		
		/**
		 * 
		 * @param	stc
		 */
		
		public function load( src:String ):void {
			//src = "http://img8.joyreactor.cc/pics/post/full/%D0%BD%D0%B5%D0%B2%D0%B5%D0%B4%D0%BE%D0%BC%D0%B0%D1%8F-%D0%B5%D0%B1%D0%B0%D0%BD%D0%B0%D1%8F-%D1%85%D1%83%D0%B9%D0%BD%D1%8F-art-%D0%B4%D0%B5%D0%BC%D0%BE%D0%BD-%D0%BF%D0%B5%D1%81%D0%BE%D1%87%D0%BD%D0%B8%D1%86%D0%B0-222938.jpeg";
			clear();
			
			loader = new ContentLoader();
			
			background.visible = false;
			
			sizeExtractor = new JPGSizeExtractor();
			sizeExtractor.extractSize( src );
			sizeExtractor.addEventListener( JPGSizeExtractor.PARSE_COMPLETE, onSizeExtracted );
			sizeExtractor.addEventListener( JPGSizeExtractor.PARSE_FAILED, onSizeExtractionFailed );
			sizeExtractor.addEventListener( IOErrorEvent.IO_ERROR, onImageLoadError );
			sizeExtractor.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			
			loader.addEventListener( Event.COMPLETE, onLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onImageLoadError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.load( src );
		}
		
		/**
		 * 
		 */
		
		public function clear():void {
			removeBitmap();
			removeLoader();
			removeSizeExtractor();
			removePreloader();
			background.visible = false;
		}
		
		public function getBitmap():Bitmap {
			return bitmap;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onImageLoadError( event:IOErrorEvent ):void {
			Errors.getInstance().dynamicImageLoadError( event );
			setExistsImage();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			Errors.getInstance().dynamicImageSecurityError( event );
			setExistsImage();
		}
		
		private function setExistsImage():void {
			background.width = background.height = 0;
			scaleX = scaleY = 1;
			clear();
			dispatchChange();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			if ( !sizeExtractor && !bitmap && loader ) {
				addPrelaoder();
			}
		}
		
		/**
		 * 
		 */
		
		private function addPrelaoder():void {
			preloader = new MiniPreloader();
			MappingManager.setAlign( preloader, background.getBounds( this ) );
			addChild( preloader );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeExtracted( event:Event ):void {
			if( !bitmap ) {
				scaleX = scaleY = 1;
				background.width = sizeExtractor.width;
				background.height = sizeExtractor.height;
				background.visible = true;
				removeSizeExtractor();
				dispatchChange();
				if ( stage ) addPrelaoder();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			addChild( bitmap );
			if ( preloader ) addChild( preloader );
			removeLoader();
			
			if ( sizeExtractor ) {
				removeSizeExtractor();
				scaleX = scaleY = 1;
			}
			
			removePreloader();
			
			if ( !background.visible ) {
				dispatchChange();
			}
		}
		
		/**
		 * 
		 */
		
		private function removePreloader():void {
			if ( preloader ) {
				preloader.stop();
				removeChild( preloader );
				preloader = null;
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeExtractionFailed( event:Event ):void {
			removeSizeExtractor();
		}
		
		/**
		 * 
		 */
		
		private function removeSizeExtractor():void {
			if ( !sizeExtractor ) return;
			sizeExtractor.removeEventListener( JPGSizeExtractor.PARSE_COMPLETE, onSizeExtracted );
			sizeExtractor.removeEventListener( JPGSizeExtractor.PARSE_COMPLETE, onSizeExtracted );
			sizeExtractor.removeEventListener( IOErrorEvent.IO_ERROR, onImageLoadError );
			/*try {
				sizeExtractor.close();
			} catch ( error:Error ) {
				
			}*/
			sizeExtractor = null;
		}
		
		/**
		 * 
		 */
		
		private function removeLoader():void {
			if ( !loader ) return;
			loader.close();
			loader.removeEventListener( Event.COMPLETE, onLoaded );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onImageLoadError );
			loader = null;
		}
		
		/**
		 * 
		 */
		
		private function removeBitmap():void {
			if ( !bitmap ) return;
			bitmap.bitmapData.dispose();
			removeChild( bitmap );
			bitmap = null;
		}
	}

}