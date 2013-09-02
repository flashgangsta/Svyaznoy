﻿package com.svyaznoy {	import com.flashgangsta.managers.ButtonManager;	import com.flashgangsta.managers.MappingManager;	import com.flashgangsta.net.ContentLoader;	import com.svyaznoy.events.NavigationEvent;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.net.navigateToURL;	import flash.net.URLRequest;	import flash.text.TextField;		/**	 * ...	 * @author Sergey Krivtsov (flashgangsta@gmail.com)	 */		public class UserInfoSection extends Sprite {				private var label:TextField;		private var avatar:Bitmap;		private var avatarMask:Sprite;		private var loader:ContentLoader = new ContentLoader();		private var helper:Helper = Helper.getInstance();		private var button:MovieClip;				/**		 * 		 */				public function UserInfoSection() {			label = getChildByName( "label_txt" ) as TextField;			avatarMask = getChildByName( "avatarMask_mc" ) as Sprite;			button = getChildByName( "button_mc" ) as MovieClip;			label.text = "";			label.mouseEnabled = label.mouseWheelEnabled = false;			avatarMask.mouseChildren = avatarMask.mouseEnabled = false;			ButtonManager.addButton( button, null, onClicked );		}				/**		 * 		 */				public function showUser():void {			if ( !helper.isDebug ) {				var handler:Function;				var params:Object = {					uids: helper.getUserID(),					fields: "photo_50",					fields: "photo_200"				};								if ( !helper.isEmployeeMode ) {					params.fields += ",nickname";				}								Helper.getInstance().vkAPI.api( "users.get", params, onVKUserData, Errors.getInstance().vkUsersGet );			} else {				setNameLabel( "Щепкин Василий Immortal" );				loadAvatar( "http://cs320931.vk.me/v320931535/f98/7VTxSYuOW-M.jpg" );			}					}				/**		 * 		 * @param	data		 */				private function onVKUserData( data:Object ):void {			var userData:UserData = helper.getUserData();						userData.setAvatars( data.photo_50, data.photo_100, data.photo_200 );						data = data[ 0 ];						loadAvatar( data.photo_50 );						if ( !helper.isEmployeeMode ) {				userData.setFullName( data.first_name, data.last_name );			}						setNameLabel( userData.fullName );		}				/**		 * 		 * @param	message		 */				private function setNameLabel( message:String ):void {			label.text = message;			if ( label.numLines < 3 ) {				label.y = MappingManager.getCentricPoint( height, label.textHeight );			}		}				/**		 * 		 * @param	src		 */				private function loadAvatar( src:String ):void {			loader.load( src );			loader.addEventListener( Event.COMPLETE, onAvatarLoaded );		}				/**		 * 		 * @param	event		 */				private function onAvatarLoaded( event:Event ):void {			var avatar:Bitmap = loader.getContent() as Bitmap;			MappingManager.setScaleFillArea( avatar, avatarMask.getBounds( this ) );			avatar.x = MappingManager.getCentricPoint( avatarMask.width, avatar.width );			avatar.smoothing = true;			avatar.mask = avatarMask;			addChild( avatar );		}				/**		 * 		 */				private function onClicked( target:MovieClip ):void {			if ( helper.isEmployeeMode ) {				Dispatcher.getInstance().dispatchEvent( new NavigationEvent( NavigationEvent.NAVIGATE_TO_PROFILE ) );			} else {				navigateToURL( new URLRequest( "http://vk.com/id" + helper.getUserID() ), "_blank" );			}		}			}}