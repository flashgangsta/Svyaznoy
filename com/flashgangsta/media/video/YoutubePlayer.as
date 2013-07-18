package com.flashgangsta.media.video {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.events.YoutubePlayerEvent;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.PlayerControllBar;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @link https://developers.google.com/youtube/flash_api_reference?hl=ru
	 */
	
	public class YoutubePlayer extends Sprite {
		
		static private const PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		static private const LOGO_RT_MARGIN:int = 8;
		static private const LOGO_WIDTH_MIN:int = 250;
		static private const LOGO_WIDTH_MAX:int = 480;
		static private const LOGO_HEIGHT_MIN:int = 180;
		static private const LOGO_HEIGHT_MAX:int = 360;
		static private const LOGO_WIDTH_DIFFERENCE:int = LOGO_WIDTH_MAX - LOGO_WIDTH_MIN;
		static private const LOGO_HEIGHT_DIFFERENCE:int = LOGO_HEIGHT_MAX - LOGO_HEIGHT_MIN;
		
		
		private var player:YoutubePlayerInstance;
		private var loader:Loader = new Loader();
		private var background:Shape;
		private var mouseListenerRect:Sprite = new Sprite();
		private var logo:Shape = new Shape();
		private var controllBar:PlayerControllBar;
		
		/**
		 * 
		 */
		
		public function YoutubePlayer() {
			background = getChildAt( 0 ) as Shape;
			loader.contentLoaderInfo.addEventListener( Event.INIT, onPlayerInit );
			loader.load( new URLRequest( PLAYER_URL ) );
			
			mouseListenerRect.addEventListener( MouseEvent.CLICK, onVideoClicked );
			
			logo.graphics.beginFill( 0 );
			logo.graphics.drawRect( 0, 0, 80, 31 );
			logo.graphics.endFill();
			logo.visible = false;
			
			setLogoRectSize();
			
			addChild( logo );
			
			controllBar = getChildByName( "controllBar_mc" ) as PlayerControllBar;
			controllBar.addEventListener( MediaControllerEvent.PLAY_OR_PAUSE_CLICKED, onPlayOrPauseClicked );
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return background.width;
		}
		
		override public function set width( value:Number ):void {
			background.width = value;
			
			if ( width < LOGO_WIDTH_MAX && width > LOGO_WIDTH_MIN ) {
				var multipler:Number =  width / LOGO_WIDTH_DIFFERENCE;
				logo.width = Math.floor( 40 * multipler );
				
			}
			
			setLogoRectSize();
			
			if ( player ) player.setSize( width, height );
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return background.height;
		}
		
		override public function set height(value:Number):void {
			background.height = value;
			
			if ( height < LOGO_HEIGHT_MAX && height > LOGO_HEIGHT_MIN ) {
				var multipler:Number = height / LOGO_HEIGHT_DIFFERENCE;
				logo.height = Math.floor( 15 * multipler );
			}
			
			setLogoRectSize();
			
			if ( player ) player.setSize( width, height );
		}
		
		/**
		 * 
		 */
		
		private function setLogoRectSize():void {
			logo.x = width - logo.width - LOGO_RT_MARGIN;
			logo.y = height - logo.height - LOGO_RT_MARGIN;
			logo.scaleX = logo.scaleY = Math.min( logo.scaleX, logo.scaleY );
			drawMouseListenerRect();
		}
		
		/**
		 * 
		 */
		
		private function drawMouseListenerRect():void {
			var graphics:Graphics = mouseListenerRect.graphics;
			graphics.clear();
			graphics.beginFill( 0, 0 );
			graphics.moveTo( 0, 0 );
			graphics.lineTo( width, 0 );
			graphics.lineTo( width, height );
			graphics.lineTo( width - LOGO_RT_MARGIN, height );
			graphics.lineTo( width - LOGO_RT_MARGIN, height - LOGO_RT_MARGIN - logo.height );
			graphics.lineTo( width - LOGO_RT_MARGIN - logo.width, height - LOGO_RT_MARGIN - logo.height );
			graphics.lineTo( width - LOGO_RT_MARGIN - logo.width, height - LOGO_RT_MARGIN );
			graphics.lineTo( width - LOGO_RT_MARGIN, height - LOGO_RT_MARGIN );
			graphics.lineTo( width - LOGO_RT_MARGIN, height );
			graphics.lineTo( 0, height );
			graphics.lineTo( 0, 0 );
			graphics.endFill();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerInit( event:Event ):void {
			player = new YoutubePlayerInstance( loader.content );
			player.addEventListener( YoutubePlayerEvent.ON_READY, onPlayerReady );
			player.addEventListener( YoutubePlayerEvent.ON_ERROR, onPlayerError );
			player.addEventListener( YoutubePlayerEvent.ON_STATE_CHANGE, onPlayerStateChange );
			player.addEventListener( YoutubePlayerEvent.ON_PLAYBACK_QUALITY_CHANGE, onVideoPlaybackQualityChange );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerReady( event:Event ):void {
			// Event.data contains the event parameter, which is the Player API ID 
			trace( "Player is ready" );
			
			/*Once this event has been dispatched by the player, we can use
			cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			to load a particular YouTube video.*/
			
			player.removeEventListener( YoutubePlayerEvent.ON_READY, onPlayerReady );
			addChild( player.getPlayer() );
			addChild( logo );
			
			player.setSize( background.width, background.height );
			player.cueVideoById( "4VK0DQhCIuU" /*"fKN6P6xzbPc"*/ );
			
			//player.cueVideoByUrl( "http://www.youtube.com/v/Uon2WYPfdgc" );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerError( event:Event ):void {
			// Event.data contains the event parameter, which is the error code
			var error:String = Object( event ).data;
			trace( "player error:", error );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerStateChange( event:Event ):void {
			// Event.data contains the event parameter, which is the new player state
			var state:int = Object( event ).data;
			trace( "player state:", state );
			
			switch( state ) {
				case YoutubePlayerInstance.STATE_PLAYING:
					addChildAt( mouseListenerRect, getChildIndex( player.getPlayer() ) + 1 );
					controllBar.dispatchEvent( new MediaControllerEvent( MediaControllerEvent.PLAYING_STARTED ) );
					break;
				case YoutubePlayerInstance.STATE_PLAYING_COMPLETED:
					controllBar.dispatchEvent( new MediaControllerEvent( MediaControllerEvent.PLAYING_COMPLETE ) );
					break;
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideoPlaybackQualityChange( event:Event ):void {
			// Event.data contains the event parameter, which is the new video quality
			var quality:String = Object( event ).data;
			trace( "video quality:", quality );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideoClicked( event:MouseEvent ):void {
			togglePlaying();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayOrPauseClicked( event:MediaControllerEvent ):void {
			trace( "youtubePlayer" );
			event.stopImmediatePropagation();
			togglePlaying();
		}
		
		/**
		 * 
		 */
		
		private function togglePlaying():void {
			switch( player.getPlayerState() ) {
				case YoutubePlayerInstance.STATE_PLAYING :
					player.pauseVideo();
					break;
				case YoutubePlayerInstance.STATE_PAUSED:
				case YoutubePlayerInstance.STATE_PLAYING_COMPLETED:
				case YoutubePlayerInstance.STATE_NOT_STARTED:
					player.playVideo();
					break;
				
			}
		}
		
		
		
	}

}