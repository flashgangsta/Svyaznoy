package com.svyaznoy {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ScrollbarView extends Sprite {
		
		private var _carret:MovieClip;
		private var _upBtn:MovieClip = new MovieClip();
		private var _downBtn:MovieClip = new MovieClip();
		private var _line:MovieClip;
		
		
		public function ScrollbarView() {
			_carret = getChildByName( "carret_mc" ) as MovieClip;
			_carret.gotoAndStop( 1 );
			_line = getChildAt( 0 ) as MovieClip;
			_line.mouseEnabled = _line.mouseChildren = false;
		}
		
		public function getCarret():MovieClip {
			return _carret;
		}
		
		public function getUpBtn():MovieClip{
			return _upBtn;
		}
		
		public function getDownBtn():MovieClip{
			return _downBtn;
		}
		
	}

}