package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.svyaznoy.events.DynamicItemEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Header extends Sprite {
		
		const MARGIN:int = 4;
		private const TEXTFIELD_MARGIN:int = 6;
		
		private var titleLabel:TextField;
		private var dateLabel:TextField;
		private var titleImage:DynamicImage;
		private var startWidth:int;
		private var titleHitObject:Sprite;
		private var titleTextFormat:TextFormat;
		
		/**
		 * 
		 */
		
		public function Header() {
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			dateLabel = getChildByName( "date_txt" ) as TextField;
			titleImage = getChildByName( "image_mc" ) as DynamicImage;
			
			titleTextFormat = titleLabel.getTextFormat();
			startWidth = width;
			
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			if( dateLabel ) dateLabel.autoSize = TextFieldAutoSize.LEFT;
			
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
				if ( titleHitObject ) {
					titleHitObject.width = titleLabel.textWidth + TEXTFIELD_MARGIN;
					titleHitObject.height = titleLabel.height;
				}
			} else {
				removeChild( titleLabel );
				titleLabel = null;
				if ( titleHitObject ) {
					removeChild( titleHitObject );
					titleHitObject.removeEventListener( MouseEvent.ROLL_OVER, onTitleRollOver );
					titleHitObject.removeEventListener( MouseEvent.ROLL_OUT, onTitleRollOut );
					titleHitObject = null;
				}
			}
			
			//Date
			
			if ( data.hasOwnProperty( "date" ) && data.date && dateLabel ) {
				dateLabel.htmlText = DateConverter.getFormattedDate( data.date );
			} else {
				//removeChild( dateLabel );
				//dateLabel = null;
				dateLabel.text = "";
				dateLabel.y = 0;
			}
			
			// Image
			
			if( titleImage ) titleImage.clear();
			
			if ( data.hasOwnProperty( "image_with_path" ) && data.image_with_path ) {
				titleImage.load( data.image_with_path );
				if( !titleImage.hasEventListener( DynamicItemEvent.SIZE_CHANGED ) ) {
					titleImage.addEventListener( DynamicItemEvent.SIZE_CHANGED, onTitleImageSizeChanged );
				}
			} else {
				//removeChild( titleImage );
				//titleImage = null;
				titleImage.height = 0;
			}
			
			setPositions();
			visible = true;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function setTitleHasButton():Sprite {
			if( !titleHitObject ) {
				titleHitObject = new Sprite();
				titleHitObject.graphics.beginFill( 0, 0 );
				titleHitObject.graphics.drawRect( 0, 0, titleLabel.width, titleLabel.height );
				titleHitObject.graphics.endFill();
				titleHitObject.buttonMode = true;
				titleHitObject.addEventListener( MouseEvent.ROLL_OVER, onTitleRollOver );
				titleHitObject.addEventListener( MouseEvent.ROLL_OUT, onTitleRollOut );
				
				addChild( titleHitObject );
			}
			
			titleHitObject.width = titleLabel.textWidth + TEXTFIELD_MARGIN;
			titleHitObject.height = titleLabel.height;
			
			return titleHitObject;
		}
		
		public function getBitmap():Bitmap {
			return titleImage.getBitmap();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTitleRollOver( event:MouseEvent ):void {
			titleTextFormat.underline = true;
			titleLabel.setTextFormat( titleTextFormat );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTitleRollOut( event:MouseEvent ):void {
			titleTextFormat.underline = false;
			titleLabel.setTextFormat( titleTextFormat );
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