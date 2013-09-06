package com.svyaznoy {
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class DeparturesPhotosButton extends Button {
		
		private var icon:Sprite;
		private var iconGraphics:DisplayObject;
		private var _isOpened:Boolean = false;
		
		/**
		 * 
		 */
		
		public function DeparturesPhotosButton() {
			icon = label.getChildByName( "icon_mc" ) as Sprite;
			iconGraphics = icon.getChildAt( 0 );
			addEventListener( MouseEvent.CLICK, onClicked );
			disabledAlpha = 1;
		}
		
		/**
		 * 
		 * @param	message
		 */
		
		override public function setLabel( message:String ):void {
			icon.x = 0;
			icon.scaleX = 0;
			super.setLabel( message );
			icon.scaleX = 1;
			icon.x = label.x + label.width + 5;
			hit.width = width;
		}
		
		/**
		 * 
		 */
		
		public function get isOpened():Boolean {
			return _isOpened;
		}
		
		/**
		 * 
		 */
		
		public function get iconVisible():Boolean {
			return icon.visible;
		}
		
		public function set iconVisible(value:Boolean):void {
			icon.visible = value;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClicked( event:MouseEvent ):void {
			if ( isOpened ) {
				iconGraphics.scaleY = 1;
				iconGraphics.y -= iconGraphics.height;
			} else {
				iconGraphics.scaleY = -1;
				iconGraphics.y += iconGraphics.height;
			}
			_isOpened = !_isOpened;
		}
	}

}