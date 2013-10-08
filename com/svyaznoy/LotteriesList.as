package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.IconsListEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	[Event(name = "iconSelected", type = "com.svyaznoy.events.IconsListEvent")]
	
	public class LotteriesList extends IconsList {
		
		public static const DISPLAYED_LENGTH:int = 6;
		
		private const MARGIN:int = 14;
		private const MARGIN_Y:int = 30;
		
		private var moreButton:Button;
		private var iconsContainer:Sprite = new Sprite();
		private var datasList:Array;
		private var _height:int = 0;
		
		/**
		 * 
		 */
		
		public function LotteriesList() {
			moreButton = getChildByName( "moreButton_mc" ) as Button;
			iconsContainer.y = MARGIN_Y;
			addChild( iconsContainer );
		}
		
		/**
		 * 
		 * @param	listToShow
		 */
		
		public function showList( datasList:Array ):void {
			clear();
			
			this.datasList = datasList;
			var iconsList:Vector.<IconListItem> = new Vector.<IconListItem>();
			var icon:IconListItem;
			var data:Object;
			var winnderData:Object;
			var name:String;
			
			moreButton.visible = datasList.length > DISPLAYED_LENGTH;
			
			for ( var i:int = 0; i < datasList.length; i++ ) {
				data = datasList[ i ];
				winnderData = data.winner;
				name = winnderData.last_name + "\n" + winnderData.first_name;
				
				icon = new IconListItem( data.title, name, null, winnderData.user.username );
				icon.x = (icon.width + MARGIN) * i;
				icon.addEventListener( MouseEvent.CLICK, onItemSelected );
				icon.buttonMode = true;
				iconsContainer.addChild( icon );
				iconsList.push( icon );
				_height = Math.max( _height, icon.height );
			}
			
			moreButton.y = MappingManager.getBottom( iconsContainer, this ) + MARGIN;
			
			//TODO: сделать дозагрузку лоттерей по нажатию кнопки
		}
		
		override public function get height():Number {
			return super.height;
		}
		
		/**
		 * 
		 */
		
		private function clear():void {
			var icon:IconListItem;
			
			while ( iconsContainer.numChildren ) {
				icon = iconsContainer.getChildAt( 0 ) as IconListItem;
				icon.removeEventListener( MouseEvent.CLICK, onItemSelected );
				icon.dispose();
				iconsContainer.removeChild( icon );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onItemSelected( event:MouseEvent ):void {
			var data:Object = datasList[ iconsContainer.getChildIndex( event.currentTarget as DisplayObject ) ];
			var outputEvent:IconsListEvent = new IconsListEvent( IconsListEvent.ICON_SELECTED );
			outputEvent.data = data;
			dispatchEvent( outputEvent );
		}
		
	}

}