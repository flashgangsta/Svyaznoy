package com.svyaznoy {
	import com.flashgangsta.ui.Label;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapItemDate extends Sprite {
		
		private const MOSCOW_TIMEZONE_OFFSET:Number = -240;
		private const MILLISECONDS_MULTIPLER:Number = 60 * 1000;
		private var label:TextField;
		private var targetDateInMoscow:Date;
		private var targetDateHere:Date;
		private var thisTimezoneOffset:Number;
		private var timeOffset:Number;
		private var daysRemaining:int;
		
		/**
		 * 
		 * @param	startDate
		 */
		
		public function MapItemDate( startDate:String ) {
			targetDateInMoscow = new Date( startDate.substr( 0, 4 ), int( startDate.substr( 5, 2 ) ) - 1, startDate.substr( 8 ) );
			thisTimezoneOffset = targetDateInMoscow.timezoneOffset;
			timeOffset = ( thisTimezoneOffset - MOSCOW_TIMEZONE_OFFSET ) * MILLISECONDS_MULTIPLER;
			targetDateHere = new Date( targetDateInMoscow.time - timeOffset );
			
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