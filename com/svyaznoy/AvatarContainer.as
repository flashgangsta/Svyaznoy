package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.gui.PreloaderAnimation;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AvatarContainer extends Sprite {
		
		static public const PHOTO_50:String = "photo50";
		static public const PHOTO_100:String = "photo100";
		static public const PHOTO_200:String = "photo200";
		
		private var loader:ContentLoader;
		private var bitmap:Bitmap;
		private var avatarArea:Sprite;
		private var preloader:PreloaderAnimation = new PreloaderAnimation();
		
		/**
		 * 
		 */
		
		public function AvatarContainer() {
			avatarArea = getChildAt( 0 ) as Sprite;
			
			avatarArea.width = width;
			avatarArea.height = height;
			
			scaleX = scaleY = 1;
			
			MappingManager.setAlign( preloader, this.getBounds( this ) );
			addChild( preloader );
			preloader.hide();
		}
		
		/**
		 * 
		 * @param	path
		 */
		
		public function loadByPath( path:String ):void {
			removeLoader();
			removeBitmap();
			loader = new ContentLoader();
			loader.addEventListener( Event.COMPLETE, onLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.load( path );
			preloader.show();
		}
		
		/**
		 * 
		 * @param	vkID
		 * @param	size
		 */
		
		public function loadByVkID( vkID:String, size:String = PHOTO_50 ):void {
			
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			removeLoader();
			removeBitmap();
		}
		
		/**
		 * 
		 */
		
		private function removeBitmap():void {
			if ( !bitmap ) return;
			bitmap.mask = null;
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
		
		/**
		 * 
		 */
		
		private function removeLoader():void {
			if ( !loader ) return;
			loader.close();
			loader.removeEventListener( Event.COMPLETE, onLoaded );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleFillArea( bitmap, avatarArea.getBounds( this ) );
			bitmap.x = MappingManager.getCentricPoint( avatarArea.width, bitmap.width );
			//MappingManager.setScaleOnlyReduce( bitmap, avatarArea.width, avatarArea.height );
			//MappingManager.setAlign( bitmap, avatarArea.getBounds( this ) );
			bitmap.mask = avatarArea;
			addChild( bitmap );
			preloader.hide();
			removeLoader();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			removeLoader();
			preloader.hide();
			Errors.getInstance().ioError( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			removeLoader();
			preloader.hide();
			Errors.getInstance().securityError( event );
		}
	}

}