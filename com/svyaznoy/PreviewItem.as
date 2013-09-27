package com.svyaznoy {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewItem extends MovieClip {
		
		///
		private var _data:Object;
		protected var isLinkToReport:Boolean = false;
		protected var hit:DisplayObject;
		
		/**
		 * 
		 */
		
		public function PreviewItem() {
			//scaleX = scaleY = 1;
			hit = getChildByName( "hit_mc" );
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
		
		override public function set visible(value:Boolean):void {
			if ( value && !data ) {
				return;
			}
			super.visible = value;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
			if ( !visible && data ) visible = true;
		}
		
		/**
		 * 
		 */
		
		protected function updateHitSize():void {
			if ( !hit ) return;
			hit.width = hit.height = 0;
			hit.width = width;
			hit.height = height;
		}
		
		
	}

}