package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.PreviewEvent;
	import com.svyaznoy.gui.Button;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class PreviewVideo extends PreviewItemWithImage {
		
		static const KEY_FOR_REPLACE:String = "%VIDEO_ID%";
		static const VIDEO_INFO_ADRESS:String = "http://gdata.youtube.com/feeds/api/videos/" + KEY_FOR_REPLACE + "?v=2&alt=jsonc";
		static const VIDEO_THUMBNAIL_ADRESS:String = "http://i1.ytimg.com/vi/" + KEY_FOR_REPLACE + "/mqdefault.jpg";
		
		private var playButton:Button;
		private var clock:TimePreview;
		
		/**
		 * 
		 */
		
		public function PreviewVideo() {
			playButton = getChildByName( "playButton_mc" ) as Button;
			clock = getChildByName( "clock_mc" ) as TimePreview;
			
			clock.mouseChildren = clock.mouseEnabled = false;
			clock.visible = false;
			
			width = super.width;
			height = super.height;
			
			scaleX = scaleY = 1;
			
			previewImage.removePreloader();
			
			setElementsPositions();
			
			ButtonManager.addButton( playButton, this );
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return previewImage.width;
		}
		
		override public function set width(value:Number):void {
			previewImage.width = value;
			setElementsPositions();
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return previewImage.height;
		}
		
		override public function set height(value:Number):void {
			previewImage.height = value;
			setElementsPositions();
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		override public function displayData( data:Object ):void {
			if ( !data ) {
				visible = false;
				return;
			}
			this.data = data;
			if ( isLinkToReport ) buttonMode = true;
			previewImage.loadImage( VIDEO_THUMBNAIL_ADRESS.replace( KEY_FOR_REPLACE, data.video ) );
			previewImage.title = data.title;
			previewImage.description = data.anonce;
			loadVideoInfo();
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			previewImage.dispose();
			playButton.dispose();
			previewImage = null;
			playButton = null;
		}
		
		/**
		 * 
		 */
		
		public function removeTextFields():void {
			previewImage.removeTextFields();
		}
		
		/**
		 * 
		 */
		
		public function makeNavigationToVideoReport():void {
			isLinkToReport = true;
			if ( !data ) buttonMode = false;
			addEventListener( MouseEvent.CLICK, onClicked );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClicked( event:MouseEvent ):void {
			if ( !data ) return;
			var outputEvent:PreviewEvent = new PreviewEvent( PreviewEvent.ON_VIDEO_REPORT_CALLED );
			outputEvent.previewData = getData();
			Dispatcher.getInstance().dispatchEvent( outputEvent );
		}
		
		/**
		 * 
		 */
		
		private function loadVideoInfo():void {
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest( VIDEO_INFO_ADRESS.replace( KEY_FOR_REPLACE, data.video ) );
			loader.addEventListener( Event.COMPLETE, onVideoInfo );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onVideoInfoIOError );
			loader.load( request );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideoInfo( event:Event ):void {
			var loader:URLLoader = event.currentTarget as URLLoader;
			var info:Object = JSON.parse( loader.data ).data;
			clock.setDurationBySeconds( info.duration );
			clock.visible = true;
			removeListeners( loader );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideoInfoIOError( event:IOErrorEvent ):void {
			var loader:URLLoader = event.currentTarget as URLLoader;
			Errors.getInstance().videoInfoLoadError( event );
			removeListeners( loader );
		}
		
		/**
		 * 
		 * @param	loader
		 */
		
		private function removeListeners( loader:URLLoader ):void {
			loader.addEventListener( Event.COMPLETE, onVideoInfo ); 
			loader.addEventListener( IOErrorEvent.IO_ERROR, onVideoInfoIOError );
			loader = null;
		}
		
		/**
		 * 
		 */
		
		private function setElementsPositions():void {
			MappingManager.setAlign( playButton, new Rectangle( 0, 0, previewImage.width, previewImage.height ) );
			clock.y = previewImage.height - clock.height - clock.x;
		}
		
	}

}