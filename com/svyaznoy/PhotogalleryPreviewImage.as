package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PhotogalleryPreviewImage extends Sprite {
		
		private var loader:ContentLoader = new ContentLoader();
		private var preloader:MovieClip;
		private var maskObject:DisplayObject;
		private var errors:Errors = Errors.getInstance();
		private var bitmap:Bitmap;
		private var _enabled:Boolean = true;
		private var data:Object;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function PhotogalleryPreviewImage( data:Object ) {
			this.data = data;
			preloader = getChildByName( "preloader_mc" ) as MovieClip;
			maskObject = getChildByName( "maskObject_mc" );
			
			preloader.gotoAndPlay( int( preloader.totalFrames * Math.random() ) );
			preloader.mouseEnabled = preloader.mouseChildren = false;
			
			loader.addEventListener( Event.COMPLETE, onLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.load( data.thumbnail_with_path ? data.thumbnail_with_path : data.photo_thumbnails_with_path );
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return maskObject.width;
		}
		
		override public function set width(value:Number):void {
			maskObject.width = value;
		}
		
		override public function get height():Number {
			return maskObject.height;
		}
		
		override public function set height(value:Number):void {
			maskObject.height = value;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			removeLoader();
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getData():Object {
			return data;
		}
		
		/**
		 * 
		 */
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		
		public function set enabled(value:Boolean):void {
			_enabled = mouseEnabled = mouseChildren = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleFillArea( bitmap, maskObject.getBounds( this ) );
			bitmap.x = MappingManager.getCentricPoint( width, bitmap.width );
			bitmap.mask = maskObject;
			addChild( bitmap );
			removeLoader();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			errors.ioError( event );
			removeLoader();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			errors.securityError( event );
			removeLoader();
		}
		
		/**
		 * 
		 */
		
		private function removeLoader():void {
			if( loader ) {
				loader.removeEventListener( Event.COMPLETE, onLoaded );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				loader.close();
				loader = null;
			}
			
			if( preloader ) {
				preloader.stop();
				removeChild( preloader );
				preloader = null;
			}
		}
		
	}

}