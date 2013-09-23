package com.svyaznoy {
	import com.flashgangsta.ui.Label;
	import com.svyaznoy.utils.DateParser;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapItemDate extends Sprite {
		
		private var label:TextField;
		private var targetDateHere:Date;
		private var daysRemaining:int;
		
		/**
		 * 
		 * @param	startDate
		 */
		
		public function MapItemDate( startDate:String ) {
			targetDateHere = DateParser.parseAndConvertToLocalTime( startDate ); 
			
			label = getChildAt( 0 ) as TextField;
			daysRemaining = calculateDaysRemaining();
			label.text = getMessage( daysRemaining ).toUpperCase();
			
			mouseChildren = mouseEnabled = false;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getDaysRemaining():int {
			return daysRemaining;
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function calculateDaysRemaining():int {
			var daysRemaining:int = Math.ceil( ( targetDateHere.time - new Date().time ) / 1000 / 60 / 60 / 24 );
			return Math.max( daysRemaining, 0 );
		}
		
		/**
		 * 
		 * @param	days
		 * @return
		 */
		
		private function getMessage( days:int ):String {
			var firstWord:String = "Остал";
			var lastWord:String = "д";
			var daysString:String = days.toString();
			var lastNum:int = int( daysString.charAt( daysString.length - 1 ) );
			var lastTwoNums:int = int( daysString.substr( daysString.length - 2 ) );
			var prelastNum:int = int ( daysString.substr( daysString.length - 2, 1 ) );
			
			if ( lastTwoNums === 11 ) {
				firstWord += "ось";
				lastWord += "ней";
			} else if( lastNum === 1 ) {
				firstWord += "ся";
				lastWord += "ень";
			} else if ( lastNum > 1 && lastNum < 5 && prelastNum !== 1 ) {
				firstWord += "ось";
				lastWord += "ня";
			} else {
				firstWord += "ось";
				lastWord += "ней";
			}
			
			return firstWord + "\n" + days + " " + lastWord;
		}
		
		
	}

}