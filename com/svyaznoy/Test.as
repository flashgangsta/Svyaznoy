package com.svyaznoy {
	import com.flashgangsta.net.ContentLoader;
	import com.svyaznoy.events.LoginSectionEvent;
	import com.svyaznoy.events.ProviderEvent;
	import com.svyaznoy.gui.Paging;
	import com.svyaznoy.modules.Voting;
	import com.svyaznoy.utils.ContentParser;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Test extends Sprite {
		
		private var provider:Provider = Provider.getInstance();
		private var helper:Helper = Helper.getInstance();
		
		public function Test() {
			//Helper
			helper.isDebug = ( loaderInfo.url.indexOf( "http" ) !== 0 );
			ContentLoader.context = helper.loaderContext;
			//Provider
			provider.init();
			
			var paging:Paging = getChildByName( "paging_mc" ) as Paging;
			paging.init( 7 );
			
		}
		
	}

}