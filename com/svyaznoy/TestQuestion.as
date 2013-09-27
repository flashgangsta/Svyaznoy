package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.gui.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class TestQuestion extends Sprite {
		
		private const IMAGE_MARGIN:int = 25;
		
		private var title:TextField;
		private var message:DynamicContentViewer;
		private var buttonA:TestAnswerButton;
		private var buttonB:TestAnswerButton;
		private var buttonC:TestAnswerButton;
		private var buttonD:TestAnswerButton;
		private var data:Object;
		private var answer:String;
		private var imageArea:Rectangle;
		private var divider:Sprite;
		
		public function TestQuestion( data:Object ) {
			this.data = data;
			title = getChildByName( "title_txt" ) as TextField;
			message = new DynamicContentViewer();
			divider = getChildByName( "divider_mc" ) as Sprite;
			buttonA = getChildByName( "a_mc" ) as TestAnswerButton;
			buttonB = getChildByName( "b_mc" ) as TestAnswerButton;
			buttonC = getChildByName( "c_mc" ) as TestAnswerButton;
			buttonD = getChildByName( "d_mc" ) as TestAnswerButton;
			
			buttonA.variant = "А";
			buttonB.variant = "Б";
			buttonC.variant = "В";
			buttonD.variant = "Г";
			
			buttonA.index = 1;
			buttonB.index = 2;
			buttonC.index = 3; 
			buttonD.index = 4;
			
			buttonA.setLabel( data.answer1 );
			buttonB.setLabel( data.answer2 );
			buttonC.setLabel( data.answer3 );
			buttonD.setLabel( data.answer4 );
			
			buttonA.addEventListener( MouseEvent.CLICK, onSelected );
			buttonB.addEventListener( MouseEvent.CLICK, onSelected );
			buttonC.addEventListener( MouseEvent.CLICK, onSelected );
			buttonD.addEventListener( MouseEvent.CLICK, onSelected );
			
			imageArea = new Rectangle( IMAGE_MARGIN, Math.ceil( message.y + message.height ), width - IMAGE_MARGIN * 2, divider.y - IMAGE_MARGIN );
			
			title.text = data.title;
			message.displayData( data.content );
			message.y = Math.ceil( title.height ) + 2;
			addChild( message );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getAnswer():String {
			return answer;
		}
		
		public function dispose():void {
			//TODO: сделать диспос
		}
		
		private function onSelected( event:MouseEvent ):void {
			var button:TestAnswerButton = event.currentTarget as TestAnswerButton;
			answer = data.id + ":" + button.index;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}

}