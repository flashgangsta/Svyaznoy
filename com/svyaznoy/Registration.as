package com.svyaznoy {
	import com.flashgangsta.utils.EmailValidator;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.InputTextfieldEvent;
	import com.svyaznoy.events.PopupEvent;
	import com.svyaznoy.events.ProviderErrorEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.InputTextfield;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Registration extends Popup {
		
		const CODE_ERROR_MESSAGE_DEFAULT:String = "Штрих код не указан или указан неверно";
		const CODE_ERROR_MESSAGE_404:String = "Штрих код указан невено для этого e-mail";
		
		private var codeLabel:InputTextfield;
		private var emailLabel:InputTextfield;
		private var registerButton:Button;
		private var provider:Provider = Provider.getInstance();
		private var popupsController:PopupsController = PopupsController.getInstance();
		
		/**
		 * 
		 */
		
		public function Registration() {
			super.isModal = true;
			
			registerButton = getChildByName( "register_mc" ) as Button;
			codeLabel = getChildByName( "code_mc" ) as InputTextfield;
			emailLabel = getChildByName( "email_mc" ) as InputTextfield;
			
			codeLabel.setErrorMessage( CODE_ERROR_MESSAGE_DEFAULT );
			emailLabel.setErrorMessage( "E-mail не указан, либо указан неверно" );
			
			registerButton.addEventListener( MouseEvent.CLICK, onRegisterClicked );
			
			codeLabel.setFocus();
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			
			codeLabel.removeEventListener( InputTextfieldEvent.SUBMIT, onSubmitClicked );
			emailLabel.removeEventListener( InputTextfieldEvent.SUBMIT, onSubmitClicked );
			removeEventListener( PopupEvent.ENTER_ON_KEYBOARD_PRESS, onSubmitClicked );
			provider.removeEventListener( ProviderEvent.ON_EMPLOYEE_SET, onEmployeeSet );
			provider.removeEventListener( ProviderErrorEvent.ON_EMPLOYEE_SET_ERROR, onEmployeeSetError );
			
			codeLabel.dispose();
			emailLabel.dispose();
			codeLabel = null;
			emailLabel = null;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			codeLabel.addEventListener( InputTextfieldEvent.SUBMIT, onSubmitClicked );
			emailLabel.addEventListener( InputTextfieldEvent.SUBMIT, onSubmitClicked );
			addEventListener( PopupEvent.ENTER_ON_KEYBOARD_PRESS, onSubmitClicked );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSubmitClicked( event:InputTextfieldEvent = null ):void {
			onRegisterClicked();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRegisterClicked( event:MouseEvent = null ):void {
			var isValid:Boolean = checkInputsValidity();
			if ( isValid ) {
				popupsController.lock();
				provider.setEmployee( codeLabel.text, emailLabel.text );
				if( !provider.hasEventListener( ProviderEvent.ON_EMPLOYEE_SET ) ) {
					provider.addEventListener( ProviderEvent.ON_EMPLOYEE_SET, onEmployeeSet );
					provider.addEventListener( ProviderErrorEvent.ON_EMPLOYEE_SET_ERROR, onEmployeeSetError );
				}
			}
			codeLabel.setErrorMessage( CODE_ERROR_MESSAGE_DEFAULT );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onEmployeeSetError( event:ProviderErrorEvent ):void {
			popupsController.unlock();
			codeLabel.setErrorMessage( CODE_ERROR_MESSAGE_404 );
			codeLabel.showError();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onEmployeeSet( event:ProviderEvent ):void {
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function checkInputsValidity():Boolean {
			var result:Boolean = false;
			if ( !codeLabel.text.length ) {
				codeLabel.showError();
			} else if ( !EmailValidator.check( emailLabel.text ) ) {
				emailLabel.showError();
			} else {
				result = true;
			}
			return result;
		}
		
	}

}