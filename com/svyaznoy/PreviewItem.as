package com.svyaznoy {
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewItem extends MovieClip {
		
		///
		protected var data:Object;
		protected var isLinkToReport:Boolean = false;
		
		/**
		 * 
		 */
		
		public function PreviewItem() {
			scaleX = scaleY = 1;
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function displayData( data:Object ):void {
			this.data = data;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getData():Object {
			return data;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			data = null;
		}
		
	}

}