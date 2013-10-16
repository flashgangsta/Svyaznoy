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
		
		static public const PHOTO_50:String = "photo_50";
		static public const PHOTO_100:String = "photo_100";
		static public const PHOTO_200:String = "photo_200_orig";
		static public const SCALE_MODE_FILL_AREA:String = "fillArea";
		static public const SCALE_MODE_ONLY_REDUCE:String = "onlyReduce";
		
		private var loader:ContentLoader;
		private var bitmap:Bitmap;
		private var avatarArea:Sprite;
		private var preloader:PreloaderAnimation = new PreloaderAnimation();
		private var helper:Helper = Helper.getInstance();
		private var size:String;
		private var mode:String;
		
		/**
		 * 
		 */
		
		public function AvatarContainer() {
			avatarArea = getChildAt( 0 ) as Sprite;
			
			avatarArea.width = width;
			avatarArea.height = height;
			
			scaleX = scaleY = 1;
			
			if ( preloader.width > width - 20 ) {
				preloader.width = Math.round( width - 20 );
				preloader.scaleY = preloader.scaleX;
			}
			
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
			this.size = size;
			if( !helper.isDebug ) {
				helper.vkAPI.api( "users.get", { user_ids: vkID, fields: size }, onVkUserData, Errors.getInstance().vkUsersGet );
			} else {
				onVkUserData( [{photo_50:'http://cs402330.vk.me/v402330401/9760/pV6sZ5wRGxE.jpg',photo_100:'http://cs320931.vk.me/v320931535/f97/WDynbN3YWYU.jpg',photo_200_orig:'http://cs402330.vk.me/v402330401/9760/pV6sZ5wRGxE.jpg'}] );
			}
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			removeLoader();
			removeBitmap();
		}
		
		public function setScaleMode( mode:String = SCALE_MODE_FILL_AREA ):void {
			this.mode = mode;
			
		}
		
		public function getBitmap():Bitmap {
			return bitmap
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
		
		private function onVkUserData( data:Array ):void {
			loadByPath( data[ 0 ][ size ] );
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
			
			if( mode === SCALE_MODE_FILL_AREA ) {
				MappingManager.setScaleFillArea( bitmap, avatarArea.getBounds( this ) );
				bitmap.x = MappingManager.getCentricPoint( avatarArea.width, bitmap.width );
			} else {
				MappingManager.setScaleOnlyReduce( bitmap, avatarArea.width, avatarArea.height );
				MappingManager.setAlign( bitmap, avatarArea.getBounds( this ) );
			}
			
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