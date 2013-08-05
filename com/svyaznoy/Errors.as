package com.svyaznoy {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Errors {
		
		private static var instance:Errors;
		
		/**
		 * 
		 */
		
		public function Errors() {
			if ( !instance ) {
				instance = this;
			} else {
				throw new Error( "Errors has singletone, use Helper.getInstance()" );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public static function getInstance():Errors {
			if ( !instance ) instance = new Errors();
			return instance;
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function vkUsersGet( data:Object ):void {
			traceError( "vkUsersGet", data );
		}
		
		/**
		 * 
		 * @param	text
		 */
		
		public function ioError(text:String):void {
			trace( "# IOError:", text );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		public function dynamicImageSecurityError( event:SecurityErrorEvent ):void {
			traceError( "dynamicImageSecurityError", event );
		}
		
		/**
		 * 
		 */
		
		public function internalServerError( code:int ):void {
			trace( "#", code, "Internal server error" );
		}
		
		/**
		 * 
		 */
		
		public function loginError( data:Object ):void {
			traceError( "loginError", data );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function setEmployeeError( data:Object ):void {
			traceError( "setEmployeeError", data );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function setEmployeeConfirmationError(data:Object):void {
			traceError( "setEmployeeConfirmationError", data );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function onIntroDataError( data:Object ):void {
			traceError( "onIntroDataError", data );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function onDisableIntroError( data:Object ):void {
			traceError( "onDisableIntroError", data );
		}
		
		/**
		 * 
		 */
		
		public function onNewsListError( data:Object ):void {
			traceError( "onDisableIntroError", data );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		public function dynamicImageLoadError( event:IOErrorEvent ):void {
			traceError( "dynamicImageLoadError", event );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function onNewsDetailError( data:Object ):void {
			traceError( "onNewsDetailError", data );
		}
		
		/**
		 * 
		 */
		
		public function getLegendError( data:Object ):void {
			traceError( "getLegendError", data );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function getAboutError( data:Object ):void {
			traceError( "getAboutError", data );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function getThermsOfMotivationError( data:Object ):void {
			traceError( "getThermsOfMotivationError", data );
		}
		
		
		
		public function onDeparturesError( data:Object ):void {
			traceError( "onDeparturesError", data );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		public function previewImageLoadError( event:Event ):void {
			traceError( "previewImageLoadError", event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		public function videoInfoLoadError( event:IOErrorEvent ):void {
			traceError( "videoInfoLoadError", event );
		}
		
		
		/**
		 * 
		 * @param	methodName
		 * @param	data
		 */
		
		private function traceError( methodName:String, data:Object ):void {
			trace( "#", methodName + "\n" + JSON.stringify( data ) );
		}
		
	}

}