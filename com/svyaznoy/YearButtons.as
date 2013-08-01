package com.svyaznoy {
	import com.flashgangsta.managers.ButtonManager;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class YearButtons extends Sprite {
		
		private const MARGIN:int = 5;
		private var buttonClass:Class;
		private var selectedButton:Button;
		
		/**
		 * 
		 */
		
		public function YearButtons() {
			buttonClass =  Object( getChildByName( "button_mc" ) ).constructor as Class;
			clear();
		}
		
		/**
		 * 
		 * @param	from
		 * @param	to
		 */
		
		public function setButtons( from:int, to:int ):void {
			clear();
			var length:int = to - from + 1;
			var button:Button;
			var buttons:Array = [];
			var year:String;
			
			for ( var i:int = 0; i < length; i++ ) {
				year = String( from + i );
				button = new buttonClass();
				button.name = year;
				button.setLabel( year );
				button.x = ( button.width + MARGIN ) * i;
				buttons.push( addChild( button ) );
			}
			
			selectedButton = button;
			
			if ( buttons.length ) {
				ButtonManager.addButtonGroup( buttons, false, selectedButton, false, ButtonManager.STATE_PRESSED, onClick );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getSelectedYear():String {
			return selectedButton.name;
		}
		
		/**
		 * 
		 * @param	target
		 */
		
		private function onClick( target:MovieClip ):void {
			selectedButton = target as Button;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		/**
		 * 
		 */
		
		private function clear():void {
			var button:Button;
			while ( numChildren ) {
				var item:DisplayObject = getChildAt( 0 );
				if ( item is Button ) {
					button = Button( item );
					button.dispose();
				}
				removeChild( item );
			}
			
			if ( button && ButtonManager.isButton( button ) ) {
				ButtonManager.removeButtonGroup( button );
			}
			
			selectedButton = null;
		}
		
	}

}