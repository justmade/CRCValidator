package com.event
{
	import flash.events.Event;
	
	public class EventMessage extends Event
	{
		public static const GET_FILE_PATH:String = "GET_FILE_PATH";
		
		public static const CLICK_OPEN_BT:String = "CLICK_OPEN_BT";
		
		public static const CLICK_TURN_BT:String = "CLICK_TURN_BT";
		
		
		
		public var filePath:String ;
		public function EventMessage(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}