package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.events.PreviewEvent;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class PreviewImage extends PreviewItem {
		
		private const BACKGROUND_BOTTOM_MARGIN:int = 2;
		private const TITLE_BOTTOM_MARGIN:int = -2;
		
		private var zoomIcon:MovieClip;
		private var titleLabel:TextField;
		private var descriptionLabel:TextField;
		private var background:Sprite;
		private var preloader:MovieClip;
		private var loader:ContentLoader = new ContentLoader();
		private var bitmap:Bitmap;
		private var zoomIcoRectDefault:Rectangle;
		private var zoomIcoRectOver:Rectangle = new Rectangle( 0, 0, 44, 44 );
		
		/**
		 * 
		 */
		
		public function PreviewImage() {
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			descriptionLabel = getChildByName( "descriptionLabel_txt" ) as TextField;
			background = getChildByName( "background_mc" ) as Sprite;
			preloader = getChildByName( "prelaoder_mc" ) as MovieClip;
			zoomIcon = getChildByName( "zoomIcon_mc" ) as MovieClip;
			
			preloader.gotoAndPlay( int( Math.random() * preloader.totalFrames ) );
			
			zoomIcon.stop();
			zoomIcon.visible = false;
			zoomIcoRectDefault = zoomIcon.getBounds( this );
			updateZoomIconRectangle();
			
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			descriptionLabel.autoSize = TextFieldAutoSize.LEFT;
			
			title = "";
			description = "";
			
			width = super.width;
			height = super.height;
			
			scaleX = scaleY = 1;
			
			addEventListener( MouseEvent.ROLL_OVER, onMouseOver );
			addEventListener( MouseEvent.ROLL_OUT, onMouseOut );
		}
		
		/**
		 * 
		 * @param	src
		 */
		
		public function loadImage( src:String ):void {
			loader.close();
			loader.load( src );
			if ( !loader.hasEventListener( Event.COMPLETE ) ) {
				loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.addEventListener( Event.COMPLETE, onLoaded );
			}
		}
		
		/**
		 * 
		 */
		
		public function removePreloader():void {
			if ( !preloader ) return;
			preloader.stop();
			removeChild( preloader );
			preloader = null;
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return background.width;
		}
		
		override public function set width( value:Number ):void {
			background.width = value;
			titleLabel.width = descriptionLabel.width = value;
			setPositions();
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return background.height;
		}
		
		override public function set height( value:Number ):void {
			background.height = value;
			setPositions();
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			loader.close();
			if ( bitmap ) {
				bitmap.mask = null;
				bitmap.loaderInfo.loader.unloadAndStop();
				bitmap.bitmapData.dispose();
				removeChild( bitmap );
				bitmap = null;
			}
			loader = null;
			removePreloader();
			
			removeEventListener( MouseEvent.ROLL_OVER, onMouseOver );
			removeEventListener( MouseEvent.ROLL_OUT, onMouseOut );
		}
		
		/**
		 * 
		 */
		
		public function get title():String {
			return titleLabel.text;
		}
		
		public function set title( value:String ):void {
			titleLabel.text = value.replace( /\\n/g, "\n" );
			titleLabel.visible = Boolean( value );
			setPositions();
		}
		
		/**
		 * 
		 */
		
		public function get description():String {
			return descriptionLabel.text;
		}
		
		public function set description( value:String ):void {
			descriptionLabel.text = value.replace( /\\n/g, "\n" );
			descriptionLabel.visible = Boolean( value );
			setPositions();
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		override public function displayData( data:Object ):void {
			super.displayData( data );
		}
		
		/**
		 * 
		 */
		
		public function removeTextFields():void {
			title = "";
			description = "";
			titleLabel.visible = descriptionLabel.visible = false;
			descriptionLabel.y = titleLabel.y = 0;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getZoomIcon():MovieClip {
			return zoomIcon;
		}
		
		/**
		 * 
		 */
		
		public function getBitmap():Bitmap {
			return bitmap;
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			if ( titleLabel.visible ) {
				titleLabel.y = MappingManager.getBottom( background, this ) + BACKGROUND_BOTTOM_MARGIN;
			} else {
				titleLabel.y = 0;
			}
			
			if ( descriptionLabel.visible && titleLabel.visible ) {
				descriptionLabel.y = MappingManager.getBottom( titleLabel, this ) + TITLE_BOTTOM_MARGIN;
			} else if ( descriptionLabel.visible ) {
				descriptionLabel.y = MappingManager.getBottom( background, this ) + BACKGROUND_BOTTOM_MARGIN;
			}
			
			if ( preloader ) {
				MappingManager.setAlign( preloader, background.getBounds( this ) );
			}
			
			if ( zoomIcon.visible ) {
				zoomIcoRectDefault.y = height - zoomIcoRectDefault.height - zoomIcoRectDefault.x;
				if ( !Tweener.isTweening( zoomIcon ) ) {
					zoomIcon.y = zoomIcoRectDefault.y;
				}
				updateZoomIconRectangle();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			bitmap = loader.getContent() as Bitmap;
			bitmap.smoothing = true;
			MappingManager.setScaleFillArea( bitmap, background.getBounds( this ) );
			bitmap.x = MappingManager.getCentricPoint( background.width, bitmap.width );
			bitmap.mask = background;
			addChildAt( bitmap, 0 );
			removePreloader();
			removeListeners();
			dispatchEvent( new PreviewEvent( PreviewEvent.ON_PREVIEW_LOADED, true ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			Errors.getInstance().previewImageLoadError( event );
			removePreloader();
			removeListeners();
		}
		/**
		 * 
		 */
		
		private function removeListeners():void {
			loader.removeEventListener( IOErrorEvent.IO_ERROR, Errors.getInstance().previewImageLoadError );
			loader.removeEventListener( Event.COMPLETE, onLoaded );
		}
		
		/**
		 * 
		 */
		
		private function updateZoomIconRectangle():void {
			zoomIcoRectOver.x = MappingManager.getCentricPoint( this.width, zoomIcoRectOver.width );
			zoomIcoRectOver.y = MappingManager.getCentricPoint( this.height, zoomIcoRectOver.height );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseOver( event:MouseEvent ):void {
			Tweener.addTween( zoomIcon, { x: zoomIcoRectOver.x, y: zoomIcoRectOver.y, width: zoomIcoRectOver.width, height: zoomIcoRectOver.height, alpha: .75, time: .4, transition: "easeInOutCubic" } );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseOut( event:MouseEvent ):void {
			Tweener.addTween( zoomIcon, { x: zoomIcoRectDefault.x, y: zoomIcoRectDefault.y, width: zoomIcoRectDefault.width, height: zoomIcoRectDefault.height, alpha: 1, time: .4, transition: "easeInOutCubic" } );
		}
	}

}