package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Screen extends Sprite {
		
		public static const MARGIN:int = 10;
		
		private var preloader:MiniPreloader;
		private var elementsForVisibleControll:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		protected var data:Object;
		protected var provider:Provider = Provider.getInstance();
		
		
		/**
		 * 
		 */
		
		public function Screen() {
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		protected function onData( event:ProviderEvent ):void {
			data = event.data;
			removePreloader();
		}
		
		/**
		 * 
		 */
		
		protected function addPreloader():void {
			if ( preloader ) return;
			preloader = new MiniPreloader();
			MappingManager.setAlign( preloader, new Rectangle( 0, 0, parent.width, parent.height ) );
			addChild( preloader );
		}
		
		/**
		 * 
		 */
		
		protected function displayData():void {
			
		}
		
		/**
		 * 
		 */
		
		protected function dispatchHeighUpdated():void {
			dispatchEvent( new ScreenEvent( ScreenEvent.HEIGHT_UPDATED, true ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		protected function updatePositions( margin:int, container:DisplayObjectContainer = null ):void {
			var item:DisplayObject;
			var itemY:int = 0;
			
			if ( !container ) container = this;
			
			for ( var i:int = 0; i < container.numChildren; i++ ) {
				item = container.getChildAt( i );
				item.y = itemY;
				itemY = Math.round( itemY + item.height + margin );
			}
			
			dispatchHeighUpdated();
		}
		
		/**
		 * 
		 * @param	value
		 */
		
		protected function setVisibleForElements( value:Boolean ):void {
			for ( var i:int = 0; i < elementsForVisibleControll.length; i++ ) {
				elementsForVisibleControll[ i ].visible = value;
			}
		}
		
		/**
		 * 
		 * @param	...rest DisplayObjects
		 */
		
		protected function setElementsForVisibleControll( ...rest ):void {
			elementsForVisibleControll = elementsForVisibleControll.concat( Vector.<DisplayObject>( rest ) );
		}
		
		/**
		 * 
		 */
		
		protected function removePreloader():void {
			if ( !preloader ) return;
			preloader.stop();
			removeChild( preloader );
			preloader = null;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			addPreloader();
		}
	}

}