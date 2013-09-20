﻿/* * Scrollbar * Class for quick setting personal scrollbar component * * @author		Sergei Krivtsov * @version		1.01.07	19/09/2013 * @e-mail		flashgangsta@gmail.com **/package com.flashgangsta.ui {	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.errors.ScriptTimeoutError;	import flash.events.Event;	import flash.geom.Rectangle;	import flash.display.MovieClip;	import com.flashgangsta.managers.ButtonManager;	import com.flashgangsta.display.Drawing;	import flash.display.Stage;	import flash.events.MouseEvent;	import flash.utils.setTimeout;	import flash.utils.clearTimeout;	import flash.external.ExternalInterface;		public class Scrollbar {				static private const SCROLL_INTERVAL_START:int = 500;		static private const SCROLL_INTERVAL:int = 100;				static private var id:int = 0;		static private var dataBase:Array = [];		static private var scrollInterval:uint;		static private var scrollingByInterval:Boolean = false;				/**		 * 		 */				public function Scrollbar() {			throw new Error( "Scrollbar is a static class and should not be instantiated." );		}				/**		 * 		 * @param	content		 * @param	scrollArea		 * @param	up		 * @param	down		 * @param	carret		 * @param	carretDragArea		 * @param	wheelListenerObject		 * @param	scrollDrag		 */				static public function setVertical( content:MovieClip, scrollArea:Rectangle, up:MovieClip, down:MovieClip, carret:MovieClip, carretDragArea:Rectangle, wheelListenerObject:DisplayObject, scrollDrag:Boolean = false ):void {						var data:ScrollbarData = new ScrollbarData();			data.id = id;			data.content = content;			data.contentHeight = content.height + content.getBounds( content ).y;			data.scrollArea = scrollArea;			data.up = up;			data.down = down;			data.carret = carret;			data.carretRoad = addCarretRoad( carret, carretDragArea );			data.carretDragArea = carretDragArea;			data.wheelListenerObject = wheelListenerObject;			data.locked = false;						trace( carretDragArea );						dataBase.push( data );			up.id = id;			down.id = id;			carret.id = id;			content.id = id;						if( scrollDrag ) {				ButtonManager.addButton( MovieClip( content ), null, dropContent, dropContent, dragContent );			}						var idIdentificator:MovieClip;			idIdentificator = new MovieClip();			idIdentificator.id = id;			wheelListenerObject.stage.addChild( idIdentificator );						wheelListenerObject.stage.addEventListener( MouseEvent.MOUSE_WHEEL, onWheel );						update( carret );						ButtonManager.addButton( up, null, clearScrollInterval, clearScrollInterval, scrollUp, null, null, false );			ButtonManager.addButton( down, null, clearScrollInterval, clearScrollInterval, scrollDown, null, null, false );			ButtonManager.addButton( carret, null, dropCarret, dropCarret, dragCarret, null, null, false );						reset( carret );						++ id;		}				/**		 * 		 * @param	carret		 */				static public function removeVerticalScrollbar( carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );						data.up.id = null;			data.down.id = null;			data.carret.id = null;			data.content.id = null;			data.carretRoad.id = null;						ButtonManager.removeButton( MovieClip( data.content ) );			ButtonManager.removeButton( data.up );			ButtonManager.removeButton( data.down );			ButtonManager.removeButton( data.carret );									data.wheelListenerObject.removeEventListener( MouseEvent.MOUSE_WHEEL, onWheel );						trace( "Scrollbar", data.id, "removed." );						dataBase[ data.id ] = null;			data = null;		}				/**		 * Сбросить скроллбар в начальное положение		 * @param	carret		 */				static public function reset( carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			var oldPercent:Number = getPercent( carret );			carret.y = data.carretDragArea.y;			data.content.y = data.scrollArea.y;			setButtonsStates( data );						if( getPercent( carret ) !== oldPercent ) {				dispatchChange( carret );			}		}				/**		 * Обновить расчеты скролирования		 * @param	carret		 */				static public function update( carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			var content:MovieClip = data.content;			data.contentHeight = content.height + content.getBounds( content ).y;			setCarretSize( carret );		}				/**		 * Блокирует скроллбар		 * @param	carret		 */				static public function lock( carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			data.locked = true;		}				/**		 * Разблокирует скроллба		 * @param	carret		 */				static public function unlock( carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			data.locked = false;		}				/**		 * Нужен ли скроллбар? Или контент не больше экрана		 * @param	carret	ссылка на MovieClip каретки		 */				static public function isNeeded( carret:MovieClip ):Boolean {			var data:ScrollbarData = getData( carret.id );			return data.scrollArea.height < data.contentHeight;		}				/**		 * 		 * @param	percent		 * @param	carret		 */				static public function setScrollPositionByPercent( percent:Number, carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			carret.y = Math.floor( ( data.carretDragArea.y + data.carretDragArea.height ) - carret.height );			setContentPosition( data );			dispatchChange( carret );		}				/**		 * 		 * @param	carret		 * @return		 */				static public function getPercent( carret:MovieClip ):Number {			var data:ScrollbarData = getData( carret.id );			return getPercentByCarret( data );		}				/**		 * 		 * @param	carret		 * @return		 */				static public function getContentHeight( carret:MovieClip ):int {			var data:ScrollbarData = getData( carret.id );			return data.contentHeight;		}				/**		 * 		 * @param	oldContentHeight		 */				static public function setScrollPositionByPixels( oldContentHeight:int, carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			data.content.y = data.scrollArea.y - oldContentHeight;			setMargins( data );			setCarretPosition( data );			setButtonsStates( data );		}				/**		 * 		 * @param	carret		 */				static private function setCarretSize( carret:MovieClip ):void {			var data:ScrollbarData = getData( carret.id );			if ( data.scrollArea.height >= data.contentHeight ) {				return;			}			var percent:int = Math.round( data.scrollArea.height / data.contentHeight * 100 );			data.carret.height = Math.round( data.carretDragArea.height / 100 * percent );		}				/**		 * 		 * @param	data		 */				static private function setButtonsStates( data:ScrollbarData ):void {			if( data.carret.y === data.carretDragArea.y ) {				ButtonManager.setButtonState( data.up, ButtonManager.STATE_NORMAL );				ButtonManager.setButtonEnable( data.up, false, true );				ButtonManager.setButtonEnable( data.down, true, true );			} else if( !ButtonManager.getButtonEnable( data.up ) ) {				ButtonManager.setButtonEnable( data.up, true, true );			}						if( data.carret.y === data.carretDragArea.y + data.carretDragArea.height - data.carret.height ) {				ButtonManager.setButtonState( data.down, ButtonManager.STATE_NORMAL );				ButtonManager.setButtonEnable( data.down, false, true );				ButtonManager.setButtonEnable( data.up, true, true );			} else if( !ButtonManager.getButtonEnable( data.down ) ) {				ButtonManager.setButtonEnable( data.down, true, true );			}		}				/**		 * 		 * @param	target		 */				static private function dragCarret( target:MovieClip ):void {			var data:ScrollbarData = getData( target.id );						var idIdentificator:MovieClip = new MovieClip();			idIdentificator.id = data.id;			target.stage.addChild( idIdentificator );			target.idIdentificator = idIdentificator;						target.startDrag( false, new Rectangle( data.carretDragArea.x, data.carretDragArea.y, 0, data.carretDragArea.height - data.carret.height ) );			target.stage.addEventListener( MouseEvent.MOUSE_MOVE, onCarretDragged );		}				/**		 * 		 * @param	target		 */				static private function dropCarret( target:MovieClip ):void {			target.stopDrag();			target.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onCarretDragged );		}				/**		 * 		 * @param	event		 */				static private function onCarretDragged( event:MouseEvent ):void {			var id:int = ( event.currentTarget.getChildAt( event.currentTarget.numChildren - 1 ) as MovieClip ).id;			var data:ScrollbarData = getData( id );			var carret:MovieClip = data.carret;			var oldPercent:Number = getPercentByContent( data );			setContentPosition( data );			if( oldPercent !== getPercentByContent( data ) ) {				dispatchChange( data.carret );			}		}				/**		 * 		 * @param	event		 */				static private function onWheel( event:MouseEvent ):void {			var id:int;			id = ( event.currentTarget.getChildAt( event.currentTarget.numChildren - 1 ) as MovieClip ).id;			var data:ScrollbarData = getData( id );			var wheelListener:DisplayObject = data.wheelListenerObject;			var stage:Stage = wheelListener.stage;			if ( wheelListener is Stage === false ) {				if ( !wheelListener.hitTestPoint( stage.mouseX, stage.mouseY ) ) return;			}			if( data.locked ) return;			data.content.y += ( event.delta * 40 );			setMargins( data );			setCarretPosition( data );			setButtonsStates( data );			dispatchChange( data.carret );		}				/**		 * Выравнивает контент, если он зашёл за границы прокрутки		 * @param	data		 */				static private function setMargins( data:ScrollbarData ):void {			var scrollArea:Rectangle = data.scrollArea;			var content:DisplayObject = data.content;			var contentHeight:Number = data.contentHeight;						if( content.y < scrollArea.y - ( contentHeight - scrollArea.height ) ) {				content.y = scrollArea.y - ( contentHeight - scrollArea.height );			}			if( content.y > scrollArea.y ) {				content.y = scrollArea.y;			}		}				/**		 * Устанавливает требуемую позицию каретки скролл-бара		 * @param	data		 */				static private function setCarretPosition( data:ScrollbarData ):void {			var carretDragArea:Rectangle = data.carretDragArea;			var percent:int = getPercentByContent( data );			var carret:DisplayObject = data.carret;			carret.y = Math.round( carretDragArea.y + ( ( carretDragArea.height - carret.height ) / 100 * percent ) );		}				/**		 * Устанавливает требуемую позицию контента		 * @param	data		 */				static private function setContentPosition( data:ScrollbarData ):void {			var percent:int = getPercentByCarret( data );			data.content.y = data.scrollArea.y - ( ( data.contentHeight - data.scrollArea.height ) / 100 * percent );			setButtonsStates( data );		}				/**		 * 		 * @param	data		 * @return		 */				static private function getPercentByCarret( data:ScrollbarData ):Number {			var carretDragArea:Rectangle = data.carretDragArea;			var carret:DisplayObject = data.carret;			return Math.round( ( carret.y - carretDragArea.y ) / ( carretDragArea.height - carret.height ) * 100 );		}				/**		 * 		 * @param	data		 * @return		 */				static protected function getPercentByContent( data:ScrollbarData ):Number {			var scrollArea:Rectangle = data.scrollArea;			return Math.abs( Math.round( ( data.content.y - scrollArea.y ) / ( data.contentHeight - scrollArea.height ) * 100 ) );		}				/**		 * 		 * @param	target		 */				static private function dragContent( carret:MovieClip ):void {			var idIdentificator:MovieClip = new MovieClip();			var data:ScrollbarData = getData( carret.id );			idIdentificator.id = carret.id;			carret.stage.addChild( idIdentificator );			carret.stage.addEventListener( MouseEvent.MOUSE_MOVE, onContentDragged );			carret.startDrag( false, new Rectangle( data.scrollArea.x - ( data.content.width - data.scrollArea.width ), data.scrollArea.y - ( data.content.height - data.scrollArea.height ), data.content.width - data.scrollArea.width, data.content.height - data.scrollArea.height ) );		}				/**		 * 		 * @param	target		 */				static private function dropContent( carret:MovieClip ):void {			carret.stopDrag();			carret.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onContentDragged );		}				/**		 * 		 * @param	event		 */				static private function onContentDragged( event:MouseEvent ):void {			var id:int = ( event.currentTarget.getChildAt( event.currentTarget.numChildren - 1 ) as MovieClip ).id;			var data:ScrollbarData = getData( id );			setCarretPosition( data );			setButtonsStates( data );		}				/**		 * 		 * @param	target		 */				static private function scrollUp( target:MovieClip ):void {			var data:ScrollbarData = getData( target.id );			data.content.y += 30;			setMargins( data );			setCarretPosition( data );			setButtonsStates( data );			scrollInterval = setTimeout( scrollUp, scrollingByInterval ? SCROLL_INTERVAL : SCROLL_INTERVAL_START, target );			scrollingByInterval = true;		}				/**		 * 		 * @param	target		 */				static private function scrollDown( target:MovieClip ):void {			var data:ScrollbarData = getData( target.id );			data.content.y -= 30;			setMargins( data );			setCarretPosition( data );			setButtonsStates( data );			scrollInterval = setTimeout( scrollDown, scrollingByInterval ? SCROLL_INTERVAL : SCROLL_INTERVAL_START, target );			scrollingByInterval = true;		}				/**		 * 		 * @param	target		 */				static private function clearScrollInterval( target:MovieClip ):void {			clearTimeout( scrollInterval );			scrollingByInterval = false;		}				/**		 * 		 * @param	carret		 * @param	carretDragArea		 * @return		 */				static private function addCarretRoad( carret:MovieClip, carretDragArea:Rectangle ):MovieClip {			var carretRoad:MovieClip = new MovieClip();			carretRoad.id = id;			carretRoad.x = carret.x;			carretRoad.y = carretDragArea.y;			Drawing.drawRectangle( carretRoad, 0, 0, carret.width, carretDragArea.height, 0, 0 );			carret.parent.addChild( carretRoad );			carret.parent.setChildIndex( carretRoad, carret.parent.getChildIndex( carret ) - 1 );			ButtonManager.addButton( carretRoad, null, null, null, carredRoadClicked, null, null, false );			return carretRoad;		}				/**		 * 		 * @param	target		 */				static private function carredRoadClicked( target:MovieClip ):void {			var data:ScrollbarData = getData( target.id );			var percent:int = target.mouseY / target.height * 100;			data.carret.y = Math.round( data.carretDragArea.y + ( ( data.carretDragArea.height - data.carret.height ) / 100 * percent ) );			setContentPosition( data );		}				/**		 * 		 * @param	id		 * @return		 */				static private function getData( id:int ):ScrollbarData {			return dataBase[ id ];		}				/**		 * 		 */				static private function dispatchChange( carret:MovieClip ):void {			carret.dispatchEvent( new Event( Event.CHANGE ) );		}			}	}import flash.display.DisplayObject;import flash.display.MovieClip;import flash.geom.Rectangle;class ScrollbarData {	public var id:int;	public var content:MovieClip;	public var contentHeight:Number;	public var scrollArea:Rectangle;	public var up:MovieClip;	public var down:MovieClip;	public var carret:MovieClip;	public var carretRoad:MovieClip;	public var carretDragArea:Rectangle;	public var wheelListenerObject:DisplayObject;	public var locked:Boolean;		public function ScrollbarData() {			}}