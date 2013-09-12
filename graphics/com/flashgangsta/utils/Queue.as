package com.flashgangsta.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version	0.01
	 */
	public class Queue {
		
		public function Queue() {
			
		}
		
		private var methods:Array = [];
		private var args:Array = [];
		
		public function add( method:Function, ...args ):void {
			methods.push( method );
			this.args.push( args );
		}
		
		public function applyAll():void {
			while ( methods.length ) {
				var method:Function = methods.shift() as Function;
				method.apply( null, args.shift() as Array );
			}
		}
		
	}

}