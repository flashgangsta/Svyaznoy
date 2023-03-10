package com.svyaznoy.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PreviewEvent extends Event {
		
		static public const ON_VIDEO_REPORT_CALLED:String = "onVideoReportCalled";
		static public const ON_PHOTO_REPORT_CALLED:String = "onPhotoReportCalled";
		static public const ON_PROFILE_PHOTO_EDIT_CALLED:String = "onProfilePhotoEditCalled";
		static public const ON_PREVIEW_LOADED:String = "onPreviewLoaded";
		static public const ON_EMPLOYES_PHOTOS_CALLED:String = "onEmployesPhotosCalled";
		
		public var previewData:Object;
		
		public function PreviewEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );			
		} 
		
		public override function clone():Event { 
			return new PreviewEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "PreivewsEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}