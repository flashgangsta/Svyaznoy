package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.PreviewsTableEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	 [Event(name="onPreviewSelected", type="com.svyaznoy.events.PreviewsTabEvent")]
	
	public class PreviewsTable extends Sprite {
		
		private const NUM_CELLS:int = 3;
		
		private var itemsList:Vector.<PreviewItem> = new Vector.<PreviewItem>();
		private var selectedItem:PreviewItem;
		private var vMargin:int;
		private var hMargin:int;
		
		/**
		 * 
		 */
		
		public function PreviewsTable() {
			
		}
		
		/**
		 * 
		 * @param	videosList
		 */
		
		public function fill( previewItemsList:Array, itemClass:Class, ignorableIndex:int = -1, itemWidth:int = 158, itemHeight:int = 126, vMargin:int = 10, hMargin:int = 21  ):void {
			clear();
			
			var item:PreviewItem;
			var row:Sprite = new Sprite();
			this.hMargin = hMargin;
			this.vMargin = vMargin;
			
			addChild( row );
			
			for ( var i:int = 0; i < previewItemsList.length; i++ ) {
				item = new itemClass();
				item.addEventListener( MouseEvent.CLICK, onItemClicked );
				item.width = itemWidth;
				item.height = itemHeight;
				item.displayData( previewItemsList[ i ] );
				itemsList.push( item );
				
				if ( i === ignorableIndex ) {
					selectedItem = item;
					continue;
				}
				
				item.x = Math.round( itemWidth + hMargin ) * row.numChildren;
				row.addChild( item );
				
				if ( row.numChildren === NUM_CELLS ) {
					row = new Sprite();
					row.y = height + vMargin;
					addChild( row );
				}
			}
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getSelectedItemData():Object {
			return selectedItem.getData();
		}
		
		/**
		 * Перестраивает уже существующую таблицу (после выбора видео)
		 * @param	ignorableIndex индекс айтема который не нужно выводить в таблице
		 */
		
		public function refill( ignorableIndex:int = -1 ):void {
			var item:PreviewItem;
			var row:Sprite = getChildAt( 0 ) as Sprite;
			var rowY:int = 0;
			row.removeChildren();
			
			for ( var i:int = 0; i < itemsList.length; i++ ) {
				item = itemsList[ i ];
				if ( i === ignorableIndex ) {
					selectedItem = item;
					continue;
				}
				
				item.x = Math.round( item.width + hMargin ) * row.numChildren;
				row.addChild( item );
				
				if ( row.numChildren === NUM_CELLS ) {
					rowY = MappingManager.getBottom( row, this ) + vMargin;
					row = getChildAt( Math.ceil( i / NUM_CELLS ) ) as Sprite;
					row.removeChildren();
					row.y = rowY;
				}
			}
		}
		
		/**
		 * 
		 */
		
		private function clear():void {
			var row:Sprite;
			var item:PreviewItem;
			while ( numChildren ) {
				row = getChildAt( 0 ) as Sprite;
				while ( row.numChildren ) {
					item = row.getChildAt( 0 ) as PreviewItem;
					item.dispose();
					row.removeChild( item );
				}
				removeChild( row );
			}
			
			itemsList = new Vector.<PreviewItem>();
			selectedItem = null;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			clear();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onItemClicked( event:MouseEvent ):void {
			selectedItem = event.currentTarget as PreviewItem;
			dispatchEvent( new PreviewsTableEvent( PreviewsTableEvent.ON_PREVIEW_SELECTED ) );
		}
		
	}

}