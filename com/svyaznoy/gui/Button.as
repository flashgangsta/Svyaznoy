package com.svyaznoy.gui {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.ui.Label;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Button extends MovieClip {
		
		private var label:Label;
		private var labelMessage:String;
		
		/**
		 * 
		 */
		
		public function Button() {
			label = getChildByName( "label_mc" ) as Label;
			if( label ) {
				labelMessage = label.text;
				updateLabel();
			}
			ButtonManager.addButton( this, null, updateLabel, updateLabel, updateLabel );
		}
		
		/**
		 * 
		 */
		
		private function updateLabel( target:MovieClip = null ):void {
			if ( !label ) return;
			label = getChildByName( "label_mc" ) as Label;
			label.text = labelMessage;
			label.mouseEnabled = label.mouseChildren = false;
		}
		
		/**
		 * 
		 * @param	message
		 */
		
		public function setLabel( message:String ):void {
			labelMessage = message;
			updateLabel();
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			ButtonManager.removeButton( this );
			label.dispose();
			label = null;
		}
		
	}

}