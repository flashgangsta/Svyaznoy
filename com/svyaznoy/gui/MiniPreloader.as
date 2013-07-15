package com.svyaznoy.gui {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MiniPreloader extends Sprite {
		
		static public const ROTATION_STEP:Number = 2;
		static public const DOTS_DELAY:int = 300;
		
		private var icon:Sprite;
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
			icon = getChildByName( "icon_mc" ) as Sprite;
			label = getChildByName( "label_txt" ) as TextField;
			background = getChildAt( 0 );
			messageText = message;
			
			label.text = messageText + "...";
			label.autoSize = TextFieldAutoSize.LEFT;
			
			background.width = label.x + label.width + icon.getBounds( this ).x;
			
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			timer.start();
		}
		
		/**
		 * 
		 */
		
		public function stop():void {
			timer.removeEventListener( TimerEvent.TIMER, onTimer );
			timer.stop();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTimer( event:TimerEvent ):void {
			icon.rotation += ROTATION_STEP;
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