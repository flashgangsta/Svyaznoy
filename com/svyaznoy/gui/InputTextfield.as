package com.svyaznoy.gui {
	import com.flashgangsta.utils.Queue;
	import com.svyaznoy.events.InputTextfieldEvent;
	import com.svyaznoy.InputError;
	import fl.text.TLFTextField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class InputTextfield extends Sprite {
		
		private var label:TLFTextField;
		private var error:InputError;
		private var queue:Queue;
		private var titleLabel:TextField;
		private var _autoDispose:Boolean = true;
		
		/**
		 * 
		 */
		
		public function InputTextfield() {
			label = getChildByName( "label_txt" ) as TLFTextField;
			error = getChildByName( "error_mc" ) as InputError;
			titleLabel = getChildByName( "title_txt" ) as TextField;
			label.setSelection( 0, label.text.length );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			addEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			addEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			
			title = "";
			titleLabel.mouseEnabled = titleLabel.mouseWheelEnabled = false;
		}
		
		/**
		 * 
		 */
		
		public function get text():String {
			return label.text;
		}
		
		/**
		 * 
		 */
		
		public function set text( value:String ):void {
			label.text = value;
		}
		
		/**
		 * 
		 */
		
		public function get length():int {
			return label.length;
		}
		
		/**
		 * 
		 * @param	message
		 */
		
		public function setErrorMessage( message:String ):void {
			error.setLabel( message );
		}
		
		/**
		 * 
		 */
		
		public function setFocus():void {
			if ( stage ) {
				label.textFlow.interactionManager.setFocus();
				label.setSelection( 0, label.text.length );
			} else {
				queue = new Queue();
				queue.add( setFocus );
			}
			
		}
		
		/**
		 * 
		 */
		
		public function showError():void {
			error.show();
			setFocus();
			if ( !label.hasEventListener( Event.CHANGE ) ) {
				label.addEventListener( Event.CHANGE, onChangedAfterError );
			}
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			if ( !label || !_autoDispose ) return;
			trace( "dispose input" );
			
			if ( label.hasEventListener( Event.CHANGE ) ) {
				label.removeEventListener( Event.CHANGE, onChangedAfterError );
			}
			
			label.removeEventListener( TextEvent.TEXT_INPUT, onTextInput );
			
			removeEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			removeEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			
			error.hide();
			
			error = null;
			label = null;
		}
		
		/**
		 * 
		 */
		
		public function set title( value:String ):void {
			titleLabel.text = value;
		}
		
		public function get title():String {
			return titleLabel.text;
		}
		
		/**
		 * 
		 */
		
		public function get autoDispose():Boolean {
			return _autoDispose;
		}
		
		public function set autoDispose(value:Boolean):void {
			_autoDispose = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			text = "";
			if ( queue ) {
				queue.applyAll();
				queue = null;
			}
			label.addEventListener( TextEvent.TEXT_INPUT, onTextInput );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTextInput( event:TextEvent ):void {
			if ( event.text.charCodeAt( event.text.length - 1 ) === Keyboard.ENTER ) {
				event.preventDefault();
				dispatchEvent( new InputTextfieldEvent( InputTextfieldEvent.SUBMIT ) );
			}
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onChangedAfterError( event:Event ):void {
			if ( error.isPlaying() ) return;
			label.removeEventListener( Event.COMPLETE, onChangedAfterError );
			error.hide();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onFocusIn( event:FocusEvent ):void {
			titleLabel.visible = false;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onFocusOut( event:FocusEvent ):void {
			if( !label.length ) titleLabel.visible = true;
		}
		
	}

}