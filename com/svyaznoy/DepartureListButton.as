package com.svyaznoy {
	import com.flashgangsta.display.MovieClipExtended;
	import com.flashgangsta.ui.Label;
	import com.flashgangsta.utils.getChildByType;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class DepartureListButton extends MovieClipExtended {
		
		private var _id:String;
		private var _label:Label;
		
		/**
		 * 
		 */
		
		public function DepartureListButton() {
			super();
			_label = getChildByType( this, Label ) as Label;
		}
		
		/**
		 * 
		 */
		
		public function get id():String {
			return _id;
		}
		
		public function set id( value:String ):void {
			_id = value;
		}
		
		/**
		 * 
		 */
		
		public function set label( value:String ):void {
			_label.text = value;
		}
		
		public function get label():String {
			return _label.text;
		}
		
	}

}