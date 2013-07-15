package com.flashgangsta.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Queue {
		
		public function Queue() {
			
		}
		
		private var methods:Array = [];
		private var args:Array = [];
		
		internal function add( method:Function, ...args ):void {
			methods.push( method );
			this.args.push( args );
		}
		
		internal function applyAll():void {
			while ( methods.length ) {
				var method:Function = methods.shift() as Function;
				method.apply( null, args.shift() as Array );
			}
		}
		
	}

}