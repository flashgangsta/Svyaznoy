﻿package com.svyaznoy {		import caurina.transitions.properties.ColorShortcuts;	import caurina.transitions.properties.FilterShortcuts;	import caurina.transitions.Tweener;	import com.flashgangsta.net.ContentLoader;	import com.flashgangsta.ui.Scrollbar;	import com.flashgangsta.utils.PopupsController;	import com.flashgangsta.utils.ScreenController;	import com.svyaznoy.events.LoginSectionEvent;	import com.svyaznoy.events.LotteryEvent;	import com.svyaznoy.events.MapItemEvent;	import com.svyaznoy.events.NavigationEvent;	import com.svyaznoy.events.NewsEvent;	import com.svyaznoy.events.PreviewEvent;	import com.svyaznoy.events.ProviderEvent;	import com.svyaznoy.events.ScreenEvent;	import com.svyaznoy.events.ScrollbarEvent;	import flash.display.MovieClip;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.Event;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.system.Security;	import flash.utils.Dictionary;		/**	 * ...	 * @author Sergey Krivtsov (flashgangsta@gmail.com)	 */		public class Main extends Sprite {				private var screenController:ScreenController = new ScreenController();		private var popupsController:PopupsController;		private var mainMenu:MainMenu;		private var userInfoSection:UserInfoSection;		private var dispatcher:Dispatcher = Dispatcher.getInstance();		private var pageClassesByEventTypes:Dictionary = new Dictionary();		private var helper:Helper = Helper.getInstance();		private var scrollbarView:ScrollbarView;		private var scrollContent:MovieClip = new MovieClip();		private var scrollMask:Shape = new Shape();		private var loginSection:LoginSection;		private var rightMenu:RightMenu;		private var provider:Provider = Provider.getInstance();		private var achievementsController:AchievementsController = AchievementsController.getInstance();				/**		 * 		 */				public function Main() {			Security.allowInsecureDomain( "*" );			Security.allowDomain( "*" );						if( stage ) {				init();			} else {				addEventListener( Event.ADDED_TO_STAGE, init );			}		}				/**		 * 		 * @param	event		 */				public function init( event:Event = null ):void {			if ( event ) removeEventListener( Event.ADDED_TO_STAGE, init );			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.align = StageAlign.TOP_LEFT;						//Tweener			ColorShortcuts.init();			FilterShortcuts.init();						//Helper			helper.isDebug = ( loaderInfo.url.indexOf( "http" ) !== 0 );			ContentLoader.context = helper.loaderContext;						// VK API			if ( !helper.isDebug ) {				helper.setFlashvars( loaderInfo.parameters );				helper.createVkAPI();			}						//Provider			Provider.getInstance().init();						// Dispathcer			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_DEPARTURES ] = Departures;			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_NEWS ] = News;			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_LEGEND ] = Legend;			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_ABOUT ] = About;			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_THERMS_OF_MOTIVATION ] = ThermsOfMotivation;			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_CONTESTS ] = Contests;			pageClassesByEventTypes[ NavigationEvent.NAVIGATE_TO_RATINGS ] = Ratings;									for ( var key:String in pageClassesByEventTypes ) {				dispatcher.addEventListener( key, navigateToPage );			}						dispatcher.addEventListener( NewsEvent.DETAILED_CLICKED, onNewsDetailesClicked );			dispatcher.addEventListener( NewsEvent.NEWS_BACK_TO_LIST_CLICKED, onNewsBackToListClicked );						dispatcher.addEventListener( MapItemEvent.VIDEO_REPORTS_CLICKED, onVideoReportsCalledFromMapItem );			dispatcher.addEventListener( MapItemEvent.PHOTO_REPORTS_CLICKED, onPhotoReportsCalledFromMapItem );			dispatcher.addEventListener( MapItemEvent.COUNTRY_CLICKED, onCountryCalledFromMapItem );						dispatcher.addEventListener( ScreenEvent.RESET_SCROLL_NEEDED, onResetScrollNeeded );			dispatcher.addEventListener( ScreenEvent.ON_OFFSET_LOADING_STARTED, onOffsetLoadingStarted );						dispatcher.addEventListener( PreviewEvent.ON_VIDEO_REPORT_CALLED, onVideoReportCalled );			dispatcher.addEventListener( PreviewEvent.ON_PHOTO_REPORT_CALLED, onPhotoReportCalled );						dispatcher.addEventListener( LotteryEvent.LOTTERY_SELECTED, onLotterySelected );						dispatcher.addEventListener( NavigationEvent.NAVIGATE_TO_PROFILE, onProfileCalled );			dispatcher.addEventListener( NavigationEvent.NAVIGATE_TO_ANNOUNCEMENT, onAnnouncementCalled );						dispatcher.addEventListener( NavigationEvent.NAVIGATE_TO_CONTEST_DETAILED, onContestCalled );						dispatcher.addEventListener( ScrollbarEvent.ON_SET_SCROLL_BY_PIXELS_CALLED, onSetScrollByPixelsCalled );						// Scrollbar						scrollbarView = getChildByName( "scrollbarView_mc" ) as ScrollbarView;			scrollbarView.visible = false;						// UserInfoSection 			userInfoSection = userInfoSection_mc;			userInfoSection.visible = false;						// MainMenu						mainMenu = mainMenu_mc;			mainMenu.visible = false;						// RightMenu			rightMenu = rightMenu_mc;			rightMenu.visible = false;						// ScreenController			addChildAt( scrollContent, 0 );			scrollContent.addChild( screenController );						scrollContent.x = userInfoSection.width + 20;			scrollContent.y = scrollbarView.y;			screenController.width = 515;			screenController.height = scrollbarView.height;			helper.setScreenRectangle( scrollContent.x, scrollContent.y, screenController.width, screenController.height );						scrollMask.y = scrollContent.y;			scrollMask.graphics.beginFill( 0 );			scrollMask.graphics.drawRect( 0, 0, stage.stageWidth, scrollbarView.height );			scrollMask.graphics.endFill();			scrollContent.mask = scrollMask;			screenController.addEventListener( ScreenEvent.HEIGHT_UPDATED, onContentHeightUpdated );			screenController.addEventListener( Event.CHANGE, onScreenChanged );			screenController.visible = false;						Scrollbar.setVertical( scrollContent, scrollMask.getBounds( this ), scrollbarView.getUpBtn(), scrollbarView.getDownBtn(), scrollbarView.getCarret(), scrollbarView.getBounds( scrollbarView ), stage );			scrollbarView.getCarret().addEventListener( Event.CHANGE, onScrolled );						// PopupsController			popupsController = PopupsController.getInstance();			popupsController.init( stage, 0x2b2927, .85 );						// Login section			loginSection = getChildByName( "login_mc" ) as LoginSection;			addChild( loginSection );			loginSection.startProcedure();			loginSection.addEventListener( LoginSectionEvent.COMPLETE, onLoginSectionComplete );			loginSection.addEventListener( LoginSectionEvent.USER_STATUS_DEFINED, onUserStatusDefined );					}				/**		 * 		 * @param	event		 */				private function onSetScrollByPixelsCalled( event:ScrollbarEvent ):void {					}				/**		 * 		 * @param	event		 */				private function onOffsetLoadingStarted( event:ScreenEvent ):void {			Scrollbar.setScrollPositionByPercent( 100, scrollbarView.getCarret() );		}				/**		 * 		 * @param	event		 */				private function onScrolled( event:Event ):void {			var outputEvent:ScrollbarEvent = new ScrollbarEvent( ScrollbarEvent.ON_SCROLLED );			outputEvent.percent = Scrollbar.getPercent( scrollbarView.getCarret() );			screenController.getCurrentScreenInstance().dispatchEvent( outputEvent );		}				/**		 * 		 * @param	event		 */				private function onContestCalled( event:NavigationEvent ):void {			var contests:Contests = screenController.getCurrentScreenInstance() as Contests;			var contestDetailed:ContestDetailed = screenController.addScreen( ContestDetailed ) as ContestDetailed;			contestDetailed.showContest( contests.getSelectedItemID() );			if ( !contestDetailed.hasEventListener( ScreenEvent.GO_BACK ) ) {				contestDetailed.addEventListener( ScreenEvent.GO_BACK, goBackFromContestDetailed )			}			mainMenu.resetSelection();		}				private function goBackFromContestDetailed( event:ScreenEvent ):void {			mainMenu.selectContests();			screenController.back();		}				/**		 * 		 * @param	event		 */				private function onAnnouncementCalled( event:NavigationEvent ):void {			if ( screenController.getCurrentScreenClass() === AnnouncementDetail ) return;			var announcementDetail:AnnouncementDetail = screenController.addScreen( AnnouncementDetail ) as AnnouncementDetail;			mainMenu.resetSelection();			announcementDetail.addEventListener( ScreenEvent.GO_BACK, goBack );			announcementDetail.showAnnouncement( rightMenu.getAnnouncement().getData().id );		}				/**		 * 		 * @param	event		 */				private function onLotterySelected( event:LotteryEvent ):void {			var lotterty:Lottery = screenController.addScreen( Lottery ) as Lottery;			lotterty.showLottery( event.lotteryData );			mainMenu.resetSelection();			if ( !lotterty.hasEventListener( ScreenEvent.GO_BACK ) ) {				lotterty.addEventListener( ScreenEvent.GO_BACK, onBackFromLottery );			}		}				/**		 * 		 * @param	event		 */				private function onUserStatusDefined( event:LoginSectionEvent ):void {			var inviterID:int = helper.getInviterID();			if ( inviterID && inviterID !== helper.getUserID() ) {				provider.confirmEntryeByInvite( inviterID );			}			rightMenu.init();			userInfoSection.showUser();			mainMenu.init();		}				/**		 * 		 * @param	event		 */				private function onVideoReportCalled( event:PreviewEvent ):void {			var videoReportScreen:VideoReport = screenController.addScreen( VideoReport ) as VideoReport;			if ( !videoReportScreen.hasEventListener( ScreenEvent.GO_BACK ) ) {				videoReportScreen.addEventListener( ScreenEvent.GO_BACK, backFromVideoReport );			}			videoReportScreen.loadReport( event.previewData.departure_id, event.previewData.video );		}				/**		 * 		 * @param	event		 */				private function backFromVideoReport( event:ScreenEvent ):void {			while ( screenController.getCurrentScreenInstance() is VideoReport ) {				goBack();			}		}				/**		 * 		 * @param	event		 */				private function onPhotoReportCalled( event:PreviewEvent ):void {			var photogallery:Photogallery = new Photogallery();			photogallery.loadByPreviewData( event.previewData );			popupsController.showPopup( photogallery, true );		}				/**		 * 		 * @param	event		 */				private function onVideoReportsCalledFromMapItem( event:MapItemEvent ):void {			var videoReportScreen:VideoReport = screenController.addScreen( VideoReport ) as VideoReport;			videoReportScreen.setBottomButtonLabel( "СПИСОК СТРАН" );			if ( !videoReportScreen.hasEventListener( ScreenEvent.GO_BACK ) ) {				videoReportScreen.addEventListener( ScreenEvent.GO_BACK, backFromVideoReport );			}			videoReportScreen.showReport( event.itemData );		}				/**		 * 		 * @param	event		 */				private function onPhotoReportsCalledFromMapItem( event:MapItemEvent ):void {			var photoReportScreen:PhotoReport = screenController.addScreen( PhotoReport ) as PhotoReport;			photoReportScreen.setBottomButtonLabel( "СПИСОК СТРАН" );			if ( !photoReportScreen.hasEventListener( ScreenEvent.GO_BACK ) ) {				photoReportScreen.addEventListener( ScreenEvent.GO_BACK, goBack );			}			photoReportScreen.showReport( event.itemData );		}				/**		 * 		 * @param	event		 */				private function onNewsDetailesClicked( event:NewsEvent ):void {			var news:NewsDetail = screenController.addScreen( NewsDetail ) as NewsDetail;			mainMenu.resetSelection();			news.showNews( event.newsID );		}				/**		 * 		 * @param	event		 */				private function onCountryCalledFromMapItem( event:MapItemEvent ):void {			var country:Country = screenController.addScreen( Country ) as Country;			country.showCountry( event.itemData );			if ( !country.hasEventListener( ScreenEvent.GO_BACK ) ) {				country.addEventListener( ScreenEvent.GO_BACK, goBackFromCountry );			}			mainMenu.resetSelection();		}				/**		 * 		 * @param	event		 */				private function onNewsBackToListClicked( event:NewsEvent ):void {			screenController.addScreen( News );			mainMenu.selectNews();		}				/**		 * 		 * @param	event		 */				private function onLoginSectionComplete( event:LoginSectionEvent ):void {			var motionParams:Object = { x: 0, time: .4, transition: "easeOutCubic" };			var rightMenuX:int = rightMenu.x;			mainMenu.visible = true;			mainMenu.x = -mainMenu.width;			userInfoSection.visible = true;			userInfoSection.x = mainMenu.x;						Tweener.addTween( mainMenu, motionParams );			Tweener.addTween( userInfoSection, motionParams );						rightMenu.x = stage.stage.width;			motionParams.x = rightMenuX;			Tweener.addTween( rightMenu, motionParams );						screenController.visible = true;			screenController.addScreen( Departures );						userInfoSection.visible = true;						rightMenu.visible = true;						popupsController.setBlockRect( 0x2b2927, .85 );			achievementsController.init( stage );		}				/**		 * 		 * @param	event		 */				private function onScreenChanged( event:Event ):void {			Scrollbar.reset( scrollbarView.getCarret() );			onContentHeightUpdated();		}				/**		 * 		 * @param	event		 */				private function onContentHeightUpdated( event:ScreenEvent = null ):void {			if( event ) event.stopImmediatePropagation();			Scrollbar.update( scrollbarView.getCarret() );			scrollbarView.visible = Scrollbar.isNeeded( scrollbarView.getCarret() );		}				/**		 * 		 * @param	event		 */				private function navigateToPage( event:NavigationEvent ):void {			var pageClass:Class;			screenController.addScreen( pageClassesByEventTypes[ event.type ] );		}				/**		 * 		 * @param	event		 */				private function onResetScrollNeeded( event:ScreenEvent ):void {			Scrollbar.reset( scrollbarView.getCarret() );			//TODO: сделать плавное прокручивание		}				/**		 * 		 * @param	event		 */				private function goBackFromCountry( event:ScreenEvent ):void {			mainMenu.selectDepartures();			goBack();		}				/**		 * 		 * @param	event		 */				private function goBack( event:ScreenEvent = null ):void {			screenController.back();		}				/**		 * 		 * @param	event		 */				private function onProfileCalled( event:NavigationEvent ):void {			screenController.addScreen( Profile );			mainMenu.resetSelection();		}				/**		 * 		 */				private function onBackFromLottery( event:ScreenEvent ):void {			screenController.back();			mainMenu.selectContests();		}	}	}