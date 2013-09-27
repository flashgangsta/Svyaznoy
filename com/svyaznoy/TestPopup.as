package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Button;
	import com.svyaznoy.gui.MiniPreloader;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestPopup extends Popup {
		
		private var title:TextField;
		private var message:TextField;
		private var imageArea:DisplayObject;
		private var submit:Button;
		private var preloader:MiniPreloader = new MiniPreloader();
		private var testID:int;
		private var loader:ProviderURLLoader;
		private var data:Object;
		private var questions:Array;
		private var previewLoader:ContentLoader;
		private var provider:Provider = Provider.getInstance();
		private var previewBitmap:Bitmap;
		private var answers:Array = [];
		private var question:TestQuestion;
		private var resultMessage:TextField;
		private var batterysLabel:TextField;
		private var batterysIcon:Sprite;
		private var endButton:Button;
		
		public function TestPopup( testID:int ) {
			this.testID = testID;
			title = getChildByName( "title_txt" ) as TextField;
			message = getChildByName( "message_txt" ) as TextField;
			imageArea = getChildByName( "imageArea_mc" );
			submit = getChildByName( "submit_mc" ) as Button;
			endButton = getChildByName( "endButton_mc" ) as Button;
			resultMessage = getChildByName( "resultMessage_txt" ) as TextField;
			batterysLabel = getChildByName( "batterysLabel_txt" ) as TextField;
			batterysIcon = getChildByName( "batterysIcon_mc" ) as Sprite;
			
			title.visible = message.visible = resultMessage.visible = batterysLabel.visible = batterysIcon.visible = endButton.visible = false;
			
			MappingManager.setAlign( preloader, background.getBounds( this ) );
			addChild( preloader );
			
			loader = provider.getTestByID( testID );
			loader.addEventListener( ProviderEvent.ON_TEST, onTestData );
			
			endButton.addEventListener( MouseEvent.CLICK, closeTest );
			endButton.setLabel( "Вернуться к приложению".toUpperCase() );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function closeTest( event:MouseEvent ):void {
			close();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTestData( event:ProviderEvent ):void {
			loader = event.currentTarget as ProviderURLLoader;
			loader.removeEventListener( ProviderEvent.ON_TEST, onTestData );
			
			hidePreloader();
			
			data = event.data;
			questions = data.questions;
			title.text = data.title;
			message.text = data.content;
			
			var previewPath:String = data.image_with_path;
			
			if( previewPath ) {
				previewLoader = new ContentLoader();
				previewLoader.load( data.image_with_path );
				previewLoader.addEventListener( Event.COMPLETE, onPreviewLoaded );
			}
			
			submit.addEventListener( MouseEvent.CLICK, onStartClicked );
			
			title.visible = true;
			message.visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onStartClicked( event:Event ):void {
			title.visible = message.visible = submit.visible = false;
			if ( previewBitmap ) previewBitmap.visible = title.visible;
			showQuestion();
		}
		
		/**
		 * 
		 */
		
		private function showQuestion():void {
			var data:Object = questions[ answers.length ];
			question = new TestQuestion( data );
			question.addEventListener( Event.COMPLETE, onAnswer );
			MappingManager.setAlign( question, background.getBounds( this ) );
			addChild( question );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAnswer( event:Event ):void {
			question.removeEventListener( Event.COMPLETE, onAnswer );
			removeChild( question );
			answers.push( question.getAnswer() );
			question.dispose();
			
			if ( answers.length === questions.length ) {
				showResults();
			} else {
				showQuestion();
			}
		}
		
		/**
		 * 
		 */
		
		private function showResults():void {
			var loader:ProviderURLLoader = provider.sendTestResults( testID, answers.toString() );
			loader.addEventListener( ProviderEvent.ON_TEST_RESULT_SENT, onResultsSent );
			showPreloader();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onResultsSent( event:ProviderEvent ):void {
			var resultData:Object = event.data;
			hidePreloader();
			resultMessage.text = ("Вы ответили правильно на " + resultData.correct_answers + " из " + questions.length + "\n\n\n").toUpperCase();
			resultMessage.appendText( resultData.test.ending.toUpperCase() );
			for ( var i:int = resultMessage.numLines; i < 12; i++ ) {
				resultMessage.appendText( "\n" );
			}
			resultMessage.appendText( "Ваша награда:".toUpperCase() );
			batterysLabel.text = event.data.received_points;
			resultMessage.visible = batterysLabel.visible = batterysIcon.visible = endButton.visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPreviewLoaded( event:Event ):void {
			previewBitmap = previewLoader.getContent() as Bitmap;
			previewBitmap.smoothing = true;
			MappingManager.setScaleOnlyReduce( previewBitmap, imageArea.width, imageArea.height );
			previewBitmap.x = imageArea.x + MappingManager.getCentricPoint( imageArea.width, previewBitmap.width );
			previewBitmap.y = imageArea.y;
			addChild( previewBitmap );
			previewBitmap.visible = title.visible;
		}
		
		/**
		 * 
		 */
		
		private function hidePreloader():void {
			preloader.stop();
			preloader.visible = false;
		}
		
		/**
		 * 
		 */
		
		private function showPreloader():void {
			addChild( preloader );
			preloader.resume();
			preloader.visible = true;
		}
		
	}

}