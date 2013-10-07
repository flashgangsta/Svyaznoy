package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.LabelWithIcon;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class LikeComponent extends Sprite {
		
		private var button:LikeButton;
		private var icon:LabelWithIcon;
		private var data:Object;
		private var background:DisplayObject;
		
		/**
		 * 
		 */
		
		public function LikeComponent( data:Object ) {
			this.data = data;
			background = getChildByName( "background_mc" );
			button = getChildByName( "button_mc" ) as LikeButton;
			icon = getChildByName( "icon_mc" ) as LabelWithIcon;
			
			if ( data.is_can_be_voted ) {
				button.likes = data.likes;
				button.addEventListener( MouseEvent.CLICK, onClicked );
				icon.visible = false;
			} else {
				button.visible = false;
				icon.value = data.likes;
				alignIcon();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClicked( event:MouseEvent ):void {
			button.visible = false;
			icon.value = data.is_can_be_voted = int( int( data.likes ) + 1 ).toString();
			icon.visible = true;
			alignIcon();
			Provider.getInstance().sendLike( data.competition_id, data.id );
			data.is_can_be_voted = false;
		}
		
		/**
		 * 
		 */
		
		private function alignIcon():void {
			icon.x = MappingManager.getCentricPoint( background.width, icon.width );
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			if( button ) {
				if ( button.hasEventListener( MouseEvent.CLICK ) ) {
					button.removeEventListener( MouseEvent.CLICK, onClicked );
				}
				button.dispose();
				button = null;
			}
		}
	}
}