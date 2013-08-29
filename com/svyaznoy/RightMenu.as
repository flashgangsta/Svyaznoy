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
		
		private var provider:Provider = Provider.getInstance();
		private var image:PreviewGallery = new PreviewGallery();
		private var video:PreviewVideo;
		
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
			provider.getRandomGalleries();
			provider.getRandomVideos();
			provider.getRandomSurveys();
		}
		
		/**
		 * 
		 * @param	event
		 * event.data сожержит массив с галереями, каждый элемент сожержит поля,
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
			provider.removeEventListener( ProviderEvent.ON_RANDOM_GALLERIES, onRandomGalleries );
			image.displayData( event.data[ 0 ] );
			image.removeTextFields();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRandomVideos( event:ProviderEvent ):void {
			provider.removeEventListener( ProviderEvent.ON_RANDOM_VIDEOS, onRandomVideos );
			video.displayData( event.data[ 0 ] );
			video.removeTextFields();
			video.makeNavigationToVideoReport();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSurveys( event:ProviderEvent ):void {
			var surveyData:Object = event.data[ 0 ];
			provider.removeEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			var voting:Voting = new Voting();
			voting.y = MappingManager.getBottom( video, this ) + ( video.y - MappingManager.getBottom( image, this ) );
			voting.init( surveyData );
			
			addChild( voting );
			provider.removeEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
		}
		
	}

}