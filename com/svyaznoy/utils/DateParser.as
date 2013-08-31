package com.svyaznoy.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DateParser {
		
		static private const MOSCOW_TIMEZONE_OFFSET:Number = -240;
		static private const MILLISECONDS_MULTIPLER:Number = 60 * 1000;
		static private const MONTHS:Array = [ "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря" ];
		
		/**
		 * 
		 */
		
		public function DateParser() {
			
		}
		
		/**
		 * 
		 * @param	dateString
		 * @return
		 */
		
		static public function parse( dateString:String ):Date {
			var result:Date;
			var year:String = dateString.substr( 0, 4 );
			var month:String = ( int( dateString.substr( 5, 2 ) ) - 1 ).toString();
			var day:String = dateString.substr( 8, 2 );
			var hour:String = "0";
			var min:String = "0";
			var sec:String = "0";
			
			if ( dateString.length > 10 ) {
				hour = dateString.substr( 11, 2 );
				min = dateString.substr( 14, 2 );
				sec = dateString.substr( 17, 2 );
			}
			
			result = new Date( year, month, day, hour, min, sec );
			
			return result;
		}
		
		/**
		 * 
		 * @param	dateString
		 * @return
		 */
		
		static public function parseAndConcertToLocalTime( dateString:String ):Date {
			var targetDateInMoscow:Date;
			var thisTimezoneOffset:Number;
			var timeOffset:Number;
			
			targetDateInMoscow = DateParser.parse( dateString );
			thisTimezoneOffset = targetDateInMoscow.timezoneOffset;
			timeOffset = ( thisTimezoneOffset - MOSCOW_TIMEZONE_OFFSET ) * MILLISECONDS_MULTIPLER;
			
			return new Date( targetDateInMoscow.time - timeOffset );
		}
		
		/**
		 * 
		 * @param	month
		 * @return
		 */
		
		static public function getMonthNameByNum( month:int ):String {
			return MONTHS[ month ];
		}
		
	}

}