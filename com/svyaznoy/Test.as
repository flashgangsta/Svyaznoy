package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.events.LoginSectionEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Paging;
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
			
			//provider.getRandomSurveys();
			//provider.addEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			var dataMulty:Array = [
            {
                "id": "1",
                "title": "В следующий выезд я возьму с собой",
                "options": "Компас\nФонарик\nСухофрукты\nТопор\nГранатомёт\nБульдозер",
                "allow_multiple": "1",
                "own_answer": "0",
                "vote_required": "1",
                "secured": "0",
                "status": "1",
                "created_at": "2013-08-12 06:46:32",
                "updated_at": "2013-08-13 12:01:54",
                "options_array": [
                    "Компас",
                    "Фонарик",
                    "Сухофрукты",
                    "Топор",
                    "Гранатомёт"/*,
                    "Санки",
                    "Коржик",
                    "Яйцеклетку",
                    "Слюни",
                    "Батон",
                    "Девок",
                    "Водку"*/
                ],
                "is_answered": true
			}];
			
			var dataSingle:Array = [
            {
                "id": "2",
                "title": "Какой самый известный самолет на тихоокеанском театре военных действий?",
                "options": "Б-17 Летающая крепость\nБ-24 Либератор\nБ-25 Митчел\nF-6 Hellcat\nMitsubishi A6M Zero\nТигр",
                "allow_multiple": "0",
                "own_answer": "0",
                "vote_required": "1",
                "secured": "0",
                "status": "1",
                "created_at": "2013-08-13 11:33:48",
                "updated_at": "2013-08-13 11:41:25",
                "options_array": [
                    "Б-17 Летающая крепость",
                    "Б-24 Либератор",
                    "Б-25 Митчел",
                    "F-6 Hellcat",
                    "Mitsubishi A6M Zero",
                    "Тигр"
                ],
                "is_answered": true
            }
        ];
			
			var event:ProviderEvent = new ProviderEvent( ProviderEvent.ON_RANDOM_SURVEYS );
			event.data = dataMulty;
			onSurveys( event );
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSurveys( event:ProviderEvent ):void {
			var surveyData:Object = event.data[ 0 ];
			provider.removeEventListener( ProviderEvent.ON_RANDOM_SURVEYS, onSurveys );
			
			var voting:Voting = new Voting();
			voting.x = 500;
			voting.y = 287;
			voting.init( surveyData );
			
			addChild( voting );
		}
	}

}