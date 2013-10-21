package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScreenWithComments extends ScreenWithDynamicContent {
		
		protected var comments:NewsComments;
		
		private var MARGIN:int = 10;
		
		public function ScreenWithComments() {
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
		}
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			setDisplayItemsAlignment();
		}
		
		protected function setDisplayItemsAlignment():void {
			comments.view.y = dynamicContentViewer.getBottom();
		}
		
	}

}