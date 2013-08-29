package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.LoginSectionEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Paging;
	import com.svyaznoy.modules.Voting;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Test extends Sprite {
		
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		private var popupsController:PopupsController;
		
		/**
		 * 
		 */
		
		public function Test() {
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
                    "Гранатомёт",
                    "Санки",
                    "Коржик",
                    "Яйцеклетку",
                    "Слюни",
                    "Батон",
                    "Девок",
                    "Водку"
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
			
			var dataSingle2:Array = [
            {
                "id": "4",
                "title": "Слушай, а… Сколько сейчас времени-то, не знаешь? Так, примерно, можешь почувствовать?",
                "options": "1\n2\n3\n4\n5\n6\n7\n8\n9\n10",
                "allow_multiple": "1",
                "own_answer": "1",
                "vote_required": "0",
                "secured": "0",
                "status": "1",
                "created_at": "2013-08-28 12:48:08",
                "updated_at": "2013-08-28 12:51:35",
                "options_array": [
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "10"
                ],
                "is_answered": false
            }
			];
			
			var e:ProviderEvent = new ProviderEvent( ProviderEvent.ON_RANDOM_SURVEYS );
			e.data = dataSingle2;
			onSurveys( e );
			
			
			
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