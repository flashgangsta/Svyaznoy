package com.svyaznoy {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class UserData {
		
		private var _username:String;
		private var _active:Boolean;
		private var _created_at:String;
		private var _id:String;
		private var _updated_at:String;
		private var _employee:Boolean;
		private var _intro:Boolean;
		
		/**
		 * 
		 * @param	data
		 */
		
		public function UserData( data:Object ) {
			_username = data.username;
			_active = Boolean( int( data.active ) );
			_created_at = data.created_at;
			_id = data.id;
			_updated_at = data.updated_at;
			_employee = data.hasOwnProperty( "employee" );
			_intro = Boolean( int( data.intro ) );
		}
		
		/**
		 * 
		 */
		
		public function get username():String {
			return _username;
		}
		
		/**
		 * 
		 */
		
		public function get active():Boolean {
			return _active;
		}
		
		/**
		 * 
		 */
		
		public function get created_at():String {
			return _created_at;
		}
		
		/**
		 * 
		 */
		
		public function get id():String {
			return _id;
		}
		
		/**
		 * 
		 */
		
		public function get updated_at():String {
			return _updated_at;
		}
		
		/**
		 * 
		 */
		
		public function get employee():Boolean {
			return _employee;
		}
		
		public function get intro():Boolean {
			return _intro;
		}
		
	}

}