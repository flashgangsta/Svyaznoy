package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class IconListItem extends Sprite {
		
		private var titleLabel:TextField;
		private var signLabel:TextField;
		private var imageArea:Sprite;
		private var prelaoder:MovieClip;
		private var hit:Sprite;
		private var loader:ContentLoader;
		private var bitmap:Bitmap;
		
		/**
		 * 
		 * @param	titleMessage
		 * @param	signMessage
		 * @param	imagePath
		 * @param	vkIDForAvatarLoad
		 */
		
		public function IconListItem( titleMessage:String = null, signMessage:String = null, imagePath:String = null, vkIDForAvatarLoad:int = 0 ) {
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			signLabel = getChildByName( "nameLabel_txt" ) as TextField;
			imageArea = getChildByName( "imageArea_mc" ) as Sprite;
			prelaoder = getChildByName( "preloader_mc" ) as MovieClip;
			hit = getChildByName( "hit_mc" ) as Sprite;
			
			signLabel.autoSize = TextFieldAutoSize.LEFT;
			
			if( titleMessage ) {
				if ( titleMessage.indexOf( " " ) === titleMessage.lastIndexOf( " " ) ) {
					titleMessage = titleMessage.replace( " ", "\n" );
				}
				titleLabel.text = titleMessage.toUpperCase();
				titleLabel.mouseEnabled = titleLabel.mouseWheelEnabled = false;
			} else {
				titleLabel.text = "";
				titleLabel.visible = false;
				prelaoder.y -= imageArea.y;
				signLabel.y -= imageArea.y;
				imageArea.y = 0;
			}
			
			signLabel.text = signMessage.toUpperCase();
			
			hit.height = MappingManager.getBottom( signLabel, this );
			
			if ( vkIDForAvatarLoad ) {
				var helper:Helper = Helper.getInstance();
				if( !helper.isDebug ) {
					helper.vkAPI.api( "users.get", { user_ids: vkIDForAvatarLoad, fields: "photo_100" }, onVkUserData, Errors.getInstance().vkUsersGet );
				} else {
					onVkUserData( [{photo_100:'http://cs320931.vk.me/v320931535/f97/WDynbN3YWYU.jpg'}] );
				}
			} else if ( imagePath ) {
				loadImage( imagePath );
			}
			
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			if( loader ) removeLoader();
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return hit.width;
		}
		
		override public function set width(value:Number):void {
			hit.width = value;
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onVkUserData( data:Array ):void {
			loadImage( data[ 0 ].photo_100 );
		}
		
		/**
		 * 
		 * @param	array
		 */
		
		private function loadImage( path:String ):void {
			loader = new ContentLoader();
			loader.addEventListener( Event.COMPLETE, onAvatarLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError )
			loader.load( path );
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAvatarLoaded( event:Event ):void {
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleOnlyReduce( bitmap, imageArea.width, imageArea.height );
			MappingManager.setAlign( bitmap, imageArea.getBounds( this ) );
			bitmap.mask = imageArea;
			addChild( bitmap );
			removeLoader();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 */
		
		private function removeLoader():void {
			loader.removeEventListener( Event.COMPLETE, onAvatarLoaded );
			loader = null;
			prelaoder.stop();
			prelaoder.visible = false;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			Errors.getInstance().ioError( event );
			removeLoader();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			Errors.getInstance().securityError( event );
			removeLoader();
		}
		
	}

}