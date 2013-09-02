package com.svyaznoy.gui {
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreloaderAnimation extends MovieClip {
		
		/**
		 * 
		 */
		
		public function PreloaderAnimation() {
			
		}
		
		/**
		 * 
		 */
		
		public function show():void {
			play();
			visible = true;
		}
		
		/**
		 * 
		 */
		
		public function hide():void {
			stop();
			visible = false;
		}
		
	}

}