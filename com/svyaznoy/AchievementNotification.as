package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.managers.MappingManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AchievementNotification extends Sprite {
		
		private var achievementsDatas:AchievementsData = Helper.getInstance().getSettings().achievements;
		private var achievement:IconListItem;
		private var timer:Timer = new Timer( 1000, 1 );
		private var data:Object;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function AchievementNotification( data:Object ) {
			this.data = data;
			achievement = new IconListItem( null, achievementsDatas.getAchievementNameByData( data ), achievementsDatas.getAchievementIconByData( data ) );
			visible = false;
			filters = [ new GlowFilter( 0xFFFFFF, .75, 6, 6 ) ];
			scaleX = scaleY = .3;
			achievement.addEventListener( Event.COMPLETE, onLoaded );
			addChild( achievement );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			achievement.removeEventListener( Event.COMPLETE, onLoaded );
			
			var achievementBounds:Rectangle = achievement.getBounds( this );
			
			achievement.x = -(achievementBounds.width / 2);
			achievement.y = -(achievementBounds.height / 2);
			
			if ( stage ) {
				onAddedToStage();
			} else {
				addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event = null ):void {
			if( event ) removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			visible = true;
			x = stage.stageWidth / 2;
			y = stage.stageHeight + achievement.height;
			Tweener.addTween( this, { scaleX: 1, scaleY: 1, y: stage.stageHeight / 2,time: .6, transition: "easeOutBack", onComplete: onAchievementInCenter } );
		}
		
		/**
		 * 
		 */
		
		private function onAchievementInCenter():void {
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			timer.start();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTimer( event:Event ):void {
			timer.removeEventListener( Event.COMPLETE, onTimer );
			timer.stop();
			Tweener.addTween( this, { scaleX: 0, scaleY: 0, x: 0, y: 0, time: .65, transition: "easeInCubic", onComplete: onAchievementComplete } );
			//Provider.getInstance().setLastSeenAchievement( data.updated_at );
			//TODO: включить сохранение последней полученной ачивки
		}
		
		/**
		 * 
		 */
		
		private function onAchievementComplete():void {
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}

}