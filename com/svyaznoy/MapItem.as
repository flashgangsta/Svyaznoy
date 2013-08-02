package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.svyaznoy.events.MapEvent;
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
		private const COUNTRY_OVER_COLOR:uint = 0xffde6c;
		private const COUNTRY_TIME_OVER:Number = .4;
		private const COUNTRY_TIME_OUT:Number = .7;
		
		private const SHAPES_SCALE:Number = 1.25;
		private const SHAPES_TIME_OVER:Number = .4;
		private const SHAPES_TIME_OUT:Number = .6;
		
		private var photosButton:Button;
		private var videosButton:Button;
		private var country:DisplayObject;
		private var shapes:Sprite;
		
		private var countryOverParameters:Object = {
				_color: COUNTRY_OVER_COLOR,
				time: COUNTRY_TIME_OVER,
				transition: "easeInOut" + COUNTRY_TRANSITION
			};
			
		private var countryOutParameters:Object = {
				_color: COUNTRY_OUT_COLOR,
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
			addEventListener( MouseEvent.MOUSE_OVER, onRollOver );
		}
		
		/**
		 * 
		 * @param	country
		 */
		
		public function init( country:DisplayObject ):void {
			this.country = country;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRollOver( event:MouseEvent ):void {
			removeEventListener( MouseEvent.MOUSE_OVER, onRollOver );
			if( country ) Tweener.addTween( country, countryOverParameters );
			Tweener.addTween( shapes, shapesOverParameters );
			dispatchEvent( new MapEvent( MapEvent.COUNTRY_MOUSE_OVER, true ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRollOut( event:MouseEvent = null ):void {
			if ( hasEventListener( MouseEvent.MOUSE_OUT ) ) {
				removeEventListener( MouseEvent.MOUSE_OUT, onRollOut );
			}
			if ( !hasEventListener( MouseEvent.MOUSE_OVER ) ) {
				addEventListener( MouseEvent.MOUSE_OVER, onRollOver );
			}
			if( country ) Tweener.addTween( country, countryOutParameters );
			Tweener.addTween( shapes, shapesOutParameters );
			dispatchEvent( new MapEvent( MapEvent.COUNTRY_MOUSE_OUT, true ) );
		}
		
		/**
		 * 
		 */
		
		private function onOverMotionComplete():void {
			if ( this.hitTestPoint( stage.mouseX, stage.mouseY, true ) ) {
				addEventListener( MouseEvent.MOUSE_OUT, onRollOut );
			} else {
				onRollOut( null );
			}
			
		}
		
	}

}