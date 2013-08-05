package com.svyaznoy {
	import com.svyaznoy.utils.ContentParser;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Test extends Sprite {
		
		public function Test() {
			
			var s:String = " ![link](http://tut.by [sdfsdfsd])\n ![link](http://es.svyaznoy.ru/test%20тест фile.doc[mailto_params]) ![yourtube](video2) ![yourtube](video3) ![yourtube](video4) ![image](http://sex.ru/img.png) ";
			
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText;
			
			
			var tags:Vector.<ContentTag> = ContentParser.parse( s );
			
			for ( var i:int = 0; i < tags.length; i++ ) {
				trace( tags[ i ].value );
				trace( "--------" );
			}
			
		}
		
	}

}