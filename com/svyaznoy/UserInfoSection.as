package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class UserInfoSection extends Sprite {
		
		private var label:TextField;
		private var avatar:Bitmap;
		private var avatarMask:Sprite;
		private var loader:ContentLoader = new ContentLoader();
		private var helper:Helper = Helper.getInstance();
		private var button:MovieClip;
		
		/**
		 * 
		 */
		
		public function UserInfoSection() {
			label = getChildByName( "label_txt" ) as TextField;
			avatarMask = getChildByName( "avatarMask_mc" ) as Sprite;
			button = getChildByName( "button_mc" ) as MovieClip;
			label.text = "";
			label.mouseEnabled = label.mouseWheelEnabled = false;
			avatarMask.mouseChildren = avatarMask.mouseEnabled = false;
			ButtonManager.addButton( button, null, onClicked );
		}
		
		/**
		 * 
		 */
		
		public function showUser():void {
			if ( !helper.isDebug ) {
				var params:Object = {
					uids: helper.getUserID(),
					fields: "photo_50,nickname"
				};
				
				Helper.getInstance().vkAPI.api( "users.get", params, onUserData, Errors.getInstance().vkUsersGet );
			} else {
				var data:Object = { };
				data.first_name = "Василий";
				data.last_name = "Щепкин";
				data.nickname = "Immortal";
				data.photo_50 = "http://cs320931.vk.me/v320931535/f98/7VTxSYuOW-M.jpg";
				onUserData( [data] );
			}
			
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onUserData( data:Object ):void {
			data = data[ 0 ];
			label.text = data.first_name + " " + data.nickname + " " + data.last_name;
			loader.load( data.photo_50 );
			loader.addEventListener( Event.COMPLETE, onAvatarLoaded );
			
			if ( label.numLines < 3 ) {
				label.y = MappingManager.getCentricPoint( height, label.textHeight );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAvatarLoaded( event:Event ):void {
			var avatar:Bitmap = loader.getContent() as Bitmap;
			MappingManager.setScaleFillArea( avatar, avatarMask.getBounds( this ) );
			avatar.x = MappingManager.getCentricPoint( avatarMask.width, avatar.width );
			avatar.smoothing = true;
			avatar.mask = avatarMask;
			addChild( avatar );
		}
		
		/**
		 * 
		 */
		
		private function onClicked( target:MovieClip ):void {
			navigateToURL( new URLRequest( "http://vk.com/id" + helper.getUserID() ), "_blank" );
		}
		
	}

}