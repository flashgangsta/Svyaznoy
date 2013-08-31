package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.utils.ColorChanger;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class VoteResultsPopupResult extends Sprite {
		
		private var progressbar:Sprite;
		private var calculateObject:Object = { };
		private var resultLabel:TextField;
		private var answerLabel:TextField;
		
		public function VoteResultsPopupResult( answerMessage:String, votes:int, totalVotes:int, colorIndex:int ) {
			progressbar = getChildByName( "progressbar_mc" ) as Sprite;
			answerLabel = getChildByName( "label_txt" ) as TextField;
			resultLabel = getChildByName( "result_txt" ) as TextField;
			
			answerLabel.autoSize = TextFieldAutoSize.LEFT;
			answerLabel.text = answerMessage;
			resultLabel.autoSize = TextFieldAutoSize.LEFT;
			resultLabel.y = MappingManager.getBottom( answerLabel, this );
			resultLabel.visible = false;
			progressbar.y = resultLabel.y + 1;
			
			ColorChanger.setColorByIndex( progressbar.getChildAt( 0 ), colorIndex );
			
			progressbar.width = 0;
			
			if ( votes ) {
				calculateObject.votesTempValue = 0;
				Tweener.addTween( progressbar, { scaleX: votes / totalVotes, time: 1, transition: "easeInOutCubic", onComplete: onComplete } );
				Tweener.addTween( calculateObject, { votesTempValue: votes, time: 1, transition: "easeInOutCubic", onUpdate: onTweenUpdate } )
			} else {
				progressbar.width = 1;
			}
			
			
		}
		
		/**
		 * 
		 */
		
		private function onComplete():void {
			if ( progressbar.width > resultLabel.width ) {
				resultLabel.alpha = 0;
				resultLabel.visible = true;
				Tweener.addTween( resultLabel, { alpha: 1, time: .5, transition: "easeInOutCubic" } );
			}
		}
		
		/**
		 * 
		 */
		
		private function onTweenUpdate():void {
			resultLabel.text = Math.round( calculateObject.votesTempValue ).toString();
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			
		}
		
	}

}