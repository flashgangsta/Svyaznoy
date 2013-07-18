package com.flashgangsta.utils {
	import com.flashgangsta.ui.TouchScreenScroll;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	/**
	* Dispatched when screen changed
	*/
	[Event(name = "change", type = "flash.events.Event")]
	
	public class ScreenController extends Sprite {
		
		private var currentScreen:Sprite;
		private var history:Vector.<Class> = new Vector.<Class>();
		private var instncesList:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		
		public function ScreenController() {
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * 
		 * @param	screenClass
		 * @return
		 */
		
		public function addScreen( screenClass:Class, createNewInstance:Boolean = false ):DisplayObject {
			removeScreen();
			
			if ( !createNewInstance && instncesList.hasOwnProperty( screenClass ) ) {
				currentScreen = instncesList[ screenClass ];
			} else {
				currentScreen = new screenClass();
				instncesList[ screenClass ] = currentScreen;
			}
			
			history.push( screenClass );
			addChild( currentScreen );
			dispatchEvent( new Event( Event.CHANGE ) );
			return currentScreen;
		}
		
		/**
		 * 
		 */
		
		public function back():void {
			history.pop();
			addScreen( history.pop(), false );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCurrentScreenClass():Class {
			return history[ history.length - 1 ];
		}
		
		/**
		 * 
		 */
		
		private function removeScreen():void {
			trace( "removeScreen", currentScreen );
			if ( !currentScreen ) return;
			removeChild( currentScreen );
		}
		
	}

}