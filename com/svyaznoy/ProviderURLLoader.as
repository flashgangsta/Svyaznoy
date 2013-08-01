package com.svyaznoy {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProviderURLLoader extends URLLoader {
		
		private var _completeHandler:Function;
		private var _errorHandler:Function;
		private var isOpened:Boolean = false;
		private var showTraces:Boolean = true;
		
		/**
		 * 
		 */
		
		public function ProviderURLLoader() {
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		public function dispose():void {
			if ( isOpened ) {
				isOpened = false;
				close();
			}
			
			if ( hasEventListener( IOErrorEvent.IO_ERROR ) ) {
				removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			}
			
			if ( hasEventListener( HTTPStatusEvent.HTTP_STATUS ) ) {
				removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			}
			
			if ( hasEventListener( Event.COMPLETE ) ) {
				removeEventListener( Event.COMPLETE, onComplete );
			}
		}
		
		/**
		 * 
		 * @param	request
		 */
		
		override public function load( request:URLRequest ):void {
			if ( isOpened ) close();
			isOpened = true;
			addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			addEventListener( Event.COMPLETE, onComplete );
			
			var helper:Helper = Helper.getInstance();
			
			if ( request.method === URLRequestMethod.GET && request.data ) {
				request.data.auth_key = helper.getAuthKey();
				request.data.user_id = helper.getUserID();
			} else {
				request.url += "?auth_key=" + helper.getAuthKey() + "&user_id=" + helper.getUserID();
			}
			
			if( showTraces ) {
				trace( "------------------" );
				trace( request.method.toUpperCase() + " " + request.url + "\n" );
				for ( var key:String in request.data ) {
					trace( "	" + key + " = " + request.data[ key ] );
				}
				trace( "-----------------/" );
			}
			
			super.load( request );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			isOpened = false;
			Errors.getInstance().ioError( event.text );
			dispose();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onHTTPStatus( event:HTTPStatusEvent ):void {
			var status:int = event.status;
			if( showTraces ) trace( "HTTP STATUS:", status );
			if ( status === 500 || status === 401 ) {
				Errors.getInstance().internalServerError( status );
				isOpened = false;
			}
		}
		
		/**
		 * 
		 */
		
		public function set completeHandler( value:Function ):void {
			_completeHandler = value;
		}
		
		/**
		 * 
		 */
		
		public function set errorHandler( value:Function ):void {
			_errorHandler = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onComplete( event:Event ):void {
			var data:Object = JSON.parse( event.currentTarget.data );
			
			if ( data.error && _errorHandler !== null ) {
				data.response.code = int( data.code );
				_errorHandler( data.response );
			} else if( !data.error && _completeHandler !== null ) {
				_completeHandler( data.response.data );
			}
			
			if( showTraces ) {
				trace( JSON.stringify( data ) );
				trace( "-----------------//" );
			}
			
			dispose();
		}
		
	}

}