package com.flashgangsta.ui {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.05	14/03/2013
	 */
	
	public class TouchScreenScroll extends Sprite {
		
		static public const TYPE_VERTICAL:String = "verical";
		
		static private const MIN_SPEED:Number = .5;
		static private const FRICTION:Number = .9;
		static private const ELASTIC_MULTIPLER:Number = 9.5;
		
		static private var idCounter:int = 0;
		
		private var _type:String = TYPE_VERTICAL;
		private var _content:Sprite;
		private var _shape:Shape;
		private var maskObj:Shape = new Shape();
		private var id:int;
		private var mousePointsList:Vector.<Point>;
		private var inertia:Number;
		private var elastic:Number;
		
		private var dragBounds:Rectangle;
		private var isDragged:Boolean = false;
		
		/**
		 * 
		 */
		
		public function TouchScreenScroll() {
			customizeComponent();
		}
		
		/**
		 * Тип скроллбара
		 */
		
		public function set type( value:String ):void {
			if ( _type !== TYPE_VERTICAL ) {
				throw new Error( "Тип может иметь только следующие значения: " + TYPE_VERTICAL );
			}
			_type = value;
		}
		
		/**
		 * Скроллируемый контент
		 */
		
		public function set content( value:* ):void {
			if ( value is String ) {
				_content = parent.getChildByName( value ) as Sprite;
			} else if( value is Sprite ) {
				_content = value as Sprite;
			} else {
				throw new Error( "Неверное значение, content может быть либо String имени Sprite расположенного в том же контейнере, где и сам компонеет, или Sprite" );
			}
			
			trace( "content is", _content );
			
			drawMask();
			
			if ( stage ) {
				init();
			} else {
				addEventListener( Event.ADDED_TO_STAGE, init );
			}
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return _shape.width;
		}
		
		/**
		 * 
		 */
		
		override public function set width(value:Number):void {
			_shape.width = value;
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return _shape.height;
		}
		
		/**
		 * 
		 */
		
		override public function set height( value:Number ):void {
			_shape.height = value;
		}
		
		/**
		 * Вешакт маску на контент
		 */
		
		private function drawMask():void {
			maskObj.graphics.beginFill( 0 );
			maskObj.graphics.drawRect( x, y, _shape.width, _shape.height );
			maskObj.graphics.endFill();
			_content.mask = maskObj;
		}
		
		/**
		 * 
		 */
		
		private function init( event:Event = null ):void {
			id = ++idCounter;
			if ( event ) {
				removeEventListener( Event.ADDED_TO_STAGE, init );
			}
			trace( stage, "byEvent:", Boolean( event ) );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseIsDown );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseIsDown( event:MouseEvent ):void {
			var isHit:Boolean = hitTestPoint( stage.mouseX, stage.mouseY );
			if ( isHit ) {
				removeAllIntervalListeners();
				dragBounds = new Rectangle( x, y, 0, height - _content.height );
				setMargins();
				startContentDrag();
				var mousePoint:Point = new Point( stage.mouseX, stage.mouseY );
				mousePointsList = new <Point>[ mousePoint, mousePoint ];
				stage.addEventListener( MouseEvent.MOUSE_UP, onMouseIsUp );
				stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseIsMove );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseIsUp( event:MouseEvent ):void {
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseIsUp );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseIsMove );
			stopContentDrag();
			if( contentInDragZone() ) {
				inertia = getMouseSpeed();
				playInertia();
				addEventListener( Event.ENTER_FRAME, playInertia );
				trace( "inertia:", inertia );
			} else {
				if ( _content.y > dragBounds.y ) {
					trace( "backToUp" );
					elastic = ( y - _content.y ) / ELASTIC_MULTIPLER;
					_content.addEventListener( Event.ENTER_FRAME, playElastic );
					playElastic();
				} else {
					trace( "backToDown" );
					elastic = ( ( y + height ) - ( _content.y + _content.height ) ) / ELASTIC_MULTIPLER;
					_content.addEventListener( Event.ENTER_FRAME, playElastic );
					playElastic();
				}
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function playElastic( event:Event = null ):void {
			_content.y += elastic;
			elastic *= FRICTION;
			
			trace( "ELASTIC:", elastic );
			
			if ( contentInDragZone() ) {
				setMargins();
				_content.y = Math.round( _content.y );
				_content.removeEventListener( Event.ENTER_FRAME, playElastic );
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function getMouseSpeed():int {
			return mousePointsList[ 1 ].y - mousePointsList[ 0 ].y;
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function contentInDragZone():Boolean {
			return _content.y <= dragBounds.y && _content.y >= dragBounds.y + dragBounds.height;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseIsMove( event:MouseEvent ):void {
			mousePointsList.shift();
			mousePointsList.push( new Point( stage.mouseX, stage.mouseY ) );
			if ( _content.y >= dragBounds.y ) {
				trace( "Elastic in down" );
				if( isDragged ) stopContentDrag();
				_content.y += getMouseSpeed() / 2;
			} else if ( _content.y <= dragBounds.y + dragBounds.height ) {
				trace( "Elastic in up" );
				if( isDragged ) stopContentDrag();
				_content.y += getMouseSpeed() / 2;
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function playInertia( event:Event = null ):void {
			_content.y += inertia;
			inertia *= FRICTION;
			
			if ( Math.abs( inertia ) < MIN_SPEED ) {
				trace( "rem" );
				_content.y = Math.round( _content.y );
				removeEventListener( Event.ENTER_FRAME, playInertia );
			}
			
			trace( inertia );
			
			setMargins();
		}
		
		/**
		 * 
		 */
		
		private function removeAllIntervalListeners():void {
			if ( hasEventListener( Event.ENTER_FRAME ) ) {
				removeEventListener( Event.ENTER_FRAME, playInertia );
			}
			
			if ( _content.hasEventListener( Event.ENTER_FRAME ) ) {
				_content.removeEventListener( Event.ENTER_FRAME, playElastic );
			}
		}
		
		/**
		 * 
		 */
		
		private function setMargins():void {
			trace( "setMargins" );
			if ( _content.y > dragBounds.y ) {
				_content.y = dragBounds.y;
				inertia = 0;
			}
			
			if ( _content.y < dragBounds.y + dragBounds.height ) {
				_content.y = dragBounds.y + dragBounds.height;
				inertia = 0;
			}
		}
		
		/**
		 * 
		 */
		
		private function customizeComponent():void {
			_shape = getChildAt( 0 ) as Shape;
			_shape.width = width;
			_shape.height = height;
			scaleX = scaleY = 1;
			_shape.visible = false;
			//_shape.alpha = 0.5;
		}
		
		/**
		 * 
		 */
		
		private function startContentDrag():void {
			isDragged = true;
			_content.startDrag( false, dragBounds );
		}
		
		/**
		 * 
		 */
		
		private function stopContentDrag():void {
			isDragged = false;
			stopDrag();
		}
	}

}