package com.svyaznoy {
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.InputTextfieldEvent;
	import com.svyaznoy.events.PopupEvent;
	import com.svyaznoy.events.ProviderErrorEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.InputTextfield;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class PersonalCodeInputing extends Popup {
		
		private var codeLabel:InputTextfield;
		private var submitButton:Button;
		private var popupsController:PopupsController = PopupsController.getInstance();
		private var provider:Provider = Provider.getInstance();
		private var data:Object;
		
		/**
		 * 
		 */
		
		public function PersonalCodeInputing() {
			codeLabel = getChildByName( "code_mc" ) as InputTextfield;
			submitButton = getChildByName( "submitButton_mc" ) as Button;
			
			submitButton.setLabel( "Завершить регистрацию".toUpperCase() );
			codeLabel.setErrorMessage( "Персональный код не указан, либо указан не верно" );
			
			codeLabel.setFocus();
			
			codeLabel.addEventListener( InputTextfieldEvent.SUBMIT, onSubmitCalled );
			submitButton.addEventListener( MouseEvent.CLICK, onSubmitCalled );
			addEventListener( PopupEvent.ENTER_ON_KEYBOARD_PRESS, onSubmitCalled );
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
			codeLabel.removeEventListener( InputTextfieldEvent.SUBMIT, onSubmitCalled );
			submitButton.removeEventListener( MouseEvent.CLICK, onSubmitCalled );
			removeEventListener( PopupEvent.ENTER_ON_KEYBOARD_PRESS, onSubmitCalled );
			provider.removeEventListener( ProviderEvent.ON_EMPLOYEE_CONFIRMED, onEmployeeConfirmed );
			provider.removeEventListener( ProviderErrorEvent.ON_EMPLOYEE_CONFIRMATION_ERROR, onEmployeeConfirmationError );
			codeLabel.dispose();
			submitButton.dispose();
			
			codeLabel = null;
			submitButton = null;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getData():Object {
			return data;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSubmitCalled( event:Event ):void {
			var isValid:Boolean = checkInputsValidity();
			if ( isValid ) {
				popupsController.lock();
				provider.confirmEmployee( codeLabel.text );
				if( !provider.hasEventListener( ProviderEvent.ON_EMPLOYEE_CONFIRMED ) ) {
					provider.addEventListener( ProviderEvent.ON_EMPLOYEE_CONFIRMED, onEmployeeConfirmed );
					provider.addEventListener( ProviderErrorEvent.ON_EMPLOYEE_CONFIRMATION_ERROR, onEmployeeConfirmationError );
				}
			} else {
				codeLabel.showError();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onEmployeeConfirmationError( event:ProviderErrorEvent ):void {
			codeLabel.showError();
			popupsController.unlock();
		}
		
		/**
		 * 
		 */
		
		private function checkInputsValidity():Boolean {
			return Boolean( codeLabel.text.length );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onEmployeeConfirmed( event:ProviderEvent ):void {
			data = event.data;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}

}