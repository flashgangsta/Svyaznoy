package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentsEvent extends Event {
		
		static public const ADD_COMMENT_CALLED:String = "addCommentCalled";
		static public const ON_COMMENTS_READY:String = "onCommentsReady";
		static public const ON_OLD_COMMENTS_CALLED:String = "onOldCommentsCalled";
		
		
		private var _lastCommentID:int;
		
		public function CommentsEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new CommentsEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "CommentsEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		public function get lastCommentID():int {
			return _lastCommentID;
		}
		
		public function set lastCommentID(value:int):void {
			_lastCommentID = value;
		}
		
	}
	
}