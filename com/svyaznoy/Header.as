package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Header extends Sprite {
		
		const MARGIN:int = 4;
		
		private var titleLabel:TextField;
		private var dateLabel:TextField;
		private var titleImage:DynamicImage;
		private var startWidth:int;
		
		/**
		 * 
		 */
		
		public function Header() {
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			dateLabel = getChildByName( "date_txt" ) as TextField;
			titleImage = getChildByName( "image_mc" ) as DynamicImage;
			
			startWidth = width;
			
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			dateLabel.autoSize = TextFieldAutoSize.LEFT;
			
			visible = false;
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		public function displayData( data:Object ):void {
			// Title
			
			if ( data.hasOwnProperty( "title" ) && data.title ) {
				titleLabel.htmlText = data.title;
			} else {
				removeChild( titleLabel );
				titleLabel = null;
			}
			
			//Date
			
			if ( data.hasOwnProperty( "date" ) && data.date && dateLabel ) {
				dateLabel.htmlText = DateConverter.getFormattedDate( data.date );
			} else {
				removeChild( dateLabel );
				dateLabel = null;
			}
			
			// Image
			
			if( titleImage ) titleImage.clear();
			
			if ( data.hasOwnProperty( "image_with_path" ) && data.image_with_path ) {
				titleImage.load( data.image_with_path );
				if( !titleImage.hasEventListener( DynamicItemEvent.SIZE_CHANGED ) ) {
					titleImage.addEventListener( DynamicItemEvent.SIZE_CHANGED, onTitleImageSizeChanged );
				}
			} else {
				removeChild( titleImage );
				titleImage = null;
			}
			
			setPositions();
			visible = true;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTitleImageSizeChanged( event:DynamicItemEvent ):void {
			MappingManager.setScaleByWidthOnlyReduce( titleImage, startWidth );
			setPositions();
		}
		
		/**
		 * 
		 */
		
		private function setPositions():void {
			if ( dateLabel ) {
				dateLabel.y = titleLabel ? MappingManager.getBottom( titleLabel, this ) - MARGIN : 0;
			}
			
			if ( titleImage ) {
				if ( dateLabel ) {
					titleImage.y = MappingManager.getBottom( dateLabel, this ) + MARGIN;
				} else if( titleLabel ) {
					titleImage.y = MappingManager.getBottom( titleLabel, this ) + MARGIN;
				} else {
					titleImage.y = 0;
				}
			}
		}
		
	}

}