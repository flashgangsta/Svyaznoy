package com.svyaznoy.gui {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.ui.Label;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Button extends MovieClip {
		
		private var label:Label;
		private var labelMessage:String;
		private var hit:Sprite;
		
		/**
		 * 
		 */
		
		public function Button() {
			for ( var i:int = 0; i < numChildren; i++ ) {
				var child:DisplayObject = getChildAt( i );
				if ( child is Label ) {
					label = child as Label;
				} else if ( child is TextField ) {
					TextField( child ).mouseEnabled = false;
					TextField( child ).mouseWheelEnabled = false;
				}
			}
			
			ButtonManager.addButton( this );
		}
		
		/**
		 * 
		 * @param	message
		 */
		
		public function setLabel( message:String ):void {
			if ( !label ) return;
			label.text = message;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			ButtonManager.removeButton( this );
			if ( label ) {
				label.dispose();
				label = null;
			}
		}
		
	}

}