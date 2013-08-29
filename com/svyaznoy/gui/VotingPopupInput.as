package com.svyaznoy.gui {
	import com.svyaznoy.modules.Voting;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	public class VotingPopupInput extends Sprite {
		
		private var label:TextField;
		private var input:TextField;
		private var iconSingle:Sprite;
		private var iconMulti:Sprite;
		private var iconBackground:Sprite;
		private var icon:Sprite;
		
		/**
		 * 
		 */
		
		public function VotingPopupInput( type:String ) {
			label = getChildByName( "labelTitle_txt" ) as TextField;
			input = getChildByName( "label_txt" ) as TextField;
			iconSingle = getChildByName( "iconSingle_mc" )  as Sprite;
			iconMulti = getChildByName( "iconMulti_mc" )  as Sprite;
			iconBackground = getChildByName( "iconBackground_mc" ) as Sprite;
			
			iconSingle.visible = iconMulti.visible = false;
			
			icon = type === Voting.TYPE_SINGLE ? iconSingle : iconMulti;
			
			input.text = "";
			
			addEventListener( MouseEvent.CLICK, onClick );
			input.addEventListener( FocusEvent.FOCUS_IN, onFocus );
			
			buttonMode = true;
		}
		
		/**
		 * 
		 */
		
		public function getValue():String {
			return input.text;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			removeEventListener( MouseEvent.CLICK, onClick );
			input.removeEventListener( FocusEvent.FOCUS_IN, onFocus );
			input.removeEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onFocus( event:FocusEvent ):void {
			if ( !input.hasEventListener( FocusEvent.FOCUS_OUT ) ) {
				onClick();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClick( event:MouseEvent = null ):void {
			input.setSelection( input.length, input.length );
			stage.focus = input;
			selected = true;
			input.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onFocusOut( event:FocusEvent ):void {
			removeEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			if ( !input.length ) {
				selected = false;
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getIconBackground():DisplayObject {
			return iconBackground.getChildAt( 0 );
		}
		
		/**
		 * 
		 */
		
		public function get selected():Boolean {
			return icon.visible;
		}
		
		public function set selected( value:Boolean ):void {
			if ( value !== icon.visible ) {
				icon.visible = value;
				label.visible = !value && !input.length;
				dispatchEvent( new Event( Event.SELECT, true ) );
			}
		}
		
	}

}