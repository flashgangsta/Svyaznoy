package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.modules.Voting;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class RightMenu extends Sprite {
		
		private var ANNOUNCEMENT_Y:int = 282;
		private var VOTING_Y:int = 434;
		
		private var provider:Provider = Provider.getInstance();
		private var image:PreviewGallery = new PreviewGallery();
		private var video:PreviewVideo;
		private var helper:Helper = Helper.getInstance();
		private var settings:SettingsData;
		private var announcement:Announcement;
		
		/**
		 * 
		 */
		
		public function RightMenu() {
			video = getChildByName( "video_mc" ) as PreviewVideo;
			
			var imageTemp:PreviewImage = getChildByName( "image_mc" ) as PreviewImage;
			
			image.width = imageTemp.width;
			image.height = imageTemp.height;
			image.x = imageTemp.x;
			image.y = imageTemp.y;
			imageTemp.dispose();
			removeChild( imageTemp );
			imageTemp = null;
			addChild( image );
			
			provider.addEventListener( ProviderEvent.ON_RANDOM_GALLERIES, onRandomGalleries );
			provider.addEventListener( ProviderEvent.ON_RANDOM_VIDEOS, onRandomVideos );
			provider.addEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
		}
		
		/**
		 * 
		 */
		
		public function init():void {
			provider.getRandomSurveys();
			settings = helper.getSettings();
			if ( settings ) {
				onSettings();
			} else {
				provider.addEventListener( ProviderEvent.ON_SETTINGS, onSettings );
			}
		}
		
		/**
		 * 
		 */
		
		public function getAnnouncement():Announcement {
			return announcement;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSettings( event:ProviderEvent = null ):void {
			if ( settings.showAnnouncementNeeded ) {
				provider.addEventListener( ProviderEvent.ON_LAST_ANNOUNCEMENT, onLastAnnouncement );
				provider.getLastAnnouncement();
				provider.getRandomGalleries();
				provider.getRandomVideos();
			} else {
				trace( "!showAnnouncementNeeded" );
				if ( Math.random() > 8) {
					//photo
					trace( "!photo" );
					provider.getRandomGalleries( 2 );
					provider.getRandomVideos();
				} else {
					//video
					provider.getRandomGalleries();
					provider.getRandomVideos( 2 );
				}
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLastAnnouncement( event:ProviderEvent ):void {
			announcement = new Announcement( event.data[ 0 ] );
			announcement.y = ANNOUNCEMENT_Y;
			addChild( announcement );
		}
		
		/**
		 * 
		 * @param	event
		 * event.data содержит массив с галереями, каждый элемент сожержит поля,
		 *
           "id": "3",
           "departure_id": "13",
           "title": "В поисках Магистерия",
           "anonce": "Воздух. Клязьма.",
           "secured": "0",
           "status": "1",
           "created_at": "2013-08-03 10:24:00",
           "updated_at": "2013-08-04 20:10:05",
           "full_title": "В поисках Магистерия",
           "photo_with_path": "http://192.241.136.228/uploads/photos/russia-moskow-2012/1.jpg"
			
		 */
		
		private function onRandomGalleries( event:ProviderEvent ):void {
			var datas:Array = event.data as Array;
			provider.removeEventListener( ProviderEvent.ON_RANDOM_GALLERIES, onRandomGalleries );
			image.displayData( datas[ 0 ] );
			image.removeTextFields();
			
			if ( datas.length > 1 ) {
				var secondGallery:PreviewGallery = new PreviewGallery();
				secondGallery.displayData( datas[ 1 ] );
				secondGallery.removeTextFields();
				secondGallery.y = ANNOUNCEMENT_Y;
				addChild( secondGallery );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRandomVideos( event:ProviderEvent ):void {
			var datas:Array = event.data as Array;
			provider.removeEventListener( ProviderEvent.ON_RANDOM_VIDEOS, onRandomVideos );
			video.displayData( datas[ 0 ] );
			video.removeTextFields();
			video.makeNavigationToVideoReport();
			
			if ( datas.length > 1 ) {
				var secondVideo:PreviewVideo = new PreviewVideo();
				secondVideo.displayData( datas[ 1 ] );
				secondVideo.removeTextFields();
				secondVideo.y = ANNOUNCEMENT_Y;
				addChild( secondVideo );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSurveys( event:ProviderEvent ):void {
			var surveyData:Object = event.data[ 0 ];
			provider.removeEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			var voting:Voting = new Voting();
			voting.y = VOTING_Y;
			voting.init( surveyData );
			
			addChild( voting );
			provider.removeEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
		}
		
	}

}