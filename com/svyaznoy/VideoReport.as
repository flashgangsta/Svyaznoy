package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.media.video.YoutubePlayer;
	import com.svyaznoy.events.PreviewsTableEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class VideoReport extends ScreenWithTitleAndBottomButton {
		
		private const TITLE_BOTTOM_MARGIN:int = 10;
		private const VIDEO_TITLE_BOTTOM_MARGIN:int = -3;
		private const VIDEO_DESCRIPTION_BOTTOM_MARGIN:int = 7;
		private const PREVIEWS_TOP_MARGIN:int = 15;
		
		private var currentVideoIndex:int = 0;
		private var videosList:Array;
		private var player:YoutubePlayer;
		private var videoTitleLabel:TextField;
		private var videoDescriptionLabel:TextField;
		private var previewsTable:PreviewsTable;
		
		/**
		 * 
		 */
		
		public function VideoReport() {
			player = getChildByName( "player_mc" ) as YoutubePlayer;
			videoTitleLabel = getChildByName( "videoTitleLabel_txt" ) as TextField;
			videoDescriptionLabel = getChildByName( "videoDescriptionLabel_txt" ) as TextField;
			
			videoTitleLabel.autoSize = TextFieldAutoSize.LEFT;
			videoDescriptionLabel.autoSize = TextFieldAutoSize.LEFT;
			
			setVisibleForElements( false );
		}
		
		/**
		 * 
		 * @param	departureData данные о выезде, содержат поля:
			 * id:int
			 * title:String
			 * year:int
			 * start:String
			 * galleries:Array
			 * videos:Array
			 * full_title:String
			 * image_with_path:String
		 */
		
		public function showVideos( departureData:Object ):void {
			if ( data && data.id === departureData.id ) return;
			else clear();
			data = departureData;
			videosList = data.videos;
			removePreloader();
			displayData();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			title.text = data.title + ": ВИДЕООТЧЁТЫ";
			videoTitleLabel.y = MappingManager.getBottom( title, this ) + TITLE_BOTTOM_MARGIN;
			
			initPreviews();
			initVideo( videosList[ currentVideoIndex ] );
			setVisibleForElements( true );
			dispatchHeighUpdated();
		}
		
		private function clear():void {
			if ( previewsTable ) {
				previewsTable.dispose();
			}
		}
		
		/**
		 * 
		 * @param	videoData данные о видео, содержат следующие параметры:
			 * id:int
			 * departure_id:int
			 * title:String
			 * anonce:String
			 * video:String - идентификатор видео
			 * secured:int
			 * status:int
			 * created_at:String
			 * updated_at:String
		 */
		
		private function initVideo( videoData:Object, autoplay:Boolean = false ):void {
			videoTitleLabel.text = videoData.title;
			videoDescriptionLabel.text = videoData.anonce;
			player.stop();
			player.setVideo( videoData.video, autoplay );
			
			videoDescriptionLabel.y = MappingManager.getBottom( videoTitleLabel, this ) + VIDEO_TITLE_BOTTOM_MARGIN;
			player.y = MappingManager.getBottom( videoDescriptionLabel, this ) + VIDEO_DESCRIPTION_BOTTOM_MARGIN;
			
			if ( !previewsTable ) {
				bottomButton.y = MappingManager.getBottom( player, this ) + ScreenWithBottomButton.MARGIN;
			} else {
				previewsTable.y = MappingManager.getBottom( player, this ) + PREVIEWS_TOP_MARGIN;
				bottomButton.y = MappingManager.getBottom( previewsTable, this ) + ScreenWithBottomButton.MARGIN;
			}
		}
		
		/**
		 * 
		 */
		
		private function initPreviews():void {
			
			if ( previewsTable ) {
				previewsTable.dispose();
				removeChild( previewsTable );
			}
			
			if( videosList.length > 1 ) {
				previewsTable = new PreviewsTable();
				previewsTable.fill( videosList, PreviewVideo, currentVideoIndex );
				previewsTable.addEventListener( PreviewsTableEvent.ON_PREVIEW_SELECTED, onPreviewSelected );
				addChild( previewsTable );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPreviewSelected( event:PreviewsTableEvent ):void {
			var previewData:Object = previewsTable.getSelectedItemData()
			currentVideoIndex = videosList.indexOf( previewData );
			previewsTable.refill( currentVideoIndex );
			initVideo( previewData, true );
			dispatchHeighUpdated();
		}
		
	}
}