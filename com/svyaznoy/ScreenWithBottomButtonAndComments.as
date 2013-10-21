package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class ScreenWithBottomButtonAndComments extends ScreenWithComments {
		
		public static const MARGIN:int = 15;
		protected var bottomButton:Button;
		
		
		/**
		 * 
		 */
		
		public function ScreenWithBottomButtonAndComments() {
			bottomButton = getChildByName( "bottomButton_mc" ) as Button;
			bottomButton.visible = false;
			addChild( bottomButton );
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
			setPositions();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			bottomButton.visible = true;
			super.onData( event );
		}
		
		/**
		 * 
		 */
		
		override protected function setDisplayItemsAlignment():void {
			var lastItem:DisplayObject = dynamicContentViewer;
			if ( comments && contains( comments.view ) ) {
				bottomButton.y = comments.bottom + MARGIN;
			} else {
				bottomButton.y = Math.ceil( MappingManager.getBottom( dynamicContentViewer, this ) + MARGIN );
			}
			super.setDisplayItemsAlignment();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			event.stopPropagation();
			setPositions();
			dispatchHeighUpdated();
		}
		
	}

}