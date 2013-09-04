package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.flashgangsta.ui.Scrollbar;
	import com.flashgangsta.utils.PopupsController;
	import com.flashgangsta.utils.ScreenController;
	import com.svyaznoy.events.LoginSectionEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import com.svyaznoy.gui.Paging;
	import com.svyaznoy.modules.Voting;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestProfile extends Sprite {
		
		private var screenController:ScreenController = new ScreenController();
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		private var popupsController:PopupsController;
		private var scrollbarView:ScrollbarView;
		private var scrollContent:MovieClip = new MovieClip();
		private var scrollMask:Shape = new Shape();
		
		/**
		 * 
		 */
		
		public function TestProfile() {
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function init( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			
			//Helper
			helper.isDebug = ( loaderInfo.url.indexOf( "http" ) !== 0 );
			ContentLoader.context = helper.loaderContext;
			//Provider
			provider.init();
			
			//provider.getRandomSurveys();
			//provider.addEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			// PopupsController
			popupsController = PopupsController.getInstance();
			popupsController.init( stage, 0x2b2927, .85 );
			
			
			// Scrollbar
			
			scrollbarView = getChildByName( "scrollbarView_mc" ) as ScrollbarView;
			scrollbarView.visible = false;
			
			// ScreenController
			addChildAt( scrollContent, 0 );
			scrollContent.addChild( screenController );
			
			screenController.width = 515;
			screenController.height = scrollbarView.height;
			helper.setScreenRectangle( scrollContent.x, scrollContent.y, screenController.width, screenController.height );
			
			scrollMask.y = scrollContent.y;
			scrollMask.graphics.beginFill( 0 );
			scrollMask.graphics.drawRect( 0, 0, stage.stageWidth, scrollbarView.height );
			scrollMask.graphics.endFill();
			scrollContent.mask = scrollMask;
			screenController.addEventListener( ScreenEvent.HEIGHT_UPDATED, onContentHeightUpdated );
			screenController.addEventListener( Event.CHANGE, onScreenChanged );
			screenController.visible = false;
			
			Scrollbar.setVertical( scrollContent, scrollMask.getBounds( this ), scrollbarView.getUpBtn(), scrollbarView.getDownBtn(), scrollbarView.getCarret(), scrollbarView.getBounds( scrollbarView ), stage );
			
			screenController.addScreen( Profile );
			
			Scrollbar.reset( scrollbarView.getCarret() );
			onContentHeightUpdated();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onScreenChanged( event:Event ):void {
			Scrollbar.reset( scrollbarView.getCarret() );
			onContentHeightUpdated();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onContentHeightUpdated( event:ScreenEvent = null ):void {
			if( event ) event.stopImmediatePropagation();
			Scrollbar.update( scrollbarView.getCarret() );
			scrollbarView.visible = Scrollbar.isNeeded( scrollbarView.getCarret() );
		}
	}

}