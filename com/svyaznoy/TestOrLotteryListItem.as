package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestOrLotteryListItem extends ContestSectionListItem {
		
		public function TestOrLotteryListItem( data:Object ) {
			super( data );
			titleLabel.text = String( data.title ).toUpperCase();
		}
		
	}

}