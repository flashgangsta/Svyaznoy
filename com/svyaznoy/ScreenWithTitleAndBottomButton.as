package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenWithTitleAndBottomButton extends Screen {
		
		protected var title:TextField;
		protected var bottomButton:Button;
		
		public function ScreenWithTitleAndBottomButton() {
			title = getChildByName( "titleLabel_txt" ) as TextField;
			bottomButton = getChildByName( "bottomButton_mc" ) as Button;
			
			title.autoSize = TextFieldAutoSize.LEFT;
			
			setElementsForVisibleControll( title, bottomButton );
		}
		
	}

}