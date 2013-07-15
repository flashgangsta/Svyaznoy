package com.svyaznoy.modules {
	import com.flashgangsta.managers.ButtonManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Voting extends Sprite {
		
		static public const TYPE_SINGLE:String = "single";
		static public const TYPE_MULTI:String = "multi";
		static public const TYPE_CUSTOM:String = "custom";
		
		private var voteButton:MovieClip;
		private var _type:String;
		private var answersList:Vector.<String>;
		private var answersContainer:Sprite = new Sprite();
		private var selectedAnswer:Answer;
		
		/**
		 * 
		 */
		
		public function Voting() {
			visible = false;
			voteButton = getChildByName( "voteButton_mc" ) as MovieClip;
			answersContainer.x = 10; 
			answersContainer.y = 20; 
			addChild( answersContainer );
			answersContainer.addEventListener( Event.CHANGE, onAnswerSelected );
		}
		
		/**
		 * 
		 */
		
		public function get type():String {
			return _type;
		}
		
		/**
		 * 
		 */
		
		public function set type( value:String ):void {
			_type = value;
			
			if ( answersList ) {
				addAnswers();
			}
		}
		
		/**
		 * 
		 */
		
		private function addAnswers():void {
			
			removeAnswers();
			
			var answersClass:Class;
			
			if ( type === TYPE_SINGLE ) {
				answersClass = AnswerSingle;
			} else if ( type === TYPE_MULTI ) {
				answersClass = AnswerMulti;
			}
			
			
			for ( var i:int = 0; i < answersList.length; i++ ) {
				var answer:Answer = new answersClass();
				answer.value = answersList[ i ];
				answer.y = Math.round( answer.height * i );
				answersContainer.addChild( answer );
			}
			
			visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAnswerSelected( event:Event ):void {
			event.stopImmediatePropagation();
			
			if( type === TYPE_SINGLE ) {
				if ( selectedAnswer ) selectedAnswer.selected = false;
				selectedAnswer = event.target as Answer;
			}
			
			if ( !voteButton.enabled ) {
				ButtonManager.setButtonEnable( voteButton, true, true );
			}
			trace( selectedAnswer.value );
		}
		
		/**
		 * 
		 */
		
		private function removeAnswers():void {
			
		}
		
		/**
		 * 
		 * @param	...answers
		 */
		
		public function setAnswers( ...answers ):void {
			answersList = Vector.<String>( answers );
			
			if ( type ) {
				visible = true;
				addAnswers();
			}
			
		}
		
	}

}