package com.flashgangsta.ui {
	import com.flashgangsta.managers.ButtonManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.drm.VoucherAccessInfo;
	
	/**
	 * ...
	 * @author Sergey Krivtsov
	 * @version 1.00.07
	 */
	
	
	/**
	 * Dispatched when a user change state of check box
	 * @eventType	flash.events.Event.CHANGED
	 */
	[Event(name="change", type="flash.events.Event")] 
	
	public class CheckBox extends EventDispatcher {
		
		private var instance:MovieClip;
		private var ico:Sprite;
		private var box:MovieClip;
		private var _id:String;
		
		/**
		 * Constructor
		 * @param	instance ссылка на объект который будет слушать наведения мыши
		 * @param	ico ссылка на галочку CheckBox'a
		 * @param	box ссылка на клип CheckBox'a который будет реагировать на мышь, по умолчанию берётся значение параметра instance
		 */
		
		public function CheckBox( instance:MovieClip, ico:Sprite, box:MovieClip = null ) {
			this.instance = instance;
			this.ico = ico;
			this.box = box ? box : instance;
			
			ico.mouseEnabled = false;
			ico.mouseChildren = false;
			
			ButtonManager.addButton( this.box, instance, onClick );
			addEventListener( Event.REMOVED_FROM_STAGE, removed );
			
		}
		
		/**
		 * Обработка удаления объекта
		 * @param	event
		 */
		
		private function removed( event:Event ):void {
			removeEventListener( Event.REMOVED_FROM_STAGE, removed );
			ButtonManager.removeButton( box );
			instance = null;
			ico = null;
			box = null;
		}
		
		/**
		 * Устанавливает выделение для checkbox
		 */
		
		public function set selected( value:Boolean ):void {
			ico.visible = value;
		}
		
		/**
		 * Возвращает состояние выделения чекбокса
		 */
		
		public function get selected():Boolean {
			return ico.visible;
		}
		
		/**
		 * Меняет состояние включенности чекбокса
		 */
		
		public function set enabled( value:Boolean ):void {
			mouseEnabled = value;
			mouseChildren = value;
			instance.alpha = value ? 1 : .5;
		}
		
		/**
		 * Возвращает состояние включенности чекбокса
		 */
		
		public function get enabled():Boolean {
			return mouseChildren;
		}
		
		/**
		 * Specifies whether this object receives mouse messages. The default value is true,
		 * which means that by default any InteractiveObject instance that is on the display list
		 * receives mouse events.
		 */
		
		public function set mouseEnabled( value:Boolean ):void {
			instance.mouseEnabled = value;
		}
		
		/**
		 * Return whether this object receives mouse messages. The default value is true,
		 * which means that by default any InteractiveObject instance that is on the display list
		 * receives mouse events.
		 */
		
		public function get mouseEnabled():Boolean {
			return instance.mouseEnabled;
		}
		
		/**
		 * Determines whether or not the children of the object are mouse enabled. 
		 */
		
		public function set mouseChildren( value:Boolean ):void {
			instance.mouseChildren = value;
		}
		
		/**
		 * Return whether or not the children of the object are mouse enabled. 
		 */
		
		public function get mouseChildren():Boolean {
			return instance.mouseChildren;
		}
		
		/**
		 * Возвращает имя объекта
		 */
		
		public function get name():String {
			return instance.name;
		}
		
		/**
		 * Устанавливает идентификатор
		 */
		
		public function set id( value:String ):void {
			_id = value;
		}
		
		/**
		 * Возвращает идентификатор
		 */
		
		public function get id():String {
			return _id;
		}
		
		/**
		 * Обработка нажатия на чекбокс
		 * @param	target
		 */
		
		private function onClick( target:MovieClip ):void {
			ButtonManager.setButtonState( instance, ButtonManager.STATE_NORMAL );
			selected = !selected;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
	}

}