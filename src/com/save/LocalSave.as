package com.save
{
	import flash.net.SharedObject;

	public class LocalSave
	{
		private var localDataName:String = "CRCData";
		
		public var sharedObj:SharedObject;
		
		private static var _instance:LocalSave;
		
		public function LocalSave(lock:Lock)
		{
			
		}
		
		public static function getInstance():LocalSave
		{
			if(_instance == null){
				_instance = new LocalSave(new Lock());
			}
			return _instance;
		}
		
		public function init():void{
			sharedObj = SharedObject.getLocal(localDataName, "/");
		}
		
		public function saveConfigObj(arr:Array):void
		{
			sharedObj.data["address"] = arr;
			sharedObj.flush();
		}
		
		public function getConfigObj():Array
		{
			return sharedObj.data["address"];
		}
		
		
	}
}class Lock{}