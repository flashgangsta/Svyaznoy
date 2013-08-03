package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.svyaznoy.events.MapEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Map extends MovieClip {
		
		[Embed(source = "../../assets/Maps.xml", mimeType = "application/octet-stream")]
		private const CONFIG_CLASS:Class;
		
		private var config:XMLList;
		private var interactiveItems:Array = [];
		
		/**
		 * 
		 */
		
		public function Map() {
			stop();
			visible = false;
			
			config = new XML( new CONFIG_CLASS() )[name.substr( 0, "mapXXXX".length )].item;
			
			for ( var i:int = 0; i < config.length(); i++ ) {
				var item:XML = config[ i ];
				var mapItem:MapItem = getMapItemById( item.@id );
				var country:DisplayObject = getChildByName( item.@country + "_mc" );
				interactiveItems.push( mapItem, country );
				mapItem.init( country );
			}
			
			addEventListener( MapEvent.COUNTRY_MOUSE_OVER, onMapItemMouseOver );
			addEventListener( MapEvent.COUNTRY_MOUSE_OUT, onMapItemMouseOut );
			
		}
		
		/**
		 * 
		 */
		
		public function show():void {
			visible = true;
		}
		
		/**
		 * 
		 */
		
		public function hide():void {
			visible = false;
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
			var activeItem:MapItem = event.target as MapItem;
			for ( var i:int = 0; i < interactiveItems.length; i++ ) {
				var item:DisplayObject = interactiveItems[ i ];
				if ( item === activeItem ) {
					Tweener.addTween( item, { alpha: 1, time: .3, transition: "easeInCubic" } );
					Tweener.addTween( interactiveItems[ ++i ], { alpha: 1, time: .3, transition: "easeInCubic" } );
				} else if ( item && item !== activeItem.getCountry() ) {
					if ( item as MapItem ) MapItem( item ).resetToDefaultState( activeItem.getCountry() );
					Tweener.addTween( item, { alpha: .55, time: .3, transition: "easeOutCubic" } );
				}
				
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMapItemMouseOut( event:MapEvent ):void {
			event.stopImmediatePropagation();
			for ( var i:int = 0; i < interactiveItems.length; i++ ) {
				var item:DisplayObject = interactiveItems[ i ];
				if ( item === event.target ) {
					i++;
				} else if ( item ) {
					Tweener.addTween( item, { alpha: 1, time: .3, transition: "easeInCubic" } );
				}
				
			}
		}
		
	}

}