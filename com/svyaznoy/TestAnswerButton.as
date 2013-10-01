package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.utils.ColorChanger;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class TestAnswerButton extends Button {
		
		private var answerLabel:TextField;
		private var variantLabel:TextField;
		private var background:Sprite;
		private var _index:int;
		
		public function TestAnswerButton() {
			answerLabel = getChildByName( "label_txt" ) as TextField;
			variantLabel = getChildByName( "variantLabel_txt" ) as TextField;
			background = getChildByName( "background_mc" ) as Sprite;
			answerLabel.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function get variant():String {
			return name.substr( 0, 1 ).toUpperCase();
		}
		
		public function set variant(value:String):void {
			variantLabel.text = value;
		}
		
		public function set index( value:int ):void {
			_index = value;
			ColorChanger.setColorByIndex( background.getChildAt( 0 ), value );
		}
		
		public function get index():int {
			return _index;
		}
		
		override public function setLabel(message:String):void {
			if ( !message ) {
				visible = false;
				return;
			}
			answerLabel.text = message;
			answerLabel.y = MappingManager.getCentricPoint( background.height, answerLabel.height );
		}
		
		public function get value():String {
			return answerLabel.text;
		}
		
	}

}