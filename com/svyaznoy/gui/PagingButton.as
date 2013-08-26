package com.svyaznoy.gui {
	import com.flashgangsta.managers.MappingManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public dynamic class PagingButton extends Sprite {
		
		const OVER_COLOR:uint = 0x787673;
		const PRESS_COLOR:uint = 0xFFFFFF;
		const MARGIN:int = 3;
		
		private var labelField:TextField;
		private var hit:Sprite;
		private var defaultTextFormat:TextFormat;
		private var overTextFormat:TextFormat;
		private var pressTextFormat:TextFormat;
		private var _enabled:Boolean = true;
		private var _label:String;
		
		
		/**
		 * 
		 */
		
		public function PagingButton() {
			labelField = getChildByName( "label_txt" ) as TextField;
			hit = getChildByName( "hit_mc" ) as Sprite;
			
			label = "1";
			
			labelField.autoSize = TextFieldAutoSize.LEFT;
			
			defaultTextFormat = labelField.getTextFormat();
			overTextFormat = labelField.getTextFormat();
			pressTextFormat = labelField.getTextFormat();
			
			overTextFormat.color = OVER_COLOR;
			pressTextFormat.color = PRESS_COLOR;
			
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			
			labelField.mouseEnabled = labelField.mouseWheelEnabled = false;
			
			buttonMode = true;
		}
		
		/**
		 * 
		 * @param	pageNum
		 */
		
		public function init( pageNum:int ):void {
			label = pageNum.toString();
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		/**
		 * 
		 */
		
		public function get value():int {
			return int( _label );
		}
		
		/**
		 * 
		 */
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled( value:Boolean ):void {
			_enabled = value;
			mouseEnabled = mouseChildren = value;
		}
		
		private function set label( value:String ):void {
			_label = value;
			labelField.text = value;
			hit.width = Math.ceil( labelField.width ) + MARGIN;
			labelField.x = MappingManager.getCentricPoint( hit.width, labelField.width );
		}
		
		
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseOver( event:MouseEvent ):void {
			if ( !enabled ) return;
			labelField.setTextFormat( overTextFormat );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseOut( event:MouseEvent ):void {
			if ( !enabled ) return;
			setDefaultState();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseDown( event:MouseEvent ):void {
			if ( !enabled ) return;
			setSelectedState();
		}
		
		/**
		 * 
		 */
		
		public function setDefaultState():void {
			labelField.setTextFormat( defaultTextFormat );
		}
		
		/**
		 * 
		 */
		
		public function setSelectedState():void {
			labelField.setTextFormat( pressTextFormat );
		}
		
	}

}