package com.svyaznoy.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DateParser {
		
		public function DateParser() {
			
		}
		
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
		
	}

}