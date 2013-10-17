package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.events.PopupsControllerEvent;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.utils.PopupsController;
	import com.flashgangsta.vk.WallPostUtil;
	import com.svyaznoy.gui.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AchievementSharingPopup extends Popup {
		
		private var achievementsDatas:AchievementsData = Helper.getInstance().getSettings().achievements;
		private var avatar:AvatarContainer;
		private var achievementLabel:TextField;
		private var awardLabel:TextField;
		private var battery:Sprite;
		private var shareButton:Button;
		private var cancelButton:Button;
		private var awardContainer:Sprite = new Sprite();
		private var data:Object;
		private var achievement:Bitmap;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function AchievementSharingPopup( data:Object ) {
			this.data = data;
			avatar = getChildByName( "avatar_mc" ) as AvatarContainer;
			achievementLabel = getChildByName( "achievementLabel_txt" ) as TextField;
			awardLabel = getChildByName( "awardLabel_txt" ) as TextField;
			battery = getChildByName( "battery_mc" ) as Sprite;
			shareButton = getChildByName( "shareButton_mc" ) as Button;
			cancelButton = getChildByName( "cancelButton_mc" ) as Button;
			
			var shareLabelTextFormat:TextFormat = shareButton.getLabelTextFormat();
			var shareLabelMessage:String = "рассказать друзьям, +1 дж";
			shareLabelTextFormat.color = 0xfad657;
			
			shareButton.setLabel( shareLabelMessage.toUpperCase() );
			cancelButton.setLabel( "вернуться к приложению".toUpperCase() );
			shareButton.setLabelTextFormat( shareLabelTextFormat, shareLabelMessage.length - 5, shareLabelMessage.length );
			
			awardContainer.y = awardLabel.y;
			awardLabel.y = awardLabel.x = 0;
			awardLabel.autoSize = TextFieldAutoSize.LEFT;
			awardContainer.addChild( awardLabel );
			awardContainer.addChild( battery );
			
			achievementLabel.text = "«" + achievementsDatas.getAchievementNameByData( data ) + "»";
			awardLabel.text = "НАГРАДА: " + achievementsDatas.getAchievementCostByData( data ).toString();
			avatar.setScaleMode( AvatarContainer.SCALE_MODE_ONLY_REDUCE );
			avatar.loadByPath( achievementsDatas.getAchievementIconByData( data ) );
			
			battery.x = awardLabel.width + 5;
			battery.y = 4;
			awardContainer.x = MappingManager.getCentricPoint( background.width, awardContainer.width );
			addChild( awardContainer );
			
			shareButton.addEventListener( MouseEvent.CLICK, onShareClicked );
			cancelButton.addEventListener( MouseEvent.CLICK, onCancelClicked );
			
			addEventListener( PopupsControllerEvent.CLOSING, onClosing );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClosing( event:PopupsControllerEvent ):void {
			var bitmap:Bitmap = avatar.getBitmap();
			var bounds:Rectangle = bitmap.getBounds( stage );
			var bitmapData:BitmapData = bitmap.bitmapData.clone();
			achievement = new Bitmap( bitmapData, PixelSnapping.NEVER, true );
			
			achievement.width = bitmap.width;
			achievement.height = bitmap.height;
			
			achievement.x = bounds.x;
			achievement.y = bounds.y;
			
			stage.addChild( achievement );
			
			Tweener.addTween( achievement, { scaleX: 0, scaleY: 0, x: 0, y: 0, time: .85, transition: "easeInCubic", onComplete: onAchievementComplete } );
			Provider.getInstance().setLastSeenAchievement( data.updated_at );
		}
		
		/**
		 * 
		 */
		
		private function onAchievementComplete():void {
			if ( achievement ) {
				achievement.bitmapData.dispose();
				achievement.parent.removeChild( achievement );
				achievement = null;
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onShareClicked( event:MouseEvent ):void {
			var sharing:WallPostUtil = new WallPostUtil( Helper.getInstance().vkAPI, WallPostUtil.BITMAP_ENCODE_METHOD_PNG );
			var message:String = "Я " + achievementLabel.text + " в приложении Связной";
			sharing.post( message, [ avatar.getBitmap() ], Helper.getInstance().getAppURL() );
			sharing.addEventListener( Event.COMPLETE, onPostShared );
			shareButton.enabled = false;
			shareButton.visible = false;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPostShared( event:Event ):void {
			var sharing:WallPostUtil = event.target as WallPostUtil;
			sharing.removeEventListener( Event.COMPLETE, onPostShared );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onCancelClicked( event:MouseEvent ):void {
			close();
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			shareButton.removeEventListener( MouseEvent.CLICK, onShareClicked );
			cancelButton.removeEventListener( MouseEvent.CLICK, onCancelClicked );
			avatar.dispose();
			shareButton.dispose();
			cancelButton.dispose();
			super.dispose();
		}
		
	}

}