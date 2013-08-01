package com.svyaznoy {
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class InputError extends Sprite {
		
		static private const TIME:Number = .032;
		static private const MAX_COUNT:int = 10;
		
		private var label:TextField;
		private var count:int = 0;
		private var motionParams:Object = { time: TIME, onComplete: onComplete };
		
		/**
		 * 
		 */
		
		public function InputError() {
			visible = false;
			label = getChildByName( "label_txt" ) as TextField;
			label.text = "";
		}
		
		/**
		 * 
		 * @param	message
		 */
		
		public function setLabel( message:String ):void {
			label.text = message;
		}
		
		/**
		 * 
		 */
		
		public function show():void {
			hide();
			onComplete()
		}
		
		/**
		 * 
		 */
		
		public function hide():void {
			visible = false;
			count = 0;
			if ( isPlaying() ) {
				Tweener.removeTweens( this );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function isPlaying():Boolean {
			return Tweener.isTweening( this )
		}
		
		/**
		 * 
		 */
		
		private function onComplete():void {
			visible = !visible;
			if ( ++count === MAX_COUNT ) {
				visible = true;
			} else {
				Tweener.addTween( this, motionParams  );
			}
		}
		
	}

}