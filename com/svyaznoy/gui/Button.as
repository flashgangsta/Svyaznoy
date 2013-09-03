package com.svyaznoy.gui {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.ui.Label;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Button extends MovieClip {
		
		protected var label:Label;
		protected var hit:Shape = new Shape();
		private var labelMessage:String;
		private var _disabledAlpha:Number = .5;
		protected var isEased:Boolean = false;
		
		/**
		 * 
		 */
		
		public function Button() {
			for ( var i:int = 0; i < numChildren; i++ ) {
				var child:DisplayObject = getChildAt( i );
				if ( child is Label ) {
					label = child as Label;
				} else if ( child is TextField ) {
					TextField( child ).mouseEnabled = false;
					TextField( child ).mouseWheelEnabled = false;
				}
			}
			
			hit = new Shape();
			hit.graphics.beginFill( 0, 0 );
			hit.graphics.drawRect( 0, 0, width, height );
			hit.graphics.endFill();
			
			super.addChild( hit );
			
			if ( isEased ) {
				ButtonManager.addEasedButton( this );
			} else {
				ButtonManager.addButton( this );
			}
		}
		
		override public function addChild( child:DisplayObject ):DisplayObject {
			super.addChild( child );
			addChild( hit );
			hit.width = width;
			return child;
		}
		
		/**
		 * 
		 */
		
		override public function get enabled():Boolean {
			return super.enabled;
		}
		
		override public function set enabled( value:Boolean ):void {
			super.enabled = value;
			ButtonManager.setButtonEnable( this, value, true, disabledAlpha );
		}
		
		/**
		 * 
		 */
		
		public function get disabledAlpha():Number {
			return _disabledAlpha;
		}
		
		public function set disabledAlpha(value:Number):void {
			_disabledAlpha = value;
		}
		
		/**
		 * 
		 * @param	message
		 */
		
		public function setLabel( message:String ):void {
			if ( !label || label.text === message ) return;
			hit.width = 1;
			label.text = message;
			hit.width = ( width );
		}
		
		/**
		 * 
		 * @param	beginIndex
		 * @param	endIndex
		 * @return
		 */
		
		public function getLabelTextFormat( beginIndex:int = -1, endIndex:int = -1 ):TextFormat {
			return label.textField.getTextFormat( beginIndex, endIndex );
		}
		
		/**
		 * 
		 * @param	format
		 * @param	beginIndex
		 * @param	endIndex
		 */
		
		public function setLabelTextFormat( format:TextFormat, beginIndex:int = -1, endIndex:int = -1 ):void {
			label.textField.setTextFormat( format, beginIndex, endIndex );
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			ButtonManager.removeButton( this );
			if ( label ) {
				label.dispose();
				label = null;
			}
		}
		
	}

}