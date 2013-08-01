package com.svyaznoy {
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Map extends MovieClip {
		
		/**
		 * 
		 */
		
		public function Map() {
			stop();
			visible = false;
		}
		
		/**
		 * 
		 */
		
		public function show():void {
			visible = true;
		}
		
		/**
		 * 
		 */
		
		public function hide():void {
			visible = false;
		}
		
	}

}