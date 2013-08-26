package com.svyaznoy {
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class MainMenuButton extends MovieClip {
		
		var dynamicColorRect:Shape;
		
		public function MainMenuButton() {
			
		}
		
		public function setColor( color:uint ):void {
			var graphics:Graphics;
			if ( !dynamicColorRect ) {
				dynamicColorRect = new Shape();
				addChild( dynamicColorRect );
			}
			graphics = dynamicColorRect.graphics;
			graphics.clear();
			graphics.beginFill( color );
			graphics.drawRect( 0, 0, 8, height );
			graphics.endFill();
		}
		
	}

}