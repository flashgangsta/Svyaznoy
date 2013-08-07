package com.svyaznoy {
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	import vk.APIConnection;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Helper {
		
		private static var instance:Helper;
		
		private var _loaderContext:LoaderContext = null; 
		private var _isDebug:Boolean = true;
		private var _vkAPI:APIConnection;
		private var _flashvars:Object;
		private var _userData:UserData;
		private var _newsDatasByID:Dictionary = new Dictionary();
		private var _screenRectangle:Rectangle;
		
		private var _isEmployeeMode:Boolean = false;
		
		/**
		 * 
		 */
		
		public function Helper() {
			if ( !instance ) {
				instance = this;
			} else {
				throw new Error( "Helper has singletone, use Helper.getInstance()" );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public static function getInstance():Helper {
			if ( !instance ) instance = new Helper();
			return instance;
		}
		
		/**
		 * 
		 * @param	parameters
		 */
		
		public function setFlashvars( parameters:Object ):void {
			_flashvars = parameters;
		}
		
		/**
		 * 
		 */
		
		public function createVkAPI():void {
			_vkAPI = new APIConnection( _flashvars );
		}
		
		/**
		 * 
		 */
		
		public function get loaderContext():LoaderContext {
			return _loaderContext;
		}
		
		/**
		 * 
		 */
		
		public function get isDebug():Boolean {
			return _isDebug;
		}
		
		public function set isDebug( value:Boolean ):void {
			_isDebug = value;
			_loaderContext = isDebug ? null : new LoaderContext( true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain );
		}
		
		/**
		 * 
		 */
		
		public function get vkAPI():APIConnection {
			return _vkAPI;
		}
		
		public function get isEmployeeMode():Boolean {
			return _isEmployeeMode;
		}
		
		public function set isEmployeeMode(value:Boolean):void {
			_isEmployeeMode = value;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getUserID():int {
			return isDebug ? 7010535 : _flashvars.viewer_id;
		}
		
		/**
		 * 
		 */
		
		public function getAuthKey():String {
			return isDebug ? "589d9dd4555389ebf5d65b87836d44e2" : _flashvars.auth_key;
		}
		
		/**
		 * 
		 * @param	object
		 */
		
		public function setUserData( data:Object ):void {
			_userData = new UserData( data );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getUserData():UserData {
			return _userData;
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function getNewsDataByID( id:int ):Object {
			return _newsDatasByID[ id ];
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function setNewsData( data:Object ):void {
			_newsDatasByID[ data.id ] = data;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		
		public function setScreenRectangle( x:Number, y:Number, width:Number, height:Number ):void {
			_screenRectangle = new Rectangle( x, y, width, height );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getScreenRectangle():Rectangle {
			return _screenRectangle;
		}
		
	}

}