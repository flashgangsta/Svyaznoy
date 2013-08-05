package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.svyaznoy.events.MapEvent;
	import com.svyaznoy.events.MapItemEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapItem extends Sprite {
		
		private const COUNTRY_TRANSITION:String = "Cubic";
		private const SHAPES_TRANSITION:String = "Back";
		
		private const COUNTRY_OUT_COLOR:uint = 0x539FFD;
		private const COUNTRY_OVER_COLOR:uint = 0xb4d88b;
		private const COUNTRY_TIME_OVER:Number = .4;
		private const COUNTRY_TIME_OUT:Number = .3;
		
		private const SHAPES_SCALE:Number = 1.25;
		private const SHAPES_TIME_OVER:Number = .4;
		private const SHAPES_TIME_OUT:Number = .6;
		
		private var photosButton:Button;
		private var videosButton:Button;
		private var country:DisplayObject;
		private var shapes:Sprite;
		private var data:Object;
		private var dispatcher:Dispatcher = Dispatcher.getInstance();
		
		private var countryOverParameters:Object = {
				_saturation: 3,
				time: COUNTRY_TIME_OVER,
				transition: "easeInOut" + COUNTRY_TRANSITION
			};
			
		private var countryOutParameters:Object = {
				_saturation: 1,
				time: COUNTRY_TIME_OUT,
				transition: "easeInOut" + COUNTRY_TRANSITION
			};
		
		private var shapesOverParameters:Object = {
				scaleX: SHAPES_SCALE,
				scaleY: SHAPES_SCALE,
				time: SHAPES_TIME_OVER,
				transition: "easeInOut" + SHAPES_TRANSITION,
				onComplete: onOverMotionComplete
			};
			
		private var shapesOutParameters:Object = {
				scaleX: 1,
				scaleY: 1,
				time: SHAPES_TIME_OUT,
				transition: "easeInOut" + SHAPES_TRANSITION
			};
		
		
		/**
		 * 
		 */
		
		public function MapItem() {
			shapes = getChildByName( "shapes_mc" ) as Sprite;
			photosButton = shapes.getChildByName( "photos_mc" ) as Button;
			videosButton = shapes.getChildByName( "videos_mc" ) as Button;
			photosButton.visible = false;
			videosButton.visible = false;
		}
		
		/**
		 * 
		 * @param	country
		 */
		
		public function init( country:DisplayObject, data:Object ):void {
			this.country = country;
			this.data = data;
			
			if ( data.galleries.length ) {
				photosButton.visible = true;
				photosButton.addEventListener( MouseEvent.CLICK, onPhotosClicked );
			}
			
			if ( data.videos.length ) {
				videosButton.visible = true;
				videosButton.addEventListener( MouseEvent.CLICK, onVideosClicked );
			}
			
			trace( ">>>", data.start );
			
			if( !data.start ) {
				addEventListener( MouseEvent.MOUSE_OVER, onRollOver );
			}
		}
		
		/**
		 * СТрана инициатора вызова метода, нужно для определения необходимости анимации страны (если страны у объектов одинаковы, анимация не нужна)
		 * @param	dispatcherCountry
		 */
		
		public function resetToDefaultState( dispatcherCountry:DisplayObject ):void {
			onRollOut( null, false, dispatcherCountry === country );
		}
		
		/**
		 * 
		 */
		
		public function getCountry():DisplayObject {
			return country;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRollOver( event:MouseEvent ):void {
			if ( event ) event.stopImmediatePropagation();
			removeEventListener( MouseEvent.MOUSE_OVER, onRollOver );
			if( country ) Tweener.addTween( country, countryOverParameters );
			Tweener.addTween( shapes, shapesOverParameters );
			dispatchEvent( new MapEvent( MapEvent.COUNTRY_MOUSE_OVER, true ) );
		}
		
		/**
		 * 
		 * @param	event
		 * @param	dispatchIt нужно ли диспетчить событие
		 * @param	counryAnimationNeeded нужна ли анимация страны 
		 */
		
		private function onRollOut( event:MouseEvent = null, dispatchIt:Boolean = true, counryAnimationNeeded:Boolean = false ):void {
			if ( event ) event.stopImmediatePropagation();
			
			if ( hasEventListener( MouseEvent.MOUSE_OUT ) ) {
				removeEventListener( MouseEvent.MOUSE_OUT, onRollOut );
			}
			
			if ( !hasEventListener( MouseEvent.MOUSE_OVER ) ) {
				addEventListener( MouseEvent.MOUSE_OVER, onRollOver );
			}
			
			if ( country && !counryAnimationNeeded ) {
				Tweener.addTween( country, countryOutParameters );
			}
			Tweener.addTween( shapes, shapesOutParameters );
			
			if( dispatchIt ) dispatchEvent( new MapEvent( MapEvent.COUNTRY_MOUSE_OUT, true ) );
		}
		
		/**
		 * 
		 */
		
		private function onOverMotionComplete():void {
			if ( !stage ) return;
			if ( this.hitTestPoint( stage.mouseX, stage.mouseY, true ) ) {
				addEventListener( MouseEvent.MOUSE_OUT, onRollOut );
			} else {
				onRollOut( null );
			}
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPhotosClicked( event:MouseEvent ):void {
			var outputEvent:MapItemEvent = new MapItemEvent( MapItemEvent.PHOTO_REPORTS_CLICKED );
			outputEvent.itemData = data;
			dispatcher.dispatchEvent( outputEvent );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideosClicked( event:MouseEvent ):void {
			var outputEvent:MapItemEvent = new MapItemEvent( MapItemEvent.VIDEO_REPORTS_CLICKED );
			outputEvent.itemData = data;
			dispatcher.dispatchEvent( outputEvent );
		}
		
	}

}