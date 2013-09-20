package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AchievementsData {
		private var data:Object;
		
		public function AchievementsData( data:Object ) {
			this.data = data;
		}
		
		/*{
			"id": "3",
			"employee_id": "2",
			"type": "comments",
			"level": "silver",
			"degree": "1",
			"created_at": "2013-09-20 18:31:51",
			"updated_at": "2013-09-20 18:32:25"
        }*/
		
		/**
		 * 
		 * @return
		 */
		
		public function getAchievementIconByData( achievementData:Object ):String {
			return data[ achievementData.type + "_" + achievementData.level + "_icon" ];
		}
		
		/**
		 * 
		 * @param	achievementData
		 * @return
		 */
		
		public function getAchievementNameByData( achievementData:Object ):String {
			return data[ achievementData.type + "_" + achievementData.level + "_title" ];
		}
		
	}

}