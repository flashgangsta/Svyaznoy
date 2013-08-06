package com.svyaznoy {
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class RightMenu extends Sprite {
		
		private var provider:Provider = Provider.getInstance();
		private var image:PreviewImage;
		private var video:PreviewVideo;
		
		/**
		 * 
		 */
		
		public function RightMenu() {
			image = getChildByName( "image_mc" ) as PreviewImage;
			video = getChildByName( "video_mc" ) as PreviewVideo;
			
			provider.addEventListener( ProviderEvent.ON_RANDOM_GALLERIES, onRandomGalleries );
			provider.addEventListener( ProviderEvent.ON_RANDOM_VIDEOS, onRandomVideos );
		}
		
		/**
		 * 
		 */
		
		public function init():void {
			provider.getRandomGalleries();
			provider.getRandomVideos();
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
			image.loadImage( event.data[ 0 ].photo_with_path );
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
		
	}

}