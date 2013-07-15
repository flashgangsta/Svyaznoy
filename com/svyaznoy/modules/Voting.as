package com.svyaznoy.modules {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Voting extends Sprite {
		
		static public const TYPE_SINGLE:String = "single";
		static public const TYPE_MULTI:String = "multi";
		static public const TYPE_CUSTOM:String = "custom";
		
		private var voteButton:MovieClip;
		private var type:String;
		private var answersList:Vector.<String>;
		private var answersContainer:Sprite = new Sprite();
		private var selectedAnswer:Answer;
		private var questionLabel:TextField;
		private var miniPreloader:MiniPreloader;
		
		/**
		 * 
		 */
		
		public function Voting() {
			visible = false;
			
			questionLabel = getChildByName( "question_txt" ) as TextField;
			questionLabel.autoSize = TextFieldAutoSize.LEFT;
			
			answersContainer.x = 10; 
			addChild( answersContainer );
			answersContainer.addEventListener( Event.CHANGE, onAnswerSelected );
			
			voteButton = getChildByName( "vote_mc" ) as MovieClip;
			ButtonManager.addButton( voteButton, null, voteButtonClicked );
			ButtonManager.setButtonEnable( voteButton, false, true );
		}
		
		/**
		 * 
		 * @param	type
		 * @param	voting
		 * @param	...answers
		 */
		
		public function init( type:String, question:String, ...answers ):void {
			this.type = type;
			
			questionLabel.text = question;
			
			answersContainer.y = Math.round( questionLabel.y + questionLabel.height );
			
			answersList = Vector.<String>( answers );
			addAnswers();
			visible = true;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			ButtonManager.removeButton( voteButton );
			removeAnswers();
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
			} else {
				answersContainer.addChild( new AnswerCustom() );
				return;
			}
			
			for ( var i:int = 0; i < answersList.length; i++ ) {
				var answer:Answer = new answersClass();
				answer.value = answersList[ i ];
				answer.y = Math.round( answer.height * i );
				answersContainer.addChild( answer );
			}
		}
		
		private function removeAnswers():void {
			while ( answersContainer.numChildren ) {
				var answer:Answer = getChildAt( 0 ) as Answer;
				answer.dispose();
				answersContainer.removeChild( answer );
			}
		}
		
		
		/**
		 * 
		 */
		
		private function voteButtonClicked( target:MovieClip ):void {
			if ( type === TYPE_MULTI ) {
				var selectedAnswers:Vector.<String> = new Vector.<String>();
				var answer:Answer;
				for ( var i:int = 0; i < answersContainer.numChildren; i++ ) {
					answer = answersContainer.getChildAt( i ) as Answer;
					if ( answer.selected  ) {
						selectedAnswers.push( answer.value );
					}
				}
				trace( "send answers:", selectedAnswers );
			} else {
				trace( "send answer:", selectedAnswer.value );
			}
			
			voteButton.visible = false;
			miniPreloader = new MiniPreloader( "Отправка" );
			MappingManager.setAlign( miniPreloader, voteButton.getBounds( this ) );
			addChild( miniPreloader );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAnswerSelected( event:Event ):void {
			event.stopImmediatePropagation();
			
			if( type === TYPE_SINGLE ) {
				if ( selectedAnswer ) selectedAnswer.selected = false;
			}
			
			selectedAnswer = event.target as Answer;
			
			if ( type === TYPE_CUSTOM ) {
				if ( selectedAnswer.value && !voteButton.enabled ) {
					ButtonManager.setButtonEnable( voteButton, true, true );
				} else if ( !selectedAnswer.value && voteButton.enabled ) {
					ButtonManager.setButtonEnable( voteButton, false, true );
				}
			} else {
				if ( !voteButton.enabled ) {
					ButtonManager.setButtonEnable( voteButton, true, true );
				}
			}
		}
	}

}