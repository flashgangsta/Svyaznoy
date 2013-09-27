package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ProviderEvent extends Event {
		
		static public const ON_LOGGED_IN:String = "onLoggedIn";
		static public const ON_EMPLOYEE_SET:String = "onEmployeeSet";
		static public const ON_EMPLOYEE_CONFIRMED:String = "onEmployeeConfirmed";
		static public const ON_INTRO_DATA:String = "onIntroData";
		static public const ON_NEWS_LIST:String = "onNewsList";
		static public const ON_NEWS_DETAIL:String = "onNewsDetail";
		static public const ON_LOAD_START:String = "onLoadStart";
		static public const ON_LEGEND:String = "onLegend";
		static public const ON_ABOUT:String = "onAbout";
		static public const ON_THERMS_OF_MOTIVATION:String = "onThermsOfMotivation";
		static public const ON_DEPARTURES_LIST:String = "onDeparturesList";
		static public const ON_RANDOM_GALLERIES:String = "onRandomGalleries";
		static public const ON_RANDOM_VIDEOS:String = "onRandomVideos";
		static public const ON_LAST_GALLERIES:String = "onLastGalleries";
		static public const ON_LAST_VIDEOS:String = "onLastVideos";
		static public const ON_VIDEO_REPORT:String = "onVideoReport";
		static public const ON_DEPARTURE:String = "onDeparture";
		static public const ON_GALLERY_PHOTOS:String = "onGalleryPhotos";
		static public const ON_RANDOM_SURVEYS:String = "onRandomSurveys";
		static public const ON_LOTTERIES:String = "onLotteries";
		static public const ON_LOTTERY:String = "onLottery";
		static public const ON_EMPLOYEE_DATA:String = "onEmployeeData";
		static public const ON_RATINGS:String = "onRatings";
		static public const ON_RATINGS_SEARCHED:String = "onRatingsSearched";
		static public const ON_EMPLOYEES_LENGTH:String = "onEmployeesLength";
		static public const ON_OWNER_RATING:String = "onOwnerRating";
		static public const ON_ANSWER_SENT:String = "onAnswerSent";
		static public const ON_ANSWERS:String = "onAnswers";
		static public const ON_OWNER_ALBUMS:String = "onOwnerAlbums";
		static public const ON_PHOTO_UPLOADED:String = "onPhotoUploaded";
		static public const ON_PHOTO_UPDATED:String = "onPhotoUpdated";
		static public const ON_PHOTO_DELETED:String = "onPhotoDeleted";
		static public const ON_EMPLOYEES_PHOTOS:String = "onEmployeesPhotos";
		static public const ON_SETTINGS:String = "onSettings";
		static public const ON_LAST_ANNOUNCEMENT:String = "onLastAnnouncement";
		static public const ON_ANNOUNCEMENT:String = "onAnnouncement";
		static public const ON_COMMENTS_LIST:String = "onCommentsList";
		static public const ON_COMMENTS_COUNT:String = "onCommentsCount";
		static public const ON_COMMENT_ADDED:String = "onCommentAdded";
		static public const ON_TESTS_LIST:String = "onTestsList";
		static public const ON_TEST:String = "onTest";
		static public const ON_TEST_RESULT_SENT:String = "onTestResultSent";
		static public const ON_MY_ACHIEVEMENTS:String = "onMyAchievements";
		static public const ON_ENTRY_BY_INVITE_CONFIRMED:String = "onEntryByInviteConfirmed";
		static public const ON_LAST_SEEN_ACHIEVEMENT_SET:String = "onLastSeenAchievementSet";
		static public const ON_CONTESTS_LIST:String = "onContestsList";
		static public const ON_CONTEST_WORKS_LIST:String = "onContestWorksList";
		static public const ON_CONTEST:String = "onContest";
		static public const ON_PHOTO_UPLOADED_TO_CONTEST:String = "onPhotoUploadedToContest";
		static public const ON_STORY_ADDED:String = "onStoryAdded";
		
		public var data:Object;
		
		public function ProviderEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new ProviderEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "ProviderEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}