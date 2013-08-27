package com.svyaznoy.modules {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
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
		
		private const MARGIN_BOTTOM_LABEL:int = 5;
		private const MARGIN_BOTTOM_ANSWERS:int = 10;
		private const MARGIN_BOTTOM_VOTE_BUTTON:int = 15;
		
		private var data:Object;
		private var voteButton:MovieClip;
		private var type:String;
		private var answersList:Vector.<String>;
		private var answersContainer:Sprite = new Sprite();
		private var selectedAnswer:Answer;
		private var questionLabel:TextField;
		private var miniPreloader:MiniPreloader;
		private var background:DisplayObject;
		private var answeredList:Array = [];
		private var popupPreviewQuestionLabel:TextField;
		private var defaultBgHeight:int;
		private var isPopupMode:Boolean;
		
		/**
		 * 
		 */
		
		public function Voting() {
			visible = false;
			
			background = getChildAt( 0 ) as DisplayObject;
			defaultBgHeight = background.height;
			
			questionLabel = getChildByName( "question_txt" ) as TextField;
			popupPreviewQuestionLabel = getChildByName( "popupPreviewQuestion_txt" ) as TextField;
			
			questionLabel.autoSize = TextFieldAutoSize.LEFT;
			popupPreviewQuestionLabel.autoSize = TextFieldAutoSize.LEFT;
			
			popupPreviewQuestionLabel.visible = false;
			
			answersContainer.x = 10; 
			addChild( answersContainer );
			answersContainer.addEventListener( Event.CHANGE, onAnswerSelected );
			
			voteButton = getChildByName( "vote_mc" ) as MovieClip;
			voteButton.enabled = false;
			voteButton.addEventListener( MouseEvent.CLICK, voteButtonClicked );
		}
		
		/**
		 * 
		 * @param	type
		 * @param	voting
		 * @param	...answers
		 */
		
		public function init( data:Object ):void {
			this.data = data;
			
			if ( data.is_answered ) {
				trace( "show results" );
			} else {
				if ( int( data.allow_multiple ) ) {
					type = TYPE_MULTI;
				} else {
					type = TYPE_SINGLE;
				}
				
				questionLabel.text = data.title.toUpperCase();
				answersContainer.y = MappingManager.getBottom( questionLabel, this ) + MARGIN_BOTTOM_LABEL;
				answersList = Vector.<String>( data.options_array );
				addAnswers();
				voteButton.y = MappingManager.getBottom( answersContainer, this ) + MARGIN_BOTTOM_ANSWERS;
				background.height = MappingManager.getBottom( voteButton, this ) + MARGIN_BOTTOM_VOTE_BUTTON;
				
				
				addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
		}
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var bounds:Rectangle = getBounds( stage );
			
			if ( bounds.bottom > stage.stageHeight ) {
				initAsPopupMode();
			} else {
				visible = true;
			}
			
		}
		
		/**
		 * 
		 */
		
		private function initAsPopupMode():void {
			trace( "makePopupMode" );
			var titleBottom:int;
			isPopupMode = true;
			removeAnswers();
			visible = true;
			background.height = defaultBgHeight;
			voteButton.y =  MappingManager.getBottom( background, this ) - voteButton.height - MARGIN_BOTTOM_VOTE_BUTTON;
			popupPreviewQuestionLabel.text = questionLabel.text;
			questionLabel.text = "ОПРОСЫ";
			
			titleBottom = MappingManager.getBottom( questionLabel, this );
			popupPreviewQuestionLabel.y = titleBottom + MappingManager.getCentricPoint( voteButton.y - titleBottom, popupPreviewQuestionLabel.height );
			popupPreviewQuestionLabel.visible = true;
			
			voteButton.enabled = true;
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
				answer.y = answersContainer.height;
				answersContainer.addChild( answer );
			}
		}
		
		/**
		 * 
		 */
		
		private function removeAnswers():void {
			while ( answersContainer.numChildren ) {
				var answer:Answer = answersContainer.getChildAt( 0 ) as Answer;
				answer.dispose();
				answersContainer.removeChild( answer );
			}
		}
		
		
		/**
		 * 
		 */
		
		private function voteButtonClicked( event:MouseEvent ):void {
			if ( isPopupMode ) {
				callPopup();
				return;
			}
			
			if ( type === TYPE_MULTI ) {
				var selectedAnswers:Vector.<String> = new Vector.<String>();
				var answer:Answer;
				for ( var i:int = 0; i < answeredList.length; i++ ) {
					answer = answersContainer.getChildAt( answeredList[ i ] ) as Answer;
					selectedAnswers.push( answer.value );
				}
				sendAnswers( selectedAnswers );
				
			} else {
				trace( "send answer:", selectedAnswer.value );
			}
			
			voteButton.visible = false;
			miniPreloader = new MiniPreloader( "Отправка" );
			MappingManager.setAlign( miniPreloader, background.getBounds( this ) );
			answersContainer.visible = false;
			addChild( miniPreloader );
			
		}
		
		/**
		 * 
		 */
		
		private function callPopup():void {
			trace( "callPopup" );
		}
		
		/**
		 * 
		 * @param	...answers
		 */
		
		private function sendAnswers( ...answers ):void {
			var answer:String;
			if ( answers[ 0 ] is Vector.<String> ) {
				answer = Vector.<String>( answers[ 0 ] ).toString();
			} else {
				answer = answers.toString();
			}
			trace( "send answers:", answer );
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
			
			if ( selectedAnswer.selected ) {
				answeredList.push( answersContainer.getChildIndex( selectedAnswer ) );
			} else {
				var answerIndex:int = answeredList.indexOf( answersContainer.getChildIndex( selectedAnswer ) );
				answeredList = answeredList.slice( 0, answerIndex ).concat( answeredList.slice( answerIndex + 1 ) );
			}
			
			voteButton.enabled = Boolean( answeredList.length );
		}
	}

}