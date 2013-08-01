package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ContentTag {
		
		/// Text tag name
		static public const TEXT:String = "text";
		/// Image tag name
		static public const IMAGE:String = "image";
		/// Youtube video tag name
		static public const YOUTUBE:String = "youtube";
		
		/// Tag
		public var tag:String;
		/// Tag name
		public var name:String;
		/// Value of tag
		public var value:String;
		/// Tag param
		public var param:String;
		///
		public var index:int;
		
		/**
		 * 
		 */
		
		public function ContentTag( tag:String = null, name:String = null, value:String = null, param:String = null, index:int = 0 ) {
			this.tag = tag;
			this.name = name;
			this.value = value;
			this.param = param;
			this.index = index;
		}
		
	}

}