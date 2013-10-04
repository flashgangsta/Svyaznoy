package com.svyaznoy {
	import com.svyaznoy.gui.LabelWithIcon;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class BonusesListItem extends Sprite {
		
		private var label:TextField;
		private var stars:LabelWithIcon;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function BonusesListItem( data:Object ) {
			label = getChildByName( "label_txt" ) as TextField;
			stars = getChildByName( "totalStars_mc" ) as LabelWithIcon;
			
			label.text = data.title;
			stars.value = data.value;
		}
		
	}

}