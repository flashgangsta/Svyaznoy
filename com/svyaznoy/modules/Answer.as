package com.svyaznoy.modules {
	import com.flashgangsta.managers.ButtonManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Answer extends MovieClip {
		
		private var thumb:DisplayObject;
		protected var label:TextField;
		protected var hit:MovieClip;
		
		/**
		 * 
		 */
		
		public function Answer() {
			label = getChildByName( "label_txt" ) as TextField;
			thumb = getChildByName( "thumb_mc" );
			hit = getChildByName( "hit_mc" ) as MovieClip;
			
			if ( thumb ) {
				thumb.visible = false;
			}
			
			hit.visible = true;
			hit.alpha = 0;
			ButtonManager.addButton( this, hit, onClick );
			
		}
		
		/**
		 * 
		 */
		
		protected function onClick( target:MovieClip ):void {
			thumb.visible = !thumb.visible;
			dispatchEvent( new Event( Event.CHANGE, true ) );
		}
		
		/**
		 * 
		 */
		
		public function get value():String {
			return label.text;
		}
		
		public function set value( value:String ):void {
			label.text = value;
		}
		
		/**
		 * 
		 */
		
		public function get selected():Boolean {
			return thumb ? thumb.visible : false;
		}
		
		public function set selected( value:Boolean ):void {
			if ( !thumb || thumb.visible === value ) return;
			thumb.visible = value;
			dispatchEvent( new Event( Event.CHANGE, true ) );
		}
		
		/**
		 * 
		 */
		
		internal function dispose():void {
			
		}
		
	}

}