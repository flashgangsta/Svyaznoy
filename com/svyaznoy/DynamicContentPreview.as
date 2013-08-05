package com.svyaznoy {
	import com.flashgangsta.ui.Scrollbar;
	import com.flashgangsta.utils.Queue;
	import com.svyaznoy.events.DynamicItemEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class DynamicContentPreview extends Sprite {
		
		private var viewer:DynamicContentViewer = new DynamicContentViewer();
		private var container:MovieClip = new MovieClip();
		private var scrollbarView:ScrollbarView;
		private var scrollMask:Sprite = new Sprite();
		private var queue:Queue;
		
		public function DynamicContentPreview() {
			scrollMask = getChildByName( "mask_mc" ) as Sprite;
			
			scrollbarView = getChildByName( "scrollbarView_mc" ) as ScrollbarView;
			scrollbarView.visible = false;
			
			viewer.width = 515;
			viewer.addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
			
			container.mask = scrollMask;
			
			
			
			addChild( container );
			container.addChild( viewer );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			ExternalInterface.addCallback( "setContent", setContent );
			
			var t:String = <![CDATA[**Вызываем Огонь на себя**

Стихия, которая приводила в священный трепет наших первопредков, покорилась команде «Связного». В конце апреля в вечном городе Риме состоялся грандиозный финал игры «Сокровища “Связного”. В поисках Магистерия».

![image](http://es.svyaznoy.ru/uploads/content/QG2qAk1iWL.jpg)

Рим встретил наших героев дождем, но это не испортило никому настроение, тем более что «связновцы»  разу смогли укрыться в уютном отеле Sheraton Roma Hotel& Conference, а самые отважные отправились на разведку в город. На следующее утро искателей сокровищ «Связного» ждал солнечный день, начавшийся с настоящего итальянского завтрака, после которого наступило время подготовки к финальному этапу игры.
Участники команд изучали конкурсные задания в теории и на практике, распределяли, кому в каком остязании следует участвовать. Многие наши сотрудники имеют различные хобби и занимаются спортом, кто-то  влекается фотографией, а кто-то обладает редкой эрудицией… Все эти таланты необходимо было выявить и учесть, чтобы уверенно выступить на предстоящих испытаниях.

После того как все «ордена» – команды досконально разобрали финальный этап игры, был объявлен перерыв с плотным обедом и экскурсией по центру Рима. «Связновцы» увидели Колизей и собор Святого Петра, фонтан Треви и Пантеон, Римский форум и многое-многое другое. После подготовка возобновилась, и до позднего вечера гости отеля в лобби и возле бассейна могли видеть и слышать ребят в белых футболках с загадочной символикой, обсуждавших между собой странные и непонятные непосвященным вещи.

Вечер и ночь пролетели незаметно. Наступило утро 24 апреля – день битвы за «Огонь». Ордена «Связного» отправились к замку Castello Orsini, где все было готово для захватывающей игры. Весело, отважно наши  оллеги ехали навстречу испытаниям. Шесть орденов «Связного» вступили за ограду замка, построенного в X веке на руинах древней крепости Сабина. Три сотни уверенных в себе бойцов «Связного», а на кону – сто тысяч рублей каждому победителю и философский камень Магистерий! В стенах замка Искателей уже ждали римские гладиаторы, Торговец-мавр и другие персонажи. Приветствовал героев сам Великий Магистр  Империи «Связного» Дионис. Приключение, которого так долго ждали, началось. Участники встретились со сложнейшими испытаниями. Только вслушайтесь в их названия – «Пила», «Кран Леонардо», «Кровавый бой»…Орденам помогала сила и ловкость, предприимчивость и находчивость, ну и, конечно, силы  покоренных ранее стихий: Вода – Атака, Земля – Защита, Воздух – Скорость. В соревнованиях можно было выиграть универсальные артефакты Огня или выменять их у Торговца-мавра на золотые монеты. Вожделенные монеты участники находили в потаенных уголках замка, а также получали как награду за выполнение мини-квестов.
]]>;
			
			//setContent( t );
			
		}
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			Scrollbar.update( scrollbarView.getCarret() );
			scrollbarView.visible = Scrollbar.isNeeded( scrollbarView.getCarret() );
			//for ( var i:int = 0; i < 
		}
		
		private function setContent( data:String ):void {
			if ( !stage ) {
				queue = new Queue();
				queue.add( setContent, data );
				return;
			}
			viewer.clear();
			Scrollbar.reset( scrollbarView.getCarret() );
			viewer.displayData( data );
			
		}
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Scrollbar.setVertical( container, scrollMask.getBounds( this ), scrollbarView.getUpBtn(), scrollbarView.getDownBtn(), scrollbarView.getCarret(), scrollbarView.getBounds( scrollbarView ), stage );
			
			if ( queue ) {
				queue.applyAll();
				queue = null;
			}
		}
		
	}

}