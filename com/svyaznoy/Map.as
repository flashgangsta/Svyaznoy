package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.svyaznoy.events.MapEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Map extends MovieClip {
		
		private const DARK_OUT_DISPLAYED_PARAMS = { _contrast: 0, time: 0 };
		
		private const DARK_IN_PARAMS:Object = { _contrast: 0, time: .3, transition: "easeInCubic" };
		private const DARK_OUT_PARAMS:Object = { _contrast: -.7, time: .3, transition: "easeOutCubic" };
		private const CONTRAST_IN_PARAMS:Object = { _contrast: 0, time: .3, transition: "easeInCubic" };
		private const CONTRAST_OUT_PARAMS:Object = { _contrast: -.4, time: .3, transition: "easeOutCubic" };
		
		
		private var config:XMLList;
		private var interactiveItems:Array = [];
		private var mapItemsDatasByID:Dictionary;
		
		/**
		 * 
		 */
		
		public function Map() {
			stop();
			visible = false;
			addEventListener( MapEvent.COUNTRY_MOUSE_OVER, onMapItemMouseOver );
			addEventListener( MapEvent.COUNTRY_MOUSE_OUT, onMapItemMouseOut );
		}
		
		/**
		 * 
		 * @param	startDate
		 * @param	photoGalleriesList
		 * @param	videosList
		 */
		
		public function init( config:XMLList, mapDatasList:Vector.<Object> ):void {
			this.config = config;
			mapItemsDatasByID = getMapItemsDatasByID( mapDatasList );
			
			for ( var i:int = 0; i < config.length(); i++ ) {
				var item:XML = config[ i ];
				var id:int = item.@id
				var mapItem:MapItem = getMapItemById( id );
				var country:DisplayObject = getChildByName( item.@country + "_mc" );
				interactiveItems.push( mapItem, country );
				mapItem.init( country, getMapDataByID( id ) );
			}
			
		}
		
		/**
		 * 
		 * @param	id
		 * @return
		 */
		
		private function getMapDataByID( id:int ):Object {
			return mapItemsDatasByID[ id ]
		}
		
		/**
		 * 
		 * @param	mapDatasList
		 * @return
		 */
		
		private function getMapItemsDatasByID( mapDatasList:Vector.<Object> ):Dictionary {
			var result:Dictionary = new Dictionary();
			var data:Object;
			var currentID:int;
			for ( var i:int = 0; i < mapDatasList.length; i++ ) {
				data = mapDatasList[ i ];
				currentID = data.id;
				result[ currentID ] = data;
			}
			return result;
		}
		
		/**
		 * 
		 * @param	id
		 * @return
		 */
		
		public function getMapItemById( id:int ):MapItem {
			return getChildByName( "mapItem" + id + "_mc" ) as MapItem;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMapItemMouseOver( event:MapEvent ):void {
			event.stopImmediatePropagation();
			darkOut( event.target as MapItem );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMapItemMouseOut( event:MapEvent ):void {
			event.stopImmediatePropagation();
			darkIn( event.target as MapItem );
		}
		
		/**
		 * Затемняет все объекты кроме вызывающего объекта(страны или города на который просматривает пользователь)
		 * @param	initiatorItem вызывающий объект
		 */
		
		private function darkOut( dipsplayedItem:MapItem ):void {
			var item:DisplayObject;
			var displayedCountry:DisplayObject = dipsplayedItem.getCountry();
			
			for ( var i:int = 0; i < interactiveItems.length; i++ ) {
				item = interactiveItems[ i ];
				if ( item === dipsplayedItem ) {
					Tweener.addTween( item, DARK_OUT_DISPLAYED_PARAMS );
					Tweener.addTween( interactiveItems[ ++i ], DARK_OUT_DISPLAYED_PARAMS );
					dispatchEvent( new MapEvent( MapEvent.DARK_OUT_BEGIN, true ) );
				} else if ( item && item !== displayedCountry ) {
					if ( item as MapItem ) {
						MapItem( item ).resetToDefaultState( displayedCountry );
						Tweener.addTween( item, DARK_OUT_PARAMS );
					} else {
						Tweener.addTween( item, CONTRAST_OUT_PARAMS );
					}
					
				}
				
			}
		}
		
		/**
		 * Вывод из затемнения объектов карты
		 * @param	mapItem
		 */
		
		private function darkIn( dipsplayedItem:MapItem ):void {
			var item:DisplayObject;
			
			for ( var i:int = 0; i < interactiveItems.length; i++ ) {
				item = interactiveItems[ i ];
				
				if ( item === dipsplayedItem ) {
					i++;
					dispatchEvent( new MapEvent( MapEvent.DARK_IN_BEGIN, true ) );
				} else if ( item ) {
					if ( item as MapItem ) {
						Tweener.addTween( item, DARK_IN_PARAMS );
					} else {
						Tweener.addTween( item, CONTRAST_OUT_PARAMS );
					}
				}
			}
		}
		
	}

}