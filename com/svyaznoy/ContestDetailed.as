package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.utils.PopupsController;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import com.svyaznoy.gui.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ContestDetailed extends Screen {
		
		private const TYPE_PHOTOS:String = "photos";
		
		private var worksListContainer:Sprite = new Sprite();
		private var titleLabel:TextField;
		private var messageLabel:TextField;
		private var batterysLabel:TextField;
		private var previewIcon:AvatarContainer;
		private var loader:ProviderURLLoader;
		private var divider:DisplayObject;
		private var addWorkButton:Button;
		private var backButton:Button;
		private var cupIcon:DisplayObject;
		private var batteryIcon:DisplayObject;
		private var worksList:Array = [];
		private var containerCurrentRowY:int = 0;
		private var worksPreviews:Vector.<PreviewItem> = new Vector.<PreviewItem>();
		
		/**
		 * 
		 * @param	data
		 */
		
		public function ContestDetailed() {
			divider = getChildByName( "divider_mc" );
			titleLabel = getChildByName( "titleLabel_txt" ) as TextField;
			messageLabel = getChildByName( "messageLabel_txt" ) as TextField;
			batterysLabel = getChildByName( "batterysLabel_txt" ) as TextField;
			previewIcon = getChildByName( "preview_mc" ) as AvatarContainer;
			backButton = getChildByName( "backButton_mc" ) as Button;
			cupIcon = getChildByName( "cupIcon_mc" );
			batteryIcon = getChildByName( "batteryIcon_mc" );
			
			setElementsForVisibleControll( divider, titleLabel, messageLabel, batterysLabel, previewIcon, worksListContainer, backButton, cupIcon, batteryIcon );
			addChild( worksListContainer );
			provider.addEventListener( ProviderEvent.ON_CONTEST, onData );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			provider.addEventListener( ProviderEvent.ON_PHOTO_UPLOADED_TO_CONTEST, onPhotoUploaded );
			provider.addEventListener( ProviderEvent.ON_STORY_ADDED, onStortAdded );
			
			backButton.addEventListener( MouseEvent.CLICK, onBackClicked );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			addPreloader();
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function showContest( id:int ):void {
			for ( var i:int = 0; i < worksPreviews.length; i++ ) {
				var item:PreviewItem = worksPreviews[ i ] as PreviewItem;
				worksListContainer.removeChild( item );
				item.removeEventListener( MouseEvent.CLICK, onWorkSelected );
				item.dispose();
				item = null;
			}
			
			worksList = [];
			worksPreviews = new Vector.<PreviewItem>();
			containerCurrentRowY = 0;
			provider.getContest( id );
			setVisibleForElements( false );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			super.onData( event );
			displayData();
		}
		
		/**
		 * 
		 */
		
		override protected function displayData():void {
			super.displayData();
			
			if ( addWorkButton ) {
				worksListContainer.removeChild( addWorkButton );
				addWorkButton.removeEventListener( MouseEvent.CLICK, onAddWorkClicked );
				addWorkButton.dispose();
				addWorkButton = null;
			}
			
			if ( !addWorkButton && !data.is_participated ) {
				addWorkButton = data.type === TYPE_PHOTOS ? new AddWorkButton() : new AddStoryButton();
				addWorkButton.addEventListener( MouseEvent.CLICK, onAddWorkClicked );
				worksListContainer.addChildAt( addWorkButton, 0 );
			}
			
			titleLabel.text = "КОНКУРС: " + String( data.title ).toUpperCase();
			messageLabel.text = data.content;
			batterysLabel.text = data.points;
			previewIcon.loadByPath( data.image_with_path );
			
			loader = provider.getContestWorksList( data.id, 9, 0, true, "created_at:desc" ); //TODO: разобраться с отображением всех конкурсов
			loader.addEventListener( ProviderEvent.ON_CONTEST_WORKS_LIST, onContestWorksList );
			
			alignItems();
			setVisibleForElements( true );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onContestWorksList( event:ProviderEvent ):void {
			ProviderURLLoader( event.target ).removeEventListener( ProviderEvent.ON_CONTEST_WORKS_LIST, onContestWorksList );
			var newList:Array = event.data as Array;
			
			
			worksList = worksList.concat( newList );
			
			if ( data.type === TYPE_PHOTOS ) {
				for ( var i:int = 0; i < newList.length; i++ ) {
					var image:PreviewImage = new PreviewImage();
					var imageData:Object = newList[ i ];
					image.loadImage( imageData.photo_with_path );
					image.title = imageData.title;
					image.description = imageData.employee.last_name + " " + imageData.employee.first_name;
					image.buttonMode = true;
					image.addEventListener( MouseEvent.CLICK, onWorkSelected );
					addWorkToContainer( image );
				}
			} else {
				for ( var j:int = 0; j < newList.length; j++ ) {
					var story:PreviewStory = new PreviewStory();
					var storyData:Object = newList[ j ];
					story.message = storyData.title;
					story.description = storyData.employee.last_name + " " + storyData.employee.first_name;
					story.buttonMode = true;
					story.addEventListener( MouseEvent.CLICK, onWorkSelected );
					addWorkToContainer( story );
					story.updateColor();
				}
			}
			
			alignItems();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onWorkSelected( event:MouseEvent ):void {
			var index:int = worksPreviews.indexOf( event.currentTarget );
			var workData:Object = worksList[ index ];
			if( data.type === TYPE_PHOTOS ) {
				var photoGallery:Photogallery = new Photogallery( true );
				photoGallery.loadByDatasList( worksList );
				PopupsController.getInstance().showPopup( photoGallery, true );
			} else {
				var storyGallery:StorysGallery = new StorysGallery( worksList, index );
				PopupsController.getInstance().showPopup( storyGallery, true );
			}
			
		}
		
		/**
		 * 
		 * @param	work
		 */
		
		private function addWorkToContainer( work:PreviewItem ):void {
			var numWorks:int = worksListContainer.numChildren;
			work.x = ( work.width + 20 ) * ( numWorks % 3 );
			work.y = containerCurrentRowY;
			worksListContainer.addChild( work );
			worksPreviews.push( work );
			
			numWorks = worksListContainer.numChildren;
			
			if ( numWorks / 3 is int ) {
				var maxHeight:Number = Math.max( worksListContainer.getChildAt( numWorks - 1 ).height, worksListContainer.getChildAt( numWorks - 2 ).height, worksListContainer.getChildAt( numWorks - 3 ).height );
				containerCurrentRowY = Math.ceil( worksListContainer.getChildAt( numWorks - 1 ).y + maxHeight ) + MARGIN;
			}
		}
		
		/**
		 * 
		 */
		
		private function alignItems():void {
			var lastItem:DisplayObject = messageLabel.y + messageLabel.height > batterysLabel.y + batterysLabel.height ? messageLabel : batterysLabel;
			divider.y = MappingManager.getBottom( lastItem, this ) + MARGIN;
			worksListContainer.y = divider.y + MARGIN;
			backButton.y = worksListContainer.y + worksListContainer.height + MARGIN * 2;
			dispatchHeighUpdated();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddWorkClicked( event:MouseEvent ):void {
			trace( "add work" );
			var addWorkPopup:AddWorkToContestPopup;
			if ( data.type === TYPE_PHOTOS ) {
				addWorkPopup = new AddWorkToPhotoContest( data.id );
			} else {
				addWorkPopup = new AddWorkToStoryContest( data.id );
			}
			PopupsController.getInstance().showPopup( addWorkPopup, true );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBackClicked( event:MouseEvent ):void {
			dispatchEvent( new ScreenEvent( ScreenEvent.GO_BACK ) );
		}
		
		/**
		 * 
		 */
		
		private function onPhotoUploaded( event:ProviderEvent ):void {
			showContest( data.id );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onStortAdded( event:ProviderEvent ):void {
			showContest( data.id );
		}
		
	}

}