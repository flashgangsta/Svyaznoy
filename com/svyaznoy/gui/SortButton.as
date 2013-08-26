package com.svyaznoy.gui {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class SortButton extends Button {
		
		private var icon:MovieClip;
		private var method:uint = Array.NUMERIC;
		
		public function SortButton() {
			icon = getChildByName( "icon_mc" ) as MovieClip;
			icon.mouseChildren = icon.mouseEnabled = false;
			stop();
			setSortMethod();
		}
		
		/**
		 * 
		 * @param	method Array.NUMERIC or Array.DESCENDING
		 */
		
		public function setSortMethod( method:uint = Array.NUMERIC ):uint {
			this.method = method;
			if ( method === Array.DESCENDING ) {
				icon.gotoAndStop( "up" );
			} else {
				icon.gotoAndStop( "down" );
				method = Array.NUMERIC;
			}
			return method;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function changeSortMethod():uint {
			if ( method === Array.NUMERIC ) {
				setSortMethod( Array.DESCENDING );
			} else {
				setSortMethod( Array.NUMERIC );
			}
			return method;
		}
		
	}

}