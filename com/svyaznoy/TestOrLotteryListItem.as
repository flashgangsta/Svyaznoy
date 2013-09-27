package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestOrLotteryListItem extends ContestSectionListItem {
		
		public function TestOrLotteryListItem( data:Object, isTest:Boolean = false ) {
			super( data );
			
			titleLabel.text = ( isTest ? "ТЕСТ: " : "ЛОТЕРЕЯ: " ) + String( data.title ).toUpperCase();
		}
		
	}

}