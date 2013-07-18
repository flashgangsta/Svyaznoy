package com.flashgangsta.utils {
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.MappingManager;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01
	 */
	
	public class PopupsController {
		
		private var stage:Stage;
		private var blockRectColor:uint;
		private var blockRectAlpha:Number;
		private var blockRect:Sprite = new Sprite();
		private var blockRectMotionIn:Object = { alpha: 1, time: .4, transition: "easeOutCubic", onComplete: onBlockRectMotionComplete };
		private var blockRectMotionOut:Object = { alpha: 0, time: .4, transition: "easeInCubic" };
		private var popupMotionIn:Object = { alpha: 1, time: .5, transition: "easeOutExpo" };
		private var popupMotionOut:Object = { alpha: 0, time: .1, transition: "easeInCubic" };
		private var popup:DisplayObject;
		
		
		/**
		 * 
		 * @param	stage
		 * @param	blockRectColor
		 * @param	blockRectAlpha
		 */
		
		public function PopupsController( stage:Stage, blockRectColor:uint = 0, blockRectAlpha:Number = .65 ) {
			this.blockRectAlpha = blockRectAlpha;
			this.blockRectColor = blockRectColor;
			this.stage = stage;
			
			blockRect.alpha = 0;
			blockRect.mouseChildren = false;
			blockRect.mouseEnabled = false;
			blockRect.addEventListener( MouseEvent.CLICK, onBlockRectClicked );
			
			drawBlockRect();
			
			stage.addEventListener( Event.RESIZE, onStageResize );
			
			///
			popupMotionOut.onComplete = function() {
				onPopupMotionOutComplete( this );
			}
		}
		
		/**
		 * 
		 * @param	popup
		 * @param	isModal
		 */
		
		public function showPopup( popup:DisplayObject, isModal:Boolean = false ):void {
			if ( isModal ) {
				stage.addChild( blockRect );
				if ( blockRect.alpha < 1 ) {
					Tweener.addTween( blockRect, blockRectMotionIn );
				}
			}
			
			this.popup = popup;	
			popup.alpha = 0;
			popup.y = 0;
			setPopupX();
			popupMotionIn.y = MappingManager.getCentricPoint( stage.stageHeight, popup.height );
			stage.addChild( popup );
			
			Tweener.addTween( popup, popupMotionIn );
		}
		
		/**
		 * 
		 */
		
		public function hidePopup():void {
			if ( blockRect.parent ) {
				stage.removeChild( blockRect );
				blockRect.alpha = 0;
				blockRect.mouseChildren = false;
				blockRect.mouseEnabled = false;
			}
			
			Tweener.addTween( popup, popupMotionOut );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onStageResize( event:Event ):void {
			blockRect.width = stage.stageWidth;
			blockRect.height = stage.stageHeight;
			if ( popup ) {
				setPopupX();
				if ( !Tweener.isTweening( popup ) && popup.alpha === 1 ) {
					popup.y = MappingManager.getCentricPoint( stage.stageHeight, popup.height );
				}
			}
		}
		
		/**
		 * 
		 */
		
		private function setPopupX():void {
			popup.x = MappingManager.getCentricPoint( stage.stageWidth, popup.width );
		}
		
		/**
		 * 
		 */
		
		private function drawBlockRect():void {
			var graphics:Graphics = blockRect.graphics;
			
			graphics.beginFill( blockRectColor, blockRectAlpha );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBlockRectClicked( event:MouseEvent ):void {
			hidePopup();
		}
		
		/**
		 * 
		 */
		
		private function onBlockRectMotionComplete():void {
			if ( blockRect.alpha === 1 ) {
				blockRect.mouseChildren = blockRect.mouseEnabled = true;
			}
		}
		
		/**
		 * 
		 * @param	popup
		 */
		
		private function onPopupMotionOutComplete( popup:DisplayObject ):void {
			trace( popup, "removed from stage" );
			stage.removeChild( popup );
		}
		
	}

}