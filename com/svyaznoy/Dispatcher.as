package com.svyaznoy {
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Dispatcher extends EventDispatcher {
		
		static public var instance:Dispatcher;
		
		public function Dispatcher() {
			if ( !instance ) instance = this;
			else throw new Error( "Dispatcher has singletone, use Dispatcher.getInstance() method" );
		}
		
		static public function getInstance():Dispatcher {
			if ( !instance ) instance = new Dispatcher();
			return instance;
		}
		
	}

}