package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.modules.Voting;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Test extends Sprite {
		
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		
		public function Test() {
			//Helper
			helper.isDebug = ( loaderInfo.url.indexOf( "http" ) !== 0 );
			ContentLoader.context = helper.loaderContext;
			//Provider
			provider.init();
			
			provider.getRandomSurveys();
			provider.addEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			
			
		}
		
		private function onSurveys( event:ProviderEvent ):void {
			var surveyData:Object = event.data[ 0 ];
			provider.removeEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			var voting:Voting = new Voting();
			voting.init( surveyData );
			
			addChild( voting );
		}
		
	}

}