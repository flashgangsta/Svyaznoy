package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
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
		private var worksList:Vector.<Object> = new Vector.<Object>();
		private var containerCurrentRowY:int = 0;
		
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
			for ( var i:int = 1; i < worksListContainer.numChildren; i++ ) {
				
			}
			worksList = new Vector.<Object>();
			containerCurrentRowY = 0;
			provider.getContest( id );
			backButton.addEventListener( MouseEvent.CLICK, onBackClicked );
			setVisibleForElements( false );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onContestWorksList( event:ProviderEvent ):void {
			ProviderURLLoader( event.target ).removeEventListener( ProviderEvent.ON_CONTEST_WORKS_LIST, onContestWorksList );
			var newList:Vector.<Object> = Vector.<Object>( event.data as Array );
			
			worksList = worksList.concat( Vector.<Object>( newList ) );
			
			if ( data.type === "photos" ) {
				for ( var i:int = 0; i < newList.length; i++ ) {
					var image:PreviewImage = new PreviewImage();
					var imageData:Object = newList[ i ];
					image.loadImage( imageData.photo_with_path + "/" + imageData.photo );
					image.title = imageData.title;
					image.description = imageData.employee.last_name + " " + imageData.employee.first_name;
					addWorkToContainer( image );
				}
			} else {
				for ( var j:int = 0; j < newList.length; j++ ) {
					var story:PreviewStory = new PreviewStory();
					var storyData:Object = newList[ i ];
					story.message = storyData.title;
					story.description = storyData.employee.last_name + " " + storyData.employee.first_name;
					addWorkToContainer( story );
					story.updateColor();
				}
			}
			
			alignItems();
		}
		
		/**
		 * 
		 * @param	work
		 */
		
		private function addWorkToContainer( work:DisplayObject ):void {
			var numWorks:int = worksListContainer.numChildren;
			work.x = ( work.width + 20 ) * ( numWorks % 3 );
			work.y = containerCurrentRowY;
			worksListContainer.addChild( work );
			
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
				if( (data.type === "photos" && addWorkButton is AddStoryButton) || (data.type !== "photos" && addWorkButton is AddWorkButton) ) {
					worksListContainer.removeChild( addWorkButton );
					addWorkButton.removeEventListener( MouseEvent.CLICK, onAddWorkClicked );
					addWorkButton.dispose();
					addWorkButton = null;
				}
			}
			
			if ( !addWorkButton ) {
				addWorkButton = data.type === "photos" ? new AddWorkButton() : new AddStoryButton();
				addWorkButton.addEventListener( MouseEvent.CLICK, onAddWorkClicked );
			}
			
			worksListContainer.addChildAt( addWorkButton, 0 );
			
			titleLabel.text = "КОНКУРС: " + String( data.title ).toUpperCase();
			messageLabel.text = data.content;
			batterysLabel.text = data.points;
			previewIcon.loadByPath( data.image_with_path );
			
			loader = provider.getContestWorksList( data.id, 9, 0, true ); //TODO: разобраться с отображением всех конкурсов
			loader.addEventListener( ProviderEvent.ON_CONTEST_WORKS_LIST, onContestWorksList );
			
			alignItems();
			setVisibleForElements( true );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddWorkClicked( event:MouseEvent ):void {
			trace( "add work" );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBackClicked( event:MouseEvent ):void {
			Dispatcher.getInstance().dispatchEvent( new ScreenEvent( ScreenEvent.GO_BACK ) );
		}
		
	}

}