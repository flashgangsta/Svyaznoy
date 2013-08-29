package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.gui.Button;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class VoteResultsPopup extends Popup {
		
		private const MARGIN:int = 20;
		
		private var label:TextField;
		private var answersContainer:Sprite = new Sprite();
		private var cancelButton:Button;
		
		/**
		 * 
		 * @param	question
		 * @param	list
		 */
		
		public function VoteResultsPopup( question:String, list:Vector.<Object>, totalVotes:int ) {
			var answer:VoteResultsPopupResult;
			var data:Object;
			
			label = getChildByName( "question_txt" ) as TextField;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = question;
			
			cancelButton = getChildByName( "cancel_mc" ) as Button;
			cancelButton.addEventListener( MouseEvent.CLICK, onCancelClicked );
			cancelButton.setLabel( "Вернуться к приложению".toUpperCase() );
			
			answersContainer.x = label.x;
			answersContainer.y = MappingManager.getBottom( label, this ) + MARGIN;
			
			for ( var i:int = 0; i < list.length; i++ ) {
				data = list[ i ];
				answer = new VoteResultsPopupResult( data.answer, data.votes, totalVotes, i );
				answer.y = answersContainer.height + 7;
				answersContainer.addChild( answer );
			}
			
			cancelButton.y = MappingManager.getBottom( answersContainer, this ) + MARGIN;
			background.height = MappingManager.getBottom( cancelButton, this ) + MARGIN - background.y;
			
			addChild( answersContainer );
			
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			var answer:VoteResultsPopupResult;
			super.dispose();
			cancelButton.removeEventListener( MouseEvent.CLICK, onCancelClicked );
			cancelButton.dispose();
			while ( answersContainer.numChildren ) {
				answer = answersContainer.getChildAt( 0 ) as VoteResultsPopupResult;
				answer.dispose();
				answersContainer.removeChild( answer );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onCancelClicked( event:MouseEvent ):void {
			
		}
		
	}

}