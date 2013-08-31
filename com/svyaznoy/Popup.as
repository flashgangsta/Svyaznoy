package com.svyaznoy {
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.PopupEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Popup extends Sprite {
		
		public var isModal:Boolean = false;
		private var closeButton:Button;
		
		protected var background:DisplayObject;
		
		
		/**
		 * 
		 */
		
		public function Popup() {
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			closeButton = getChildByName( "closeButton_mc" ) as Button;
			background = getChildAt( 0 );
			if ( closeButton ) {
				closeButton.addEventListener( MouseEvent.CLICK, onCloseButtonClicked );
			}
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			for ( var i:int = 0; i < numChildren; i++ ) {
				var item:DisplayObject = getChildAt( i );
				var disposeProperty:Object;
				
				if ( item.hasOwnProperty( "dispose" ) ) {
					disposeProperty = item[ "dispose" ];
					if ( disposeProperty is Function ) {
						var handler:Function = disposeProperty as Function;
						handler();
					}
				}
			}
			
			if ( closeButton ) {
				closeButton.removeEventListener( MouseEvent.CLICK, onCloseButtonClicked );
			}
			
			if( stage ) stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		/**
		 * 
		 */
		
		public function close():void {
			if ( !parent ) return;
			PopupsController.getInstance().hidePopup();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onKeyDown( event:KeyboardEvent ):void {
			if ( event.keyCode === Keyboard.ENTER ) {
				dispatchEvent( new PopupEvent( PopupEvent.ENTER_ON_KEYBOARD_PRESS ) );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onCloseButtonClicked( event:MouseEvent ):void {
			close();
		}
		
	}

}