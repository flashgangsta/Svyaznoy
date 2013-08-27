package com.svyaznoy.gui {
	import com.flashgangsta.managers.MappingManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MiniPreloader extends Sprite {
		
		static public const ROTATION_STEP:Number = 2;
		static public const DOTS_DELAY:int = 300;
		
		private var animation:MovieClip;
		private var label:TextField;
		private var timer:Timer = new Timer( 20 );
		private var messageText:String;
		private var dots:String = "";
		private var currentDotsDelay:Number = 0;
		private var background:DisplayObject;
		
		/**
		 * 
		 * @param	message
		 */
		
		public function MiniPreloader( message:String = "Загрузка" ) {
			animation = getChildByName( "animation_mc" ) as MovieClip;
			label = getChildByName( "label_txt" ) as TextField;
			background = getChildAt( 0 );
			background.visible = false;
			
			label.autoSize = TextFieldAutoSize.LEFT;
			
			this.message = message + "...";
			
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			timer.start();
		}
		
		/**
		 * 
		 */
		
		public function stop():void {
			timer.removeEventListener( TimerEvent.TIMER, onTimer );
			timer.stop();
			animation.stop();
		}
		
		/**
		 * 
		 */
		
		public function resume():void {
			if ( !timer.hasEventListener( TimerEvent.TIMER ) ) {
				timer.addEventListener( TimerEvent.TIMER, onTimer );
			}
			
			if ( !timer.running ) {
				timer.start();
			}
		}
		
		/**
		 * 
		 */
		
		public function set message( value:String ):void {
			if ( value !== messageText ) {
				messageText = value;
				label.text = value + "...";
				updatePosition();
			}
		}
		
		/**
		 * 
		 */
		
		private function updatePosition():void {
			var baseObject:DisplayObject = animation.width > label.width ? animation : label;
			
			background.width = baseObject.x * 2 + baseObject.width;
			
			animation.x = MappingManager.getCentricPoint( background.width, animation.width );
			label.x = MappingManager.getCentricPoint( background.width, label.width );
			
			animation.y = MappingManager.getBottom( label, this ) + 7;
			background.height = MappingManager.getBottom( animation, this ) + label.y;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTimer( event:TimerEvent ):void {
			currentDotsDelay += timer.delay;
			
			if ( currentDotsDelay >= DOTS_DELAY ) {
				currentDotsDelay = 0;
				if ( dots.length === 3 ) {
					dots = "";
				} else {
					dots += ".";
				}
				label.text = messageText + dots;
			}
		}
		
	}

}