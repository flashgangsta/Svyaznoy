package com.svyaznoy.utils {
	import com.svyaznoy.ContentTag;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ContentParser {
		
		static const TEMPLATE_TAG:RegExp =			/!\[(\w+)\]\(([\w:.\/@]+)\s?\[?([\w:@.]*)?\]?\)/;
		
		static const TEMPLATE_LINK:RegExp = 		/!\[(link)\]\(([\w:\/.@]+)\s?\[?([\w:@.]*)?\]?\)/;
		static const TEMPLATE_BOLD_TEXT:RegExp = 	/\Q**\E(.+)\Q**\E/;
		
		/**
		 * 
		 */
		
		public function ContentParser() {
			
		}
		
		/**
		 * 
		 * @param	text
		 * @return
		 */
		
		public static function parse( text:String ):Vector.<ContentTag> {
			var result:Vector.<ContentTag> = new Vector.<ContentTag>();
			var tag:ContentTag = getTag( text );
			var lastTag:ContentTag;
			var text:String = text.replace( TEMPLATE_LINK, replaceLinksTags ).replace( TEMPLATE_BOLD_TEXT, replaceBoldTextTags );
			
			if ( tag ) {
				while( tag ) {
					tag.index = text.indexOf( tag.tag );
					if ( tag.index > 0 ) {
						var textTag:ContentTag = createTextTag( text.substr( 0, tag.index ) );
						result.push( textTag );
						text = text.replace( textTag.value, "" );
					}
					result.push( tag );
					text = text.replace( tag.tag, "" );
					
					tag = getTag( text );
				}
				
				if ( text.length ) {
					result.push( createTextTag( text ) );
				}
				
			} else {
				result.push( createTextTag( text, 0 ) );
			}
			
			return result;
		}
		
		/**
		 * 
		 * @param	text
		 * @param	index
		 * @return
		 */
		
		static private function createTextTag( text:String, index:int = 0 ):ContentTag {
			var tag:ContentTag = new ContentTag( null, ContentTag.TEXT, text, null, index );
			tag.tag = "![" + tag.name + "](" + tag.value + ")";
			return tag;
		}
		
		/**
		 * 
		 * @param	text
		 */
		
		static private function replaceLinksTags( tag:String, tagName:String, tagValue:String, tagParam:String, position:int, text:String ):String {
			return "<a href='" + tagValue + "'>" + ( tagParam.length ? tagParam : tagValue ) + "</a>";
		}
		
		/**
		 * 
		 * @param	text
		 */
		
		static private function replaceBoldTextTags( tag:String, tagValue:String, ...params ):String {
			return "<b>" + tagValue + "</b>";
		}
		
		/**
		 * 
		 */
		
		static private function getTag( text:String ):ContentTag {
			var tagData:Object = TEMPLATE_TAG.exec( text );
			var tagDataParams:Array;
			var result:ContentTag;
			
			if ( tagData ) {
				tagDataParams = String( tagData ).split( "," )
				result = new ContentTag( tagDataParams[ 0 ], tagDataParams[ 1 ], tagDataParams[ 2 ], tagDataParams[ 3 ] );
				result.index = text.indexOf( result.tag );
			}
			
			return result;
		}
	}

}