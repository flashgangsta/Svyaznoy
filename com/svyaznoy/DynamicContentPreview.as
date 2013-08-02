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
			
			//setContent( "Видео с ошибкой:\n![yourtube](er1wrw)\n\nХорошее видео:\n![youtube](5qWLDgBAPo4)\n\nКартинка\n![image](http://markitup.jaysalvat.com/examples/markitup/preview/picture.png)\n\n**Жирный текст**\n\nДатой основания компании считается 9 октября 1995 года. Торговая точка на «Горбушке», офис площадью 20 квадратных метров – тогда в штате фирмы были всего 5 сотрудников. Начав с минимального оборотного капитала, компания за короткий срок превратилась в крупное и стремительно развивающееся коммерческое предприятие. К 2000 году были подписаны прямые контракты с ведущими производителями персональной аудиотехники и средств связи, такими как Siemens, Motorola, Philips, Ericsson и др. К началу 2002 года компании удалось занять лидирующие позиции: доля рынка по оптовым продажам аудиотехники и телефонии достигла 10%.\nВ результате правильной оценки перспектив развития рынка сотовой связи в 2001 году было принято стратегическое решение о концентрации усилий в области развития розничных продаж.\n\nТелефон: 8-800-700-43-43 (бесплатно для звонков со всей России)\nКруглосуточная служба клиентской" );
			
		}
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			Scrollbar.update( scrollbarView.getCarret() );
			scrollbarView.visible = Scrollbar.isNeeded( scrollbarView.getCarret() );
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