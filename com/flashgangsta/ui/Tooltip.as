package com.flashgangsta.ui {
	
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	/**
	 * Tooltip
	 * Class for quick setting personal tooltip component
	 * @author Sergey Krivtsov
	 * @version		1.00.01
	 */
	
	public class Tooltip {
		
		/// Отсутп по Y от объекта до туллтипа
		private static const MARGIN_Y:int = 5;
		
		/// Экземпляр подсказки
		private static var symbol:Sprite;
		/// Текстовое поле в подсказке
		private static var label:TextField;
		/// Фон в подсказке
		private static var bg:Sprite;
		/// Отступ по X текстового поля в подсказке
		private static var xMargin:int;
		/// Отступ по Y текстового поля в подсказке
		private static var yMargin:int;
		/// Задержка перед отображением подсказки
		private static var delay:int;
		
		/// Контейнер на который помещается подсказка
		private var place:DisplayObjectContainer;
		/// Точка на которой помещается подсказка
		private var point:Point;
		/// Объект-обладатель подсказки
		private var target:DisplayObjectContainer;
		/// Текст подсказки
		private var message:String;
		/// Таймер счёта задержки перед выводом подсказки
		private var timer:Timer;
		/// Параметры анимации вывода подсказки
		private var tweenParams:Object = { time: .20, transition: "easeInOutCubic" };
		
		/**
		 * Tooltip class
		 * 
		 * @param	target		объект на котором будет подсказка
		 * @param	message		сообщение
		 * @param	delay		время задержки
		 */
		
		public function Tooltip( target:DisplayObjectContainer, message:String ) {
			if ( !Tooltip.symbol ) throw new Error( "Для создания экземпляра класса, сначала нужно инициализировать класс, вызвав статический метод Tooltip.init()" );
			
			this.place = target.parent;
			this.target = target;
			this.message = message;
			
			timer = new Timer( delay, 1 );
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			
			target.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			target.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			target.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			target.addEventListener( Event.REMOVED_FROM_STAGE, onTargetRemoved );
		}
		
		
		/**
		 * Инициализация класса.
		 * @param	symbolLinkage ссылка на экземпляр класса скина всплывающей подсказки
		 */
		
		public static function init( symbolLinkage:Sprite, delay:int = 500 ):void {
			Tooltip.symbol = symbolLinkage;
			Tooltip.delay = delay;
			
			for ( var i:int = 0; i < symbol.numChildren; i++ ) {
				var child:DisplayObject = symbol.getChildAt( i );
				if ( child is TextField ) {
					label = child as TextField;
				} else if ( child is Sprite ) {
					bg = child as Sprite;
				}
			}
			
			if ( !label ) {
				throw new Error( "Экземпляр подсказки не содержит в себе текстового поля" );
			} else if ( !bg ) {
				throw new Error( "Экземпляр подсказки не содержит в себе фона" );
			} else {
				label.autoSize = TextFieldAutoSize.LEFT;
				label.multiline = true;
				label.wordWrap = false;
				label.selectable = false;
				label.mouseEnabled = false;
				
				xMargin = Math.round( label.x );
				yMargin = Math.round( label.y );
			}
			
			symbol.mouseChildren = false;
			symbol.mouseEnabled = false;
			
		}
		
		/**
		 * Наведение мышки
		 * @param	event
		 */
		
		private function onMouseOver( event:MouseEvent ):void {
			point = new Point( place.mouseX, target.getBounds( place ).y );
			symbol.alpha = 0;
			timer.start();
		}
		
		/**
		 * Уведение мышки
		 * @param	event
		 */
		
		private function onMouseOut( event:MouseEvent ):void {
			hide();
		}
		
		/**
		 * Нажатие мышки
		 * @param	event
		 */
		
		private function onMouseDown( event:MouseEvent ):void {
			hide();
		}
		
		/**
		 * Конец задержки перед выводом туллтипа
		 * @param	event
		 */
		
		private function onTimer( event:TimerEvent ):void {
			show();
		}
		
		/**
		 * Показывает туллтип
		 */
		
		private function show():void {
			if ( symbol.parent !== place ) {
				place.addChild( symbol );
			}
			
			label.text = message;
			
			bg.width = Math.round( label.width + ( xMargin * 2 ) );
			bg.height = Math.round( label.height + ( yMargin * 2 ) );
			
			symbol.x = Math.floor( Math.min( point.x, symbol.stage.stageWidth - symbol.width ) );
			symbol.y = Math.ceil( Math.max( point.y - symbol.height - MARGIN_Y, 0 ) );
			
			
			tweenParams.alpha = 1;
			Tweener.addTween( symbol, tweenParams );
			timer.reset();
		}
		
		/**
		 * Прячет туллтип
		 */
		
		private function hide():void {
			timer.stop();
			timer.reset();
			tweenParams.alpha = 0;
			Tweener.addTween( symbol, tweenParams );
		}
		
		/**
		 * Обработка удаления предмета на котором туллтип
		 * @param	event
		 */
		
		private function onTargetRemoved( event:Event ):void {
			place = null;
			target = null;
			message = null;
			
			timer.removeEventListener( TimerEvent.TIMER, onTimer );
			timer = null;
			
			target.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			target.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			target.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			target.removeEventListener( Event.REMOVED_FROM_STAGE, onTargetRemoved );
		}
		
	}

}