﻿package com.svyaznoy {	import caurina.transitions.Tweener;	import com.flashgangsta.managers.ButtonManager;	import com.flashgangsta.managers.MappingManager;	import com.svyaznoy.events.MapEvent;	import com.svyaznoy.events.MapItemEvent;	import com.svyaznoy.events.PreviewEvent;	import com.svyaznoy.events.ProviderEvent;	import com.svyaznoy.gui.Button;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Rectangle;	import flash.utils.Dictionary;		/**	 * ...	 * @author Sergey Krivtsov (flashgangsta@gmail.com)	 */	public class Departures extends Screen {				[Embed(source = "../../assets/Maps.xml", mimeType = "application/octet-stream")]		private const CONFIG_CLASS:Class;				private const MAP_CONTRAST_OUT_PARAMS:Object = { _contrast: -.4, time: .3, transition: "easeOutCubic" };		private const MAP_CONTRAST_IN_PARAMS:Object = { _contrast: 0, time: .3, transition: "easeOutCubic" };				private const YEAR_FROM:int = 	2010;		private const YEAR_TO:int = 	2013;				private var currentMap:Map;		private var worldMap:Sprite;		private var grid:Sprite;		private var yearsButtons:YearButtons;		private var datasSortedByYear:Dictionary;		private var bottomTitles:Sprite;		private var lastGalleryOne:PreviewGallery;		private var lastGalleryTwo:PreviewGallery;		private var lastVideo:PreviewVideo;				/**		 * 		 */				public function Departures() {			var imgPreview:DisplayObject = getChildByName( "photo1_mc" );			worldMap = getChildByName( "worldMap_mc" ) as Sprite;			yearsButtons = getChildByName( "yearButtons_mc" ) as YearButtons;			grid = getChildByName( "grid_mc" ) as Sprite;			lastVideo = getChildByName( "video_mc" ) as PreviewVideo;			lastGalleryOne = new PreviewGallery();			lastGalleryTwo = new PreviewGallery();			bottomTitles = getChildByName( "bottomTitles_mc" ) as Sprite;						lastGalleryOne.width = lastGalleryTwo.width = imgPreview.width;			lastGalleryOne.height = lastGalleryTwo.height = imgPreview.height;			lastGalleryOne.y = lastGalleryTwo.y = imgPreview.y;			lastGalleryOne.x = imgPreview.x;			removeChild( imgPreview );			imgPreview = getChildByName( "photo2_mc" );			lastGalleryTwo.x = imgPreview.x;			removeChild( imgPreview );			addChild( lastGalleryOne );			addChild( lastGalleryTwo );						yearsButtons.setButtons( YEAR_FROM, YEAR_TO );			yearsButtons.addEventListener( Event.CHANGE, onYearChanged );						currentMap = getMapByYear( int( yearsButtons.getSelectedYear() ) );						setElementsForVisibleControll( yearsButtons, worldMap, grid, currentMap, bottomTitles, lastGalleryOne, lastGalleryTwo, lastVideo );			setVisibleForElements( false );						provider.getDeparturesList( null, "galleries,videos" );			provider.addEventListener( ProviderEvent.ON_DEPARTURES_LIST, onData );						provider.getLastGalleries( 2 );			provider.addEventListener( ProviderEvent.ON_LAST_GALLERIES, onLastGalleries );						provider.getLastVideos();			provider.addEventListener( ProviderEvent.ON_LAST_VIDEOS, onLastVideos );						addEventListener( MapEvent.DARK_OUT_BEGIN, setDarkMap );			addEventListener( MapEvent.DARK_IN_BEGIN, setDarkMap );						addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );		}				/**		 * 		 * @param	event		 */				private function onAddedToStage( event:Event ):void {			var gridBounds:Rectangle = grid.getBounds( stage );			MappingManager.copyPosition( grid, gridBounds );			stage.addChildAt( grid, 0 );			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );		}				/**		 * 		 * @param	event		 */				private function onRemovedFromStage( event:Event ):void {			var gridBounds:Rectangle = grid.getBounds( this );			MappingManager.copyPosition( grid, gridBounds );			addChildAt( grid, 0 );			removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );		}				/**		 * 		 * @param	event		 */				private function onLastGalleries( event:ProviderEvent ):void {			var galleriesData:Array = event.data as Array;			provider.removeEventListener( ProviderEvent.ON_LAST_GALLERIES, onLastGalleries );			lastGalleryOne.displayData( galleriesData[ 0 ] );			lastGalleryTwo.displayData( galleriesData[ 1 ] );			dispatchHeighUpdated();		}				/**		 * 		 * @param	event		 */				private function onLastVideos( event:ProviderEvent ):void {			lastVideo.displayData( event.data[ 0 ] );			lastVideo.makeNavigationToVideoReport();			dispatchHeighUpdated();		}				/**		 * 		 * @param	event		 */				private function setDarkMap( event:MapEvent ):void {			event.stopImmediatePropagation();			Tweener.addTween( worldMap, event.type === MapEvent.DARK_OUT_BEGIN ? MAP_CONTRAST_OUT_PARAMS : MAP_CONTRAST_IN_PARAMS );		}				/**		 * 		 * @param	event		 */				override protected function onData( event:ProviderEvent ):void {			super.onData( event );			provider.removeEventListener( ProviderEvent.ON_DEPARTURES_LIST, onData );			datasSortedByYear = getDatasSortedByYear();			initMaps();			displayData();		}				/**		 * 		 */				override protected function displayData():void {			super.displayData();			setVisibleForElements( true );		}				/**		 * 		 */				private function initMaps():void {			var map:Map;			var data:Object;			var config:XML = new XML( new CONFIG_CLASS() );			var mapConfig:XMLList;						for ( var year:int = YEAR_FROM; year <= YEAR_TO; year++ ) {				map = getMapByYear( year );				mapConfig = config[map.name.substr( 0, "mapXXXX".length )].item;				map.init( mapConfig, datasSortedByYear[ year ] );			}		}				/**		 * 		 * @return		 */				private function getDatasSortedByYear():Dictionary {			var result:Dictionary = new Dictionary();			var currentYear:int;			var dataItem:Object;						for ( var i:int = 0; i < data.length; i++ ) {				dataItem = data[ i ];				if ( !result[ dataItem.year ] ) {					result[ dataItem.year ] = new Vector.<Object>()				}				result[ dataItem.year ].push( dataItem );			}			return result;		}				/**		 * 		 * @param	event		 */				private function onYearChanged( event:Event ):void {			currentMap.visible = false;			currentMap = getMapByYear( int( yearsButtons.getSelectedYear() ) );			currentMap.visible = true;		}				/**		 * 		 */				private function getMapByYear( year:int ):Map {			return getChildByName( "map" + year + "_mc" ) as Map;		}			}}