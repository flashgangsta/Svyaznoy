package com.flashgangsta.ui {
	import com.flashgangsta.managers.ButtonManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01
	 */
	
	 /**
	 * Dispatched when user change slider thumb position.
	 * @eventType	flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	
	public class Slider extends EventDispatcher {
		
		private var dragArea:Rectangle;
		private var clickableRoad:MovieClip;
		private var thumb:MovieClip;
		private var percent:int;
		
		/**
		 * 
		 * @param	thumb
		 * @param	clickableRoad
		 * @param	dragArea
		 */
		
		public function Slider( thumb:MovieClip, clickableRoad:MovieClip, dragArea:Rectangle ) {
			this.thumb = thumb;
			this.clickableRoad = clickableRoad;
			this.dragArea = dragArea;
			
			ButtonManager.addButton( thumb, null, dropThumb, dropThumb, dragThumb );
			
			if ( clickableRoad ) ButtonManager.addButton( clickableRoad, null, dropThumb, dropThumb, onRoadPressed );
			
			calculatePercent();
		}
		
		/**
		 * Уничтожает все ссылки и слушатели
		 */
		
		public function destroy():void {
			if ( clickableRoad ) clickableRoad.removeEventListener( MouseEvent.MOUSE_DOWN, onRoadPressed );
		}
		
		/**
		 * Возвращает значение ползунка в процентах
		 * @return
		 */
		
		public function getPercent():int {
			return percent;
		}
		
		/**
		 * Устанавливает значение полхунка
		 * @param	value значение в процентах (от 0 до 100 ).
		 */
		
		public function setPercent( value:int ):void {
			if ( value < 0 || value > 100 ) throw new Error( "Переданное значение: " + value + " не вписывается в интервал от 0 до 100" );
			percent = value;
			thumb.x = int( dragArea.width / 100 * value );
		}
		
		/**
		 * Прибавляет переданный процент к текущему проценту слайдера
		 * @param	value
		 */
		
		public function addPercent( value:int ):void {
			percent = Math.min( percent + value, 100 );
			setPercent( percent );
		}
		
		/**
		 * Отнимает переданный процент от текущего процента слайдера
		 * @param	value
		 */
		
		public function removePercent( value:int ):void {
			percent = Math.max( percent - value, 0 );
			setPercent( percent );
		}
		 
		/**
		 * 
		 */
		
		private function dragThumb( target:MovieClip = null ):void {
			thumb.startDrag( true, dragArea );
			thumb.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		/**
		 * 
		 */
		
		private function dropThumb( target:MovieClip = null ):void {
			thumb.stopDrag();
			thumb.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseMove( event:Event = null ):void {
			calculatePercent();
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		/**
		 * Нажатие мыши по дорожке ползунка
		 * @param	event
		 */
		
		private function onRoadPressed( target:MovieClip ):void {
			trace( "roadPressed" );
			thumb.x = int( clickableRoad.mouseX - ( thumb.width / 2 ) );
			dragThumb();
			onMouseMove();
		}
		
		/**
		 * 
		 */
		
		private function calculatePercent():void {
			percent = thumb.x / dragArea.width * 100; 
		}
		
	}

}