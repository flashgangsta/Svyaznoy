package com.svyaznoy {
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.utils.ScreenController;
	import com.svyaznoy.events.DynamicItemEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.events.ScreenEvent;
	import com.svyaznoy.events.ScrollbarEvent;
	import com.svyaznoy.gui.PreloaderAnimation;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class News extends Screen {
		
		private const MARGIN:int = 20;
		private const NEWS_STEP_LENGHT:int = 10;
		
		private var currentNewsLenght:int = 0;
		private var oldNewsLoader:ProviderURLLoader;
		private var oldNewsPreloader:PreloaderAnimation = new PreloaderAnimation();
		private var dispatcher:Dispatcher = Dispatcher.getInstance();
		private var newsDatasList:Array = [];
		private var allNewsLoaded:Boolean = false;
		
		/**
		 * 
		 */
		
		public function News() {
			oldNewsLoader = provider.getNewsList( NEWS_STEP_LENGHT );
			oldNewsLoader.addEventListener( ProviderEvent.ON_NEWS_LIST, onData );
			
			oldNewsPreloader.stop();
			oldNewsPreloader.visible = false;
			
			addEventListener( ScrollbarEvent.ON_SCROLLED, onScrolled );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onScrolled( event:ScrollbarEvent ):void {
			if ( event.percent === 100 && !oldNewsPreloader.isPlaying && !allNewsLoaded ) {
				loadOldNews();
			}
		}
		
		/**
		 * 
		 */
		
		private function loadOldNews():void {
			oldNewsPreloader.x = MappingManager.getCentricPoint( width, oldNewsPreloader.width );
			oldNewsPreloader.y = height + MARGIN;
			oldNewsPreloader.visible = true;
			oldNewsPreloader.play();
			addChild( oldNewsPreloader );
			dispatchHeighUpdated();
			dispatcher.dispatchEvent( new ScreenEvent( ScreenEvent.ON_OFFSET_LOADING_STARTED ) );
			oldNewsLoader = provider.getNewsList( NEWS_STEP_LENGHT, newsDatasList.length );
			oldNewsLoader.addEventListener( ProviderEvent.ON_NEWS_LIST, onNewsDatasList );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onNewsDatasList( event:ProviderEvent ):void {
			var list:Array = event.data as Array;
			var item:NewsListItem;
			
			newsDatasList = newsDatasList.concat( list );
			
			if ( oldNewsPreloader.isPlaying ) {
				oldNewsPreloader.stop();
				oldNewsPreloader.visible = false;
				removeChild( oldNewsPreloader );
			}
			
			if ( list.length < NEWS_STEP_LENGHT ) {
				allNewsLoaded = true;
				if ( !list.length ) {
					return;
				}
			}
			
			for ( var i:int = 0; i < list.length; i++ ) {
				item = new NewsListItem( list[ i ] );
				addChild( item );
			}
			
			updatePositions( MARGIN );
		}
		
		/**
		 * 
		 * @param	data
		 */
		
		override protected function onData( event:ProviderEvent ):void {
			oldNewsLoader.removeEventListener( ProviderEvent.ON_NEWS_LIST, onData );
			super.onData( event );
			onNewsDatasList( event );
			addEventListener( DynamicItemEvent.SIZE_CHANGED, onSizeChanged );
		}
		
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSizeChanged( event:DynamicItemEvent ):void {
			updatePositions( MARGIN );
		}
		
	}

}