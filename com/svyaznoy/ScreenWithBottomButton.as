package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class ScreenWithBottomButton extends ScreenWithDynamicContent {
		
		public static const MARGIN:int = 15;
		
		protected var bottomButton:Button;
		
		/**
		 * 
		 */
		
		public function ScreenWithBottomButton() {
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
		
		private function setPositions():void {
			if ( !bottomButton.visible ) return;
			bottomButton.y = MappingManager.getBottom( dynamicContentViewer, this ) + MARGIN;
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