package com.svyaznoy {
	import com.svyaznoy.events.DynamicItemEvent;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DynamicItem extends Sprite {
		
		public function DynamicItem() {
			
		}
		
		protected function dispatchChange():void {
			dispatchEvent( new DynamicItemEvent( DynamicItemEvent.SIZE_CHANGED, true ) );
		}
		
		public function dispose():void {
			//TODO: реализовать уничтожение
		}
		
	}

}