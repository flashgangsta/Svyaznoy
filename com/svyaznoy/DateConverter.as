package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DateConverter {
		
		static private const MONTHS:Object = {
			m01 : "Января",
			m02 : "Февраля",
			m03 : "Марта",
			m04 : "Апреля",
			m05 : "Мая",
			m06 : "Июня",
			m07 : "Июля",
			m08 : "Августа",
			m09 : "Сентября",
			m10 : "Октября",
			m11 : "Ноября",
			m12 : "Декабря"
		};
		
		public function DateConverter() {
		}
		
		public static function getFormattedDate( date:String ):String {
			var result:String = date.substr( 8 ) + " ";
			var monthNum:String = date.substr( 5, 2 );
			result += MONTHS[ "m" + monthNum ] + " " + date.substr( 0, 4 );
			return result;
		}
		
		public static function getFormattedDateAndTimeInNumbers( date:String ):String {
			var result:String = date.substr( 8, 2 ) + ".";
			result += date.substr( 5, 2 ) + ".";
			result += date.substr( 0, 4 ) + " ";
			result += date.substr( 11 );
			return result;
		}
		
	}

}