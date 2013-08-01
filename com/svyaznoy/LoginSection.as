package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.flashgangsta.events.PopupsControllerEvent;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.PopupEvent;
	import com.svyaznoy.events.ProviderEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class LoginSection extends Sprite {
		
		private var popupController:PopupsController = PopupsController.getInstance();
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		private var map:Bitmap;
		private var showTraces:Boolean = false;
		
		/**
		 * 
		 */
		
		public function LoginSection() {
			var mapSprite:Sprite = getChildByName( "map_mc" ) as Sprite;
			var matrix:Matrix = new Matrix();
			matrix.scale( mapSprite.scaleX, mapSprite.scaleY );
			map = new Bitmap();
			map.bitmapData = new BitmapData( mapSprite.width, mapSprite.height, true, 0x00000000 );
			map.bitmapData.draw( mapSprite, matrix );
			map.x = mapSprite.x;
			map.y = mapSprite.y;
			removeChildren();
			addChild( map );
			mapSprite = null;
			
			popupController.addEventListener( PopupsControllerEvent.CLOSING, onPopupClosing );
		}
		
		/**
		 * 
		 */
		
		public function startProcedure():void {
			provider.login();
			provider.addEventListener( ProviderEvent.ON_LOGGED_IN, onLoggedIn );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoggedIn( event:ProviderEvent ):void {
			provider.removeEventListener( ProviderEvent.ON_LOGGED_IN, onLoggedIn );
			gotoEmployeeConfirmation();
		}
		
		/**
		 * 
		 */
		
		private function gotoEmployeeConfirmation():void {
			var employeeConfirmation:EmployeeConfirmation = new EmployeeConfirmation();
			employeeConfirmation.addEventListener( PopupEvent.AGREE, onUserToldThatHeEmployee );
			employeeConfirmation.addEventListener( PopupEvent.REJECT, onUserToldThatHeGuest );
			popupController.showPopup( employeeConfirmation );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onUserToldThatHeEmployee( event:PopupEvent ):void {
			closePopup();
			if ( helper.getUserData().employee ) {
				if( showTraces ) trace( "EMPLOYEE MODE" );
				helper.isEmployeeMode = true;
				gotoIntroVideo();
			} else {
				gotoRegistration();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onUserToldThatHeGuest( event:PopupEvent ):void {
			closePopup();
			if( showTraces ) trace( "GUEST MODE" );
			helper.isEmployeeMode = false;
			gotoIntroVideo();
		}
		
		/**
		 * 
		 */
		
		private function gotoRegistration():void {
			var registration:Registration = new Registration();
			registration.addEventListener( PopupsControllerEvent.CLOSED, onRegistartionClosedByUser );
			registration.addEventListener( Event.COMPLETE, onRegistrationComplete );
			popupController.showPopup( registration, true );
			popupController.setBlockRect( 0, 0 );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRegistrationComplete( event:Event ):void {
			var registration:Registration = event.currentTarget as Registration;
			popupController.hidePopup();
			registration.removeEventListener( PopupsControllerEvent.CLOSED, onRegistartionClosedByUser );
			gotoPersonalCodeInputing();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRegistartionClosedByUser( event:PopupsControllerEvent ):void {
			removePopupListeners();
			event.popup.removeEventListener( PopupsControllerEvent.CLOSED, onRegistartionClosedByUser );
			gotoEmployeeConfirmation();
		}
		
		/**
		 * 
		 */
		
		private function gotoPersonalCodeInputing():void {
			var personalCodeInputing:PersonalCodeInputing = new PersonalCodeInputing();
			personalCodeInputing.addEventListener( Event.COMPLETE, onPersonalCodeConfirmed );
			popupController.showPopup( personalCodeInputing );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPersonalCodeConfirmed( event:Event ):void {
			if( showTraces ) trace( "EMPLOYEE MODE" );
			helper.isEmployeeMode = true;
			event.currentTarget.removeEventListener( Event.COMPLETE, onPersonalCodeConfirmed );
			popupController.hidePopup();
			gotoIntroVideo();
		}
		
		/**
		 * 
		 */
		
		private function gotoIntroVideo():void {
			if ( helper.getUserData().intro ) {
				if( showTraces ) trace( "Show intro video" );
				provider.getIntro();
				provider.addEventListener( ProviderEvent.ON_INTRO_DATA, onIntroData );
				
			} else {
				if( showTraces ) trace( "Intro video disabled by user" );
				gotoApplication();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIntroData( event:ProviderEvent ):void {
			var introVideo:IntroVideo = new IntroVideo( event.data );
			introVideo.addEventListener( PopupsControllerEvent.CLOSED, onInroVideoClosed );
			popupController.showPopup( introVideo, true );
			popupController.setBlockRect( 0, 0 );
			provider.removeEventListener( ProviderEvent.ON_INTRO_DATA, onIntroData );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onInroVideoClosed( event:PopupsControllerEvent ):void {
			event.popup.removeEventListener( PopupsControllerEvent.CLOSED, onInroVideoClosed );
			gotoApplication();
		}
		
		/**
		 * 
		 */
		
		private function gotoApplication():void {
			if( showTraces ) trace( "gotoApplication" );
			Tweener.addTween( map, { y: map.y - 200, alpha: 0, time: .4, transition: "easeInCubic", onComplete: onSectionHided } );
		}
		
		/**
		 * 
		 */
		 
		private function onSectionHided():void {
			parent.removeChild( this );
			dispatchEvent( new Event( Event.COMPLETE ) );
			if( showTraces ) trace( "login section removed" );
		}
		
		/**
		 * 
		 */
		
		private function closePopup():void {
			popupController.hidePopup();
		}
		
		/**
		 * 
		 */
		
		private function removePopupListeners():void {
			var currentPopup:Popup = popupController.getCurrentPopup() as Popup;
			switch( Object( currentPopup ).constructor ) {
				case EmployeeConfirmation:
					currentPopup.removeEventListener( PopupEvent.AGREE, onUserToldThatHeEmployee );
					currentPopup.removeEventListener( PopupEvent.REJECT, onUserToldThatHeGuest );
					break;
				case Registration:
					currentPopup.removeEventListener( Event.COMPLETE, onRegistrationComplete );
					break;
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPopupClosing( event:PopupsControllerEvent ):void {
			var currentPopup:Popup = popupController.getCurrentPopup() as Popup;
			currentPopup.dispose();
			removePopupListeners();
		}
		
	}

}