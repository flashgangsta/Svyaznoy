package com.svyaznoy {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AchievementsList extends Sprite {
		
		private const COLOUMNS:int = 6;
		private const MARGIN_H:int = 10;
		private const MARGIN_V:int = 5;
		
		private var achievementsDatas:AchievementsData = Helper.getInstance().getSettings().achievements;
		
		public function AchievementsList() {
			
		}
		
		/**
		 * 
		 * @param	list
		 */
		
		public function fill( list:Vector.<Object> ):void {
			var achievement:AchievementsListItem;
			var data:Object;
			
			for ( var i:int = 0; i < list.length; i++ ) {
				data = list[ i ];
				achievement = new AchievementsListItem( data.degree, null, achievementsDatas.getAchievementNameByData( data ), achievementsDatas.getAchievementIconByData( data ) );
				achievement.y = Math.floor( i / COLOUMNS ) * ( achievement.height + MARGIN_V ) ;
				achievement.x = ( i % 6 ) * ( achievement.width + MARGIN_H );
				addChild( achievement );
			}
		}
		
	}

}