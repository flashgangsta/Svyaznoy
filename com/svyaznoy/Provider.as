package com.svyaznoy {
	import com.svyaznoy.events.ProviderErrorEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Provider extends EventDispatcher {
		
		private const SERVER_ADRESS:String = "http://es.svyaznoy.ru/";
		private const API_DIRECTORY:String = "api/v1/";
		private const API_ADRESS:String = SERVER_ADRESS + API_DIRECTORY;
		
		private const METHOD_LOGIN:String = 									"login";
		private const METHOD_SET_EMPLOYEE:String = 		METHOD_LOGIN + 			"/employee";
		private const METHOD_CONFIRM_EMPLOYEE:String = 	METHOD_SET_EMPLOYEE + 	"/confirm";
		private const METHOD_DISABLE_INTRO:String = 							"me/disable-intro";
		private const METHOD_GET_INTRO:String =		 							"content/intro";
		private const METHOD_GET_NEWS:String =		 							"content/news";
		private const METHOD_GET_PAGE:String =		 							"content/pages";
		private const METHOD_GET_DEPARTURES:String =		 					"departures";
		
		
		static public var instance:Provider;
		
		private var errors:Errors = Errors.getInstance();
		private var helper:Helper = Helper.getInstance();
		
		/**
		 * 
		 */
		
		public function Provider() {
			if ( !instance ) instance = this;
			else throw new Error( "Provider has singletone" );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public static function getInstance():Provider {
			if ( !instance ) instance = new Provider();
			return instance;
		}
		
		/**
		 * LOGIN
		 */
		
		public function login():void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_LOGIN );
			request.method = URLRequestMethod.GET;
			loader.completeHandler = onLoginResponse;
			loader.errorHandler = errors.loginError;
			startLoad( loader, request );
			
		}
		
		/**
		 * 
		 */
		
		private function onLoginResponse( data:Object ):void {
			helper.setUserData( data );
			dispatchComplete( ProviderEvent.ON_LOGGED_IN, data );
		}
		
		/**
		 * 
		 * @param	code
		 * @param	email
		 */
		
		public function setEmployee( code:String, email:String ):void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_SET_EMPLOYEE );
			var params:URLVariables = new URLVariables();
			
			params.barcode = code;
			params.email = email;
			
			request.method = URLRequestMethod.POST;
			request.data = params;
			
			loader.completeHandler = onSetEmployeeResponse;
			loader.errorHandler = onSetEmployeeError;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onSetEmployeeError( data:Object ):void {
			errors.setEmployeeError( data );
			if ( data.code === 404 ) {
				dispatchEvent( new ProviderErrorEvent( ProviderErrorEvent.ON_EMPLOYEE_SET_ERROR ) );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSetEmployeeResponse( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_EMPLOYEE_SET, data );
		}
		
		/**
		 * 
		 * @param	code
		 */
		
		public function confirmEmployee( code:String ):void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_CONFIRM_EMPLOYEE );
			var params:URLVariables = new URLVariables();
			
			params.code = code;
			
			request.method = URLRequestMethod.POST;
			request.data = params;
			
			loader.completeHandler = onEmployeeConfirmed;
			loader.errorHandler = onEmployeeConfirmationError;
			
			startLoad( loader, request );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onEmployeeConfirmationError( data:Object ):void {
			errors.setEmployeeConfirmationError( data );
			if ( data.code === 404 ) {
				dispatchEvent( new ProviderErrorEvent( ProviderErrorEvent.ON_EMPLOYEE_CONFIRMATION_ERROR ) );
			}
		}
		
		/**
		 * 
		 */
		
		private function onEmployeeConfirmed( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_EMPLOYEE_CONFIRMED, data );
		}
		
		/**
		 * 
		 */
		
		public function dispableIntro():void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_DISABLE_INTRO );
			
			request.method = URLRequestMethod.GET;
			loader.errorHandler = errors.onDisableIntroError;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 */
		
		public function getIntro():void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_GET_INTRO );
			
			request.method = URLRequestMethod.GET;
			loader.completeHandler = onIntroData;
			loader.errorHandler = errors.onIntroDataError;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 */
		
		private function onIntroData( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_INTRO_DATA, data );
		}
		
		/**
		 * 
		 * @param	limit
		 * @param	offset
		 */
		
		public function getNewsList( limit:int = 10, offset:int = 0 ):void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_GET_NEWS );
			
			request.method = URLRequestMethod.GET;
			loader.completeHandler = onNewsList;
			loader.errorHandler = errors.onNewsListError;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 */
		
		private function onNewsList( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_NEWS_LIST, data );
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function getNewsDetail( id:int ):void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_GET_NEWS + "/" + id );
			
			request.method = URLRequestMethod.GET;
			loader.completeHandler = onNewsDetail;
			loader.errorHandler = errors.onNewsDetailError;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onNewsDetail( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_NEWS_DETAIL, data );
		}
		
		/**
		 * 
		 */
		
		public function getLegend():void {
			getPageByName( "legenda", onLegend, errors.getLegendError );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onLegend( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_LEGEND, data );
		}
		
		/**
		 * 
		 */
		
		public function getAbout():void {
			getPageByName( "about", onAbout, errors.getAboutError );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onAbout( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_ABOUT, data );
		}
		
		/**
		 * 
		 */
		
		public function getThermsOfMotivation():void {
			getPageByName( "legenda-terms", onThermsOfMotivation, errors.getThermsOfMotivationError );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onThermsOfMotivation( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_THERMS_OF_MOTIVATION, data );
		}
		
		/**
		 * 
		 */
		
		public function getDepartures( year:String, fields:String = "galleries.photos,videos" ):void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_GET_DEPARTURES );
			var params:URLVariables = new URLVariables();
			
			params[ "load[]" ] = fields.split( "," ).join( "&load[]=" );
			params[ "filter[]" ] = "year:" + year;
			
			request.method = URLRequestMethod.GET;
			request.data = params;
			
			loader.errorHandler = errors.onDeparturesError;
			loader.completeHandler = onDepartures;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		private function onDepartures( data:Object ):void {
			dispatchComplete( ProviderEvent.ON_DEPARTURES, data );
		}
		
		/**
		 * 
		 * @param	name
		 */
		
		private function getPageByName( name:String, completeHandler:Function, errorHandler:Function ):void {
			var loader:ProviderURLLoader = new ProviderURLLoader();
			var request:URLRequest = new URLRequest( API_ADRESS + METHOD_GET_PAGE + "/" + name );
			request.method = URLRequestMethod.GET;
			loader.errorHandler = errorHandler;
			loader.completeHandler = completeHandler;
			startLoad( loader, request );
		}
		
		/**
		 * 
		 * @param	loader
		 * @param	request
		 */
		
		private function startLoad( loader:ProviderURLLoader, request:URLRequest ):void {
			loader.load( request );
			dispatchEvent( new ProviderEvent( ProviderEvent.ON_LOAD_START ) );
		}
		
		/**
		 * 
		 * @param	eventType
		 * @param	data
		 */
		
		private function dispatchComplete( eventType:String, data ):void {
			var event:ProviderEvent = new ProviderEvent( eventType );
			event.data = data;
			dispatchEvent( event );
		}
	}

}