package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.utils.getChildByType;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class InputError extends Sprite {
		
		static private const TIME:Number = .3;
		
		private var label:TextField;
		private var motionParams:Object = { alpha: 0, time: TIME, transition: "easeInOutCubic", onComplete: onComplete };
		
		/**
		 * 
		 */
		
		public function InputError() {
			visible = false;
			alpha = 0;
			label = getChildByType( this, TextField ) as TextField;
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
			visible = true;
			motionParams.alpha = 1;
			Tweener.addTween( this, motionParams );
		}
		
		/**
		 * 
		 */
		
		public function hide():void {
			if ( isPlaying() ) {
				Tweener.removeTweens( this );
			}
			motionParams.alpha = 0;
			Tweener.addTween( this, motionParams );
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
			visible = Boolean( alpha );
		}
		
	}

}