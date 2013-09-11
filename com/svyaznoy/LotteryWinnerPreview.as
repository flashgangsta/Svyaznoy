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
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class LotteryWinnerPreview extends Sprite {
		private var nameLabel:TextField;
		private var preloader:MovieClip;
		private var avatarArea:Sprite;
		private var data:Object;
		private var bitmap:Bitmap;
		private var contentLoader:ContentLoader = new ContentLoader();
		private var errors:Errors = Errors.getInstance();
		
		/**
		 * 
		 */
		
		public function LotteryWinnerPreview() {
			nameLabel = getChildByName( "nameLabel_txt" ) as TextField;
			preloader = getChildByName( "preloader_mc" ) as MovieClip;
			avatarArea = getChildByName( "avatarArea_mc" ) as Sprite;
			
			nameLabel.text = "";
			avatarArea.visible = false;
		}
		
		/**
		 * 
		 */
		
		public function showWinner( winnerData:Object ):void {
			data = winnerData;
			hideWinner();
			showPreloader();
			contentLoader = new ContentLoader();
			loadVkUserData( data.user.username );
			nameLabel.text = data.last_name + " " + data.first_name;
		}
		
		/**
		 * 
		 */
		
		private function hideWinner():void {
			contentLoader.close();
			removeListeners();
			
			if( bitmap ) {
				bitmap.bitmapData.dispose();
				removeChild( bitmap );
				bitmap = null;
			}
			
			nameLabel.text = "";
		}
		
		/**
		 * 
		 * @param	vkID
		 */
		
		private function loadVkUserData( vkID:int ):void {
			var params:Object = {};
			params.user_ids = vkID;
			params.fields = "photo_200_orig";
			if ( Helper.getInstance().isDebug ) {
				var data:Object = {
					uid:7010535,
					first_name: "Иван",
					last_name: "Победоносец",
					photo_200_orig: "http:\/\/cs320931.vk.me\/v320931535\/f94\/_f8sr7_XxLs.jpg"
				}
				onVkUserData( [data] );
			} else {
				Helper.getInstance().vkAPI.api( "users.get", params, onVkUserData, errors.vkUsersGet );
			}
		}
		
		/**
		 * 
		 */
		
		private function onVkUserData( datas:Array ):void {
			var data:Object = datas[ 0 ];
			contentLoader.addEventListener( Event.COMPLETE, onAvatarLoaded );
			contentLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			contentLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			contentLoader.load( data.photo_200_orig );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			errors.securityError( event );
			removeListeners();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			errors.ioError( event );
			removeListeners();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAvatarLoaded( event:Event ):void {
			removeListeners();
			bitmap = contentLoader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleFillArea( bitmap, avatarArea.getBounds( this ) );
			bitmap.y = avatarArea.y;
			bitmap.x = avatarArea.x + MappingManager.getCentricPoint( avatarArea.width, bitmap.width );
			addChild( bitmap );
			bitmap.mask = avatarArea;
			hidePreloader();
		}
		
		/**
		 * 
		 */
		
		private function showPreloader():void {
			preloader.play();
			preloader.visible = true;
		}
		
		/**
		 * 
		 */
		
		private function hidePreloader():void {
			preloader.stop();
			preloader.visible = false;
		}
		
		/**
		 * 
		 */
		
		private function removeListeners():void {
			contentLoader.removeEventListener( Event.COMPLETE, onAvatarLoaded );
			contentLoader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			contentLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}
		
		
		
	}

}