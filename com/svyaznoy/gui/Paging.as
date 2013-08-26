package com.svyaznoy.gui {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	 /// Dispatched when value changed
	[Event(name = "change", type = "flash.events.Event")]
	/// Dispatched after buttons redraw and component setted new width
	[Event(name = "resize", type = "flash.events.Event")]
	
	public class Paging extends Sprite {
		
		const MAX_BUTTONS_LENGTH:int = 7;
		
		private var oneSideLength:int = Math.floor( MAX_BUTTONS_LENGTH / 2 );
		private var buttonsLength:int;
		private var pagesLength:int;
		private var _selectedButton:PagingButton;
		
		private var buttons:Vector.<PagingButton> = new Vector.<PagingButton>();
		
		/**
		 * 
		 */
		
		public function Paging() {
			selectedButton = getChildAt( 0 ) as PagingButton;
			buttons.push( selectedButton );
			selectedButton.init( 1 );
			
			selectedButton.addEventListener( MouseEvent.CLICK, onPageSelect );
			selectedButton.enabled = false;
			selectedButton.setSelectedState();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPageSelect( event:MouseEvent ):void {
			selectedButton.enabled = true;
			selectedButton.setDefaultState();
			
			selectedButton = event.currentTarget as PagingButton;
			
			addButtons();
			
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		private function getButtonByValue( value:int ):PagingButton {
			var result:PagingButton;
			var button:PagingButton;
			for ( var i:int = 0; i < buttons.length; i++ ) {
				button = buttons[ i ];
				if ( button.value === value ) {
					result = button;
					break;
				}
			}
			return result;
		}
		
		/**
		 * 
		 * @param	pagesLength
		 */
		
		public function init( totalPages:int ):void {
			pagesLength = totalPages;
			buttonsLength = Math.min( pagesLength, MAX_BUTTONS_LENGTH );
			addButtons( );
			selectedButton = buttons[ 0 ];
		}
		
		public function get value():int {
			return selectedButton.value;
		}
		
		/**
		 * 
		 */
		
		private function addButtons():void {
			var button:PagingButton;
			var selectedButtonIndex:int = getChildIndex( selectedButton );
			var offset:int = 0;
			var oldWidth:Number = width;
			
			if ( pagesLength > MAX_BUTTONS_LENGTH ) {
				if ( selectedButtonIndex < oneSideLength ) {
					offset = value - oneSideLength - 1;
					if ( value - oneSideLength < 1 ) {
						offset = 0;
					}
				} else if ( selectedButtonIndex > oneSideLength ) {
					offset = value - oneSideLength - 1;
					if ( offset + buttonsLength > pagesLength ) {
						offset = pagesLength - buttonsLength;
					}
				} else {
					offset = value - oneSideLength - 1;
				}
			} 
			
			removeButtons();
			
			for ( var i:int = 0; i < buttonsLength; i++ ) {
				button = new PagingButton();
				button.addEventListener( MouseEvent.CLICK, onPageSelect );
				button.init( offset + i + 1 );
				button.x = width;
				addChild( button );
				buttons.push( button );
			}
			
			selectedButton = getButtonByValue( value );
			
			if ( oldWidth !== width ) {
				dispatchEvent( new Event( Event.RESIZE ) );
			}
			
		}
		
		/**
		 * 
		 */
		
		private function removeButtons():void {
			var button:PagingButton;
			for ( var i:int = 0; i < buttons.length; i++ ) {
				button = buttons[ i ];
				button.removeEventListener( MouseEvent.CLICK, onPageSelect );
				button.dispose();
				removeChild( button );
			}
			
			buttons = new Vector.<PagingButton>( buttons[ 0 ] );
		}
		
		/**
		 * 
		 */
		
		private function get selectedButton():PagingButton {
			return _selectedButton;
		}
		
		private function set selectedButton( value:PagingButton ):void {
			_selectedButton = value;
			_selectedButton.enabled = false;
			_selectedButton.setSelectedState();
		}
		
	}

}