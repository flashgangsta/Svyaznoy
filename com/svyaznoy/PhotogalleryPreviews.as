package com.svyaznoy {
	import caurina.transitions.Tweener;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PhotogalleryPreviews extends Sprite {
		
		private const BRIGHTNESS:Number = -.4;
		private const MARGIN:int = 8;
		private const DISABLED_BUTTON_ALPHA:Number = .3;
		
		private var area:Rectangle;
		private var maskObject:DisplayObject;
		private var leftButton:Button;
		private var rightButton:Button;
		private var container:Sprite = new Sprite();
		private var selection:Sprite;
		private var currentPhoto:PhotogalleryPreviewImage;
		private var step:int = 0;
		private var maxStep:int;
		
		/**
		 * 
		 */
		
		public function PhotogalleryPreviews() {
			leftButton = getChildByName( "leftButton_mc" ) as Button;
			rightButton = getChildByName( "rightButton_mc" ) as Button;
			maskObject = getChildByName( "maskObject_mc" );
			selection = getChildByName( "selection_mc" ) as Sprite;
			
			area = maskObject.getBounds( this );
			
			selection.visible = false;
			selection.mouseChildren = selection.mouseEnabled = false;
			
			leftButton.visible = false;
			rightButton.visible = false;
			leftButton.disabledAlpha = DISABLED_BUTTON_ALPHA;
			rightButton.disabledAlpha = DISABLED_BUTTON_ALPHA;
			
			container.x = area.x;
			container.y = area.y;
			addChild( container );
			container.mask = maskObject;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			if ( !container ) return;
			var photo:PhotogalleryPreviewImage;
			
			leftButton.dispose();
			rightButton.dispose();
			
			if ( leftButton.visible ) {
				leftButton.removeEventListener( MouseEvent.CLICK, onLeftArrowClicked );
				rightButton.removeEventListener( MouseEvent.CLICK, onRightArrowClicked );
			}
			
			while ( container.numChildren ) {
				photo = PhotogalleryPreviewImage( container.getChildAt( 0 ) );
				photo.dispose();
				container.removeChild( photo );
				photo.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				photo.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				photo.removeEventListener( MouseEvent.CLICK, onClick );
			}
			photo = null;
			removeChild( container );
			container.mask = null;
			container = null;
			maskObject = null;
			leftButton = null;
			rightButton = null;
			area = null;
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function fill( data:Object ):void {
			var photosDataList:Array = data.photos;
			var photo:PhotogalleryPreviewImage;
			var containerWidth:int;
			for ( var i:int = 0; i < photosDataList.length; i++ ) {
				photo = new PhotogalleryPreviewImage( photosDataList[ i ] );
				photo.x = ( photo.width + MARGIN ) * i;
				photo.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				photo.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				photo.addEventListener( MouseEvent.CLICK, onClick );
				photo.buttonMode = true;
				container.addChild( photo );
				Tweener.addTween( photo, { _brightness: BRIGHTNESS } );
			}
			
			containerWidth = photo.x + photo.width;
			
			if ( containerWidth > area.width ) {
				leftButton.addEventListener( MouseEvent.CLICK, onLeftArrowClicked );
				rightButton.addEventListener( MouseEvent.CLICK, onRightArrowClicked );
				leftButton.visible = true;
				rightButton.visible = true;
				leftButton.enabled = false;
			}
			
			maxStep = Math.ceil( containerWidth / area.width ) - 1;
			
			
			selection.y = photo.height;
			selection.x = 0;
			selection.visible = true;
			container.addChild( selection );
			maskObject.height = selection.y + selection.height
			selectPhoto( container.getChildAt( 0 ) as PhotogalleryPreviewImage );
		}
		
		/**
		 * 
		 */
		
		public function getSelectedPhotoData():Object {
			return currentPhoto.getData();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseOver( event:MouseEvent = null ):void {
			Tweener.addTween( event ? event.currentTarget : currentPhoto, { _brightness: 0 } );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseOut( event:MouseEvent = null ):void {
			if ( event && event.currentTarget === currentPhoto ) return;
			Tweener.addTween( event ? event.currentTarget : currentPhoto, { _brightness: BRIGHTNESS, time: 1, transition: "easeOutCubic" } );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onClick( event:MouseEvent = null ):void {
			selectPhoto( event.currentTarget as PhotogalleryPreviewImage );
		}
		
		/**
		 * 
		 * @param	photo
		 */
		
		private function selectPhoto( photo:PhotogalleryPreviewImage ):void {
			if ( currentPhoto ) {
				currentPhoto.enabled = true;
				onMouseOut();
			}
			currentPhoto = photo;
			onMouseOver();
			photo.enabled = false;
			Tweener.addTween( selection, { x: photo.x, time: .4, transition: "easeInOutQuart" } );
			dispatchEvent( new Event( Event.SELECT ) );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLeftArrowClicked( event:MouseEvent ):void {
			step--;
			setButtonEnables();
			gotoStep();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRightArrowClicked( event:MouseEvent ):void {
			step++;
			setButtonEnables();
			gotoStep();
		}
		
		/**
		 * 
		 */
		
		private function gotoStep():void {
			var transition:String = Tweener.isTweening( container ) ? "easeOutCubic" : "easeInOutCubic";
			Tweener.addTween( container, { x: area.x - ( ( area.width + MARGIN ) * step ) , time: .8, transition: transition } );
		}
		
		/**
		 * 
		 */
		
		private function setButtonEnables():void {
			if ( step > 1 && !leftButton.enabled ) {
				leftButton.enabled = true;
			}
			
			if ( step === 0 && leftButton.enabled ) {
				leftButton.enabled = false;
			}
			
			if ( step === maxStep && rightButton.enabled ) {
				rightButton.enabled = false;
			}
			
			if ( step === maxStep -1 && !rightButton.enabled ) {
				rightButton.enabled = true;
			}
		}
		
	}

}