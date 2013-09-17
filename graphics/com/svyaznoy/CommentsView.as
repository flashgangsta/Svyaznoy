package com.svyaznoy {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CommentsView extends Sprite {
		
		private var _contentMask:DisplayObject;
		private var _contentContainer:MovieClip;
		private var _scrollbarView:ScrollbarView;
		
		/**
		 * 
		 */
		
		public function CommentsView() {
			_contentMask = getChildByName( "mask_mc" ) as DisplayObject;
			_contentContainer = getChildByName( "content_mc" ) as MovieClip;
			_scrollbarView = getChildByName( "scrollbar_mc" ) as ScrollbarView;
			
			_contentContainer.mask = _contentMask;
		}
		
		/**
		 * 
		 */
		
		public function get contentMask():DisplayObject {
			return _contentMask;
		}
		
		/**
		 * 
		 */
		
		public function get contentContainer():MovieClip {
			return _contentContainer;
		}
		
		/**
		 * 
		 */
		
		public function get scrollbarView():ScrollbarView {
			return _scrollbarView;
		}
		
	}

}