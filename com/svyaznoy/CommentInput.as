package com.svyaznoy {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentInput extends Sprite {
		
		private const DEFAULT_MESSAGE:String = "Написать комментарий…";
		
		private var _view:CommentInputView = new CommentInputView();
		private var message:String;
		
		/**
		 * 
		 */
		
		public function CommentInput() {
			_view.inputLabel.addEventListener( FocusEvent.FOCUS_IN, onInputLabelFocus );
			_view.inputLabel.addEventListener( FocusEvent.FOCUS_OUT, onInputLabelFocusOut );
			_view.inputLabel.addEventListener( Event.CHANGE, onChanged );
			reset();
		}
		
		/**
		 * 
		 */
		
		public function get view():CommentInputView {
			return _view;
		}
		
		/**
		 * 
		 */
		
		public function reset():void {
			_view.inputLabel.text = DEFAULT_MESSAGE;
			onChanged();
		}
		
		public function getMessage():String {
			return message;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onInputLabelFocusOut( event:FocusEvent ):void {
			if ( !getMessage() ) {
				view.inputLabel.text = DEFAULT_MESSAGE;
				onChanged();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onInputLabelFocus( event:FocusEvent ):void {
			if ( _view.inputLabel.text === DEFAULT_MESSAGE ) {
				view.inputLabel.text = "";
				onChanged();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onChanged( event:Event = null ):void {
			if ( event ) event.stopImmediatePropagation();
			var text:String = _view.inputLabel.text;
			var buttonEnable:Boolean = _view.addCommentButton.enabled;
			
			if ( text && text !== DEFAULT_MESSAGE && !buttonEnable ) {
				_view.addCommentButton.enabled = true;
			} else if ( text === DEFAULT_MESSAGE && buttonEnable ) {
				_view.addCommentButton.enabled = false;
			} else if ( !text && buttonEnable ) {
				_view.addCommentButton.enabled = false;
			}
			
			if ( text !== DEFAULT_MESSAGE ) {
				message = text;
			}
		}
	}

}