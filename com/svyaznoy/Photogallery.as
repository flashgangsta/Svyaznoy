package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Photogallery extends Popup {
		
		static const BORDER_MARGIN:int = 10;
		
		private var data:Object;
		private var provider:Provider = Provider.getInstance();
		private var toGalleryButton:Button;
		private var maskObject:DisplayObject;
		private var previews:PhotogalleryPreviews;
		private var preloader:MovieClip;
		private var bitmap:Bitmap;
		private var loader:ContentLoader = new ContentLoader();
		private var errors:Errors = Errors.getInstance();
		private var area:Rectangle;
		private var frame:DisplayObject;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function Photogallery() {
			toGalleryButton = getChildByName( "toGalleryButton_mc" ) as Button;
			maskObject = getChildByName( "maskObject_mc" );
			previews = getChildByName( "previews_mc" ) as PhotogalleryPreviews;
			preloader = getChildByName( "preloader_mc" ) as MovieClip;
			frame = getChildByName( "frame_mc" );
			
			previews.addEventListener( Event.SELECT, onPhotoSelect );
			maskObject.visible = false;
			toGalleryButton.visible = false;
			area = maskObject.getBounds( this );
			
			loader.addEventListener( Event.COMPLETE, onLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function loadByPreviewData( data:Object ):void {
			provider.getGalleryPhotos( data.departure_id, data.id );
			provider.addEventListener( ProviderEvent.ON_GALLERY_PHOTOS, onData );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function showGallery( data:Object ):void {
			trace( "showGallery" );
			this.data = data;
			previews.fill( data );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			if( provider ) {
				if( provider.hasEventListener( ProviderEvent.ON_DEPARTURE ) ) {
					provider.removeEventListener( ProviderEvent.ON_DEPARTURE, onData );
				}
				provider = null;
			}
			
			if ( loader ) {
				loader.close();
				loader = null;
				loader.removeEventListener( Event.COMPLETE, onLoaded );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onData( event:ProviderEvent ):void {
			provider.removeEventListener( ProviderEvent.ON_DEPARTURE, onData );
			showGallery( event.data );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPhotoSelect( event:Event ):void {
			var photoData:Object = previews.getSelectedPhotoData();
			if( bitmap ) {
				Tweener.removeTweens( frame );
				Tweener.removeTweens( bitmap );
				removeChild( bitmap );
				bitmap.bitmapData.dispose();
				bitmap = null;
				loader.close();
			}
			showPreloader();
			loader.load( photoData.photo_with_path );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			hidePreloader();
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleOnlyReduce( bitmap, area.width, area.height );
			MappingManager.setAlign( bitmap, area );
			Tweener.addTween( frame, { width: bitmap.width + BORDER_MARGIN * 2, height: bitmap.height + BORDER_MARGIN * 2, time: .5, transition: "easeInOutCubic", onComplete: onFrameScaled } );
			
		}
		
		private function onFrameScaled():void {
			bitmap.alpha = 0;
			Tweener.addTween( bitmap, { alpha: 1, time: 1, transition: "easeInOutCubic" } );
			addChild( bitmap );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			errors.ioError( event );
			hidePreloader();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			errors.securityError( event );
			hidePreloader();
		}
		
		/**
		 * 
		 */
		
		private function hidePreloader():void {
			if ( preloader.visible ) return;
			preloader.stop();
			preloader.visible = false;
		}
		
		/**
		 * 
		 */
		
		private function showPreloader():void {
			preloader.play();
			preloader.visible = true;
			addChild( preloader );
		}
		
	}

}