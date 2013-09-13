package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.gui.Button;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenWithTopButton extends ScreenWithDynamicContent {
		
		public static const MARGIN:int = 15;
		
		protected var topButton:Button;
		
		public function ScreenWithTopButton() {
			topButton = getChildByName( "topButton_mc" ) as Button;
			topButton.visible = false;
			topButton.y = 0;
			addChild( topButton );
		}
		
	}

}