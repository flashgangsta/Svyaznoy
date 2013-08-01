package com.svyaznoy {
	import fl.text.TLFTextField;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextDecoration;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DynamicText extends DynamicItem {
		
		private var label:TLFTextField;
		private var myTextFlow:TextFlow
		private var message:String;
		
		public function DynamicText( message:String ) {
			this.message = message;
			
			label = getChildByName( "label_txt" ) as TLFTextField;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.embedFonts = true;
			
			addEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
		}
		
		private function addedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
			label.htmlText = message;
			
			myTextFlow = label.textFlow;
			myTextFlow.linkNormalFormat = { color:0xFFFFFF, textDecoration:TextDecoration.NONE };
			myTextFlow.linkHoverFormat = { color:0xFFFFFF, textDecoration:TextDecoration.UNDERLINE };
			//myTextFlow.linkActiveFormat = { color:0x000000, textDecoration:TextDecoration.UNDERLINE };
			myTextFlow.flowComposer.updateAllControllers();
			dispatchChange();
		}
		
	}

}