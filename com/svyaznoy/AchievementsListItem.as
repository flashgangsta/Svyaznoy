package com.svyaznoy {
	import com.flashgangsta.ui.Label;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AchievementsListItem extends IconListItem {
		
		public function AchievementsListItem( quantiry:int, titleMessage:String = null, signMessage:String = null, imagePath:String = null, vkIDForAvatarLoad:int = 0 ) {
			super( titleMessage, signMessage, imagePath, vkIDForAvatarLoad );
			if ( quantiry > 1 ) {
				var multiplerLabel:Label = new AchievementMultiplerLabel();
				multiplerLabel.text = "x" + quantiry;
				addChild( multiplerLabel );
				multiplerLabel.x = Math.round( (width / 2) +  (signLabel.textWidth / 2) + 4 );
				multiplerLabel.y = Math.round( signLabel.y - 5 );
			}
		}
		
		override public function get width():Number {
			return imageArea.width;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
		}
		
	}

}