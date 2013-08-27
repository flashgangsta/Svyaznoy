package com.svyaznoy.modules {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.MiniPreloader;
	import com.svyaznoy.Provider;
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
		private var answersResultContainer:Sprite = new Sprite();
		private var selectedAnswer:Answer;
		private var questionLabel:TextField;
		private var miniPreloader:MiniPreloader;
		private var background:DisplayObject;
		private var answeredList:Array = [];
		private var popupPreviewQuestionLabel:TextField;
		private var defaultBgHeight:int;
		private var isPopupMode:Boolean;
		private var provider:Provider = Provider.getInstance();
		
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
			answersResultContainer.x = answersContainer.x;
			
			addChild( answersResultContainer );
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
			answersList = Vector.<String>( data.options_array );
			questionLabel.text = data.title.toUpperCase();
			
			if ( data.is_answered ) {
				trace( "show results" );
				loadResults();
				voteButton.visible = false;
			} else {
				if ( int( data.own_answer ) ) {
					isPopupMode = true;
				} else {
					if ( int( data.allow_multiple ) ) {
						type = TYPE_MULTI;
					} else {
						type = TYPE_SINGLE;
					}
				}
				
				
				answersContainer.y = MappingManager.getBottom( questionLabel, this ) + MARGIN_BOTTOM_LABEL;
				
				addAnswers();
				voteButton.y = MappingManager.getBottom( answersContainer, this ) + MARGIN_BOTTOM_ANSWERS;
				background.height = MappingManager.getBottom( voteButton, this ) + MARGIN_BOTTOM_VOTE_BUTTON;
				voteButton.visible = true;
			}
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			var bounds:Rectangle = getBounds( stage );
			
			if ( bounds.bottom > stage.stageHeight ) {
				initAsPopupMode();
			} else {
				visible = true;
			}
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
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
				sendAnswers( selectedAnswer.value );
			}
			
			voteButton.visible = false;
			
			showPreloader( "Отправка" );
			
			removeAnswers();
			
		}
		
		/**
		 * 
		 */
		
		private function showPreloader( message:String ):void {
			if( !miniPreloader ) {
				miniPreloader = new MiniPreloader( message );
			} else {
				miniPreloader.message = message;
				miniPreloader.visible = true;
				miniPreloader.resume();
			}
			
			MappingManager.setAlign( miniPreloader, background.getBounds( this ) );
			
			addChild( miniPreloader );
		}
		
		/**
		 * 
		 */
		
		private function hidePreloader():void {
			miniPreloader.stop();
			miniPreloader.visible = false;
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
			provider.sendAnswer( data.id, answer );
			provider.addEventListener( ProviderEvent.ON_ANSWER_SENT, onAnswerSent );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAnswerSent( event:ProviderEvent ):void {
			loadResults();
		}
		
		/**
		 * 
		 */
		
		private function loadResults():void {
			provider.removeEventListener( ProviderEvent.ON_ANSWER_SENT, onAnswerSent );
			provider.addEventListener( ProviderEvent.ON_ANSWERS, onAnswers );
			provider.getAnswers( data.id );
			showPreloader( "Загрузка\nрезультатов" );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAnswers( event:ProviderEvent ):void {
			provider.removeEventListener( ProviderEvent.ON_ANSWERS, onAnswers );
			hidePreloader();
			addAnswersResults( event.data as Array );
		}
		
		/**
		 * 
		 */
		
		private function addAnswersResults( list:Array ):void {
			var totalVotes:int = 0;
			var answerResult:AnswerResult;
			var answerData:Object;
			var options:String = "" + data.options;
			var notAnsweredNamesList:Array;
			
			removeAnswersResults();
			
			for each( var param:Object in list ) {
				totalVotes += int( param.votes );
				options = options.replace( "\n" + param.answer, "" );
				options = options.replace( param.answer, "" );
			}
			
			notAnsweredNamesList = options.split( "\n" );
			
			for ( var j:int = 0; j < notAnsweredNamesList.length; j++ ) {
				list.push( { votes: 0, answer: notAnsweredNamesList[ j ] } );
			}
			
			for ( var i:int = 0; i < answersList.length; i++ ) {
				answerResult = new AnswerResult();
				answerData = list[ i ];
				answerResult.showAnswer( answerData.answer, answerData.votes, totalVotes, i );
				answerResult.y = answersResultContainer.height + 7;
				answersResultContainer.addChild( answerResult );
			}
			
			
			answersResultContainer.y = MappingManager.getBottom( questionLabel, this ) + MARGIN_BOTTOM_LABEL;
			voteButton.y = 0 ;
			voteButton.visible = false;
			background.height = MappingManager.getBottom( answersResultContainer, this ) + MARGIN_BOTTOM_VOTE_BUTTON;
		}
		
		/**
		 * 
		 */
		
		private function removeAnswersResults():void {
			var answerResult:AnswerResult;
			while ( answersContainer.numChildren ) {
				answerResult = answersContainer.getChildAt( 0 ) as AnswerResult;
				answerResult.dispose();
				answersContainer.removeChild( answerResult );
			}
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