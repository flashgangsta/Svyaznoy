package com.svyaznoy {	import com.flashgangsta.managers.MappingManager;	import com.flashgangsta.utils.PopupsController;	import com.svyaznoy.events.DynamicItemEvent;	import com.svyaznoy.events.EmployeePhotosEvent;	import com.svyaznoy.events.PreviewEvent;	import com.svyaznoy.events.ProviderEvent;	import com.svyaznoy.events.ScreenEvent;	import com.svyaznoy.utils.DateParser;	import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.MouseEvent;	/**	 * ...	 * @author Sergey Krivtsov (flashgangsta@gmail.com)	 */	public class Country extends ScreenWithTopButton {				private const MARGIN:int = 10;				private var galleriesList:PreviewsTable;		private var employeesPhotosList:PreviewsTable;		private var videosList:PreviewsTable;		private var photosTitle:DisplayObject;		private var videosTitle:DisplayObject;		private var employeesTitle:DisplayObject;		private var departureLoader:ProviderURLLoader;		private var employeesPhotosLoader:ProviderURLLoader;		private var id:String;		private var employeesPhotosDatasList:Array;		private var departureLoaderEvent:ProviderEvent;		private var dispatcher:Dispatcher = Dispatcher.getInstance();				/**		 * 		 */				public function Country() {			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );						header.y = topButton.height + MARGIN;						setElementsForVisibleControll( header, dynamicContentViewer, topButton );						photosTitle = getChildByName( "photosTitle_mc" );			videosTitle = getChildByName( "videosTitle_mc" );			employeesTitle = getChildByName( "employeesTitle_mc" );						photosTitle.visible = false;			videosTitle.visible = false;			employeesTitle.visible = false;						setVisibleForElements( false );						topButton.addEventListener( MouseEvent.CLICK, onBackClicked );						dispatcher.addEventListener( PreviewEvent.ON_EMPLOYES_PHOTOS_CALLED, onEmployesPhotosCalled );			dispatcher.addEventListener( EmployeePhotosEvent.ON_EMPLOYEE_ALBUM_UPDATED, onEmployeeAlbumUpdated );		}				/**		 * 		 * @param	event		 */				private function onEmployeeAlbumUpdated( event:EmployeePhotosEvent ):void {			if ( id === event.departureID ) {				id = null;				data = null;			}		}				/**		 * 		 * @param	event		 */				private function onEmployesPhotosCalled( event:PreviewEvent ):void {			var photogallery:Photogallery = new Photogallery();			photogallery.loadByDatasList( employeesPhotosDatasList );			PopupsController.getInstance().showPopup( photogallery, true );		}				/**		 * 		 * @param	itemData		 */				public function showCountry( itemData:Object ):void {						if ( id === itemData.id ) return;						departureLoaderEvent = null;						id = itemData.id;			employeesPhotosDatasList = null;						if ( departureLoader ) {				departureLoader.dispose();			}						if ( employeesPhotosLoader ) {				employeesPhotosLoader.dispose();			}						if ( galleriesList ) {				photosTitle.visible = false;				galleriesList.dispose();				removeChild( galleriesList );				galleriesList = null;			}			if ( videosList ) {				videosTitle.visible = false;				videosList.dispose();				removeChild( videosList );				videosList = null;			}						if ( employeesPhotosList ) {				employeesTitle.visible = false;				employeesPhotosList.dispose();				removeChild( employeesPhotosList );				employeesPhotosList = null;			}			setVisibleForElements( false );			addPreloader();						departureLoader = provider.getDeparture( itemData.id, "galleries,videos" );			employeesPhotosLoader = provider.getEmployeesPhotos( itemData.id );			departureLoader.addEventListener( ProviderEvent.ON_DEPARTURE, onData );			employeesPhotosLoader.addEventListener( ProviderEvent.ON_EMPLOYEES_PHOTOS, onEmployeesPhotos );		}				/**		 * 		 * @param	event		 */				override protected function onData( event:ProviderEvent ):void {			if ( !employeesPhotosDatasList ) {				departureLoaderEvent = event;				return;			}						super.onData( event );						if( departureLoader ) {				departureLoader.dispose();				departureLoader = null;			}						if ( employeesPhotosDatasList.length ) {				employeesPhotosList = new PreviewsTable();				employeesTitle.visible = true;				employeesPhotosList.fill( employeesPhotosDatasList, PreviewEmployeesPhotos, -1, 1 );				addChild( employeesPhotosList );			}						if ( data.galleries.length ) {				var sortedGalleries:Array = sortByDate( data.galleries );				photosTitle.visible = true;				galleriesList = new PreviewsTable();				galleriesList.fill( data.galleries, PreviewGallery, -1, 3 );				addChild( galleriesList );			}						if ( data.videos.length ) {				var sortedVideos:Array = sortByDate( data.videos );				videosTitle.visible = true;				videosList = new PreviewsTable();				videosList.fill( sortedVideos, PreviewVideo, -1, 3 );				videosList.makeNavigationToVideoReport();				addChild( videosList );			}						setVisibleForElements( true );			setPositions();		}				/**		 * 		 * @param	event		 */				private function onEmployeesPhotos( event:ProviderEvent ):void {			employeesPhotosDatasList = event.data as Array;			employeesPhotosLoader.dispose();			employeesPhotosLoader = null;			if ( departureLoaderEvent ) {				onData( departureLoaderEvent );			}		}				/**		 * 		 * @param	list		 * @return		 */				private function sortByDate( list:Array ):Array {			var result:Array = [];			var item:Object;			for ( var i:int = 0; i < list.length; i++ ) {				item = list[ i ];				item.time_of_updated_at = DateParser.parse( item.updated_at ).time;				result.push( item );			}						result.sortOn( "time_of_updated_at", Array.NUMERIC | Array.DESCENDING );						return result;		}				/**		 * 		 */				private function setPositions():void {			var lastItem:DisplayObject = dynamicContentViewer.numChildren ? dynamicContentViewer : header;						if ( galleriesList ) {				photosTitle.y =  MappingManager.getBottom( lastItem, this ) + MARGIN;				lastItem = photosTitle;				galleriesList.y = MappingManager.getBottom( lastItem, this ) + MARGIN;				lastItem = galleriesList;			}						if ( videosList ) {				videosTitle.y =  MappingManager.getBottom( lastItem, this ) + MARGIN;				lastItem = videosTitle;				videosList.y = MappingManager.getBottom( lastItem, this ) + MARGIN;				lastItem = videosList;			}						if ( employeesPhotosList ) {				employeesTitle.y = MappingManager.getBottom( lastItem, this ) + MARGIN;				lastItem = employeesTitle;				employeesPhotosList.y = MappingManager.getBottom( lastItem, this ) + MARGIN;				lastItem = employeesPhotosList;			}						dispatchHeighUpdated();		}				/**		 * 		 * @param	event		 */				private function onBackClicked( event:MouseEvent ):void {			dispatchEvent( new ScreenEvent( ScreenEvent.GO_BACK ) );		}				/**		 * 		 * @param	event		 */				private function onSizeChanged( event:Event ):void {			setPositions();		}			}}