package com.svyaznoy {
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewItem extends MovieClip {
		
		///
		protected var data:Object;
		
		/**
		 * 
		 */
		
		public function PreviewItem() {
			
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