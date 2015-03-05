package com.load
{
	import com.event.EventMessage;
	import com.flashrek.utils.CRC32;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import ui.RunPop;
	
	public class GetNewSwf extends Sprite
	{
		private var versionsXml:XML = <Data></Data>;
		private var pathText:TextField ;
		private var runPop:RunPop ;
		
		
		private static var _instance:GetNewSwf;
		
		
		public function GetNewSwf(lock:Lock)
		{
			initText();
		}
		
		public static function getInstance():GetNewSwf
		{
			if(_instance == null){
				_instance = new GetNewSwf(new Lock());
			}
			return _instance;
		}
		
		private function initText():void{
			runPop = new RunPop();
			this.addChild(runPop);
			runPop.btnSaveXml.addEventListener(MouseEvent.CLICK , onSaveXml);
		}
		
		protected function onSaveXml(event:MouseEvent):void
		{
			this.SaveXml();
		}
		
		
		private var dirPicArr:Array = new Array();
		
		public function init():void{
			
			var dirPic:File = File.applicationDirectory//.resolvePath("C:\\Users\\dell\\Desktop\\1")
//			selectHandle()
			dirPic.browseForDirectory("");
			dirPic.addEventListener(Event.SELECT,selectHandle);
			dirPic.addEventListener(FileListEvent.DIRECTORY_LISTING,fileListHandle);
			cIndex =  0;
			dirPicArr.push(dirPic);
			files = new Array();
		}
		
		public function setFile(_str:String):void{
			var dirPic:File = new File(_str)
			cIndex =  0;
			dirPicArr.push(dirPic);
			files = new Array();
		}
		
		public function changeFile(_str:String):void{
			var t2_file:File = new File(_str)
			loopFileName(t2_file);
			doCRCFile();
		}
		
		protected function fileListHandle(event:FileListEvent):void
		{
			var t_file:File = event.target as File;
			t_file.getDirectoryListingAsync();
		}
		
		protected function selectHandle(event:Event = null):void
		{
			var e:EventMessage = new EventMessage(EventMessage.GET_FILE_PATH);
			e.filePath = event.currentTarget.nativePath ;
			this.dispatchEvent(e)
		}	
		private var fileList:Array;
		
		private var files:Array = [];
		
		private function loopFileName(_file:File):void{
			var fileList:Array = _file.getDirectoryListing().slice();
			
			for(var i:int = 0 ; i < fileList.length;)
			{
				var tf:File =fileList[i] as File;
				if(tf.isDirectory){
					loopFileName(tf);
				}else{
					if(tf.extension!="db"){
						files.push(tf);
					}
				}
				i = i + 1;
			}
		}
		
		private var cIndex:int = 0;
		
		private function doCRCFile():void
		{
			var tf:File = files[cIndex];
			startModifyName(tf);
		}
		
		private var dic:Dictionary = new Dictionary();
		
		private var count:int = 0;
		
		private function startModifyName(df:File):void
		{
			var prefixStr:String = "";
			if(df.parent.isDirectory)
			{
				var t_nativePathArr:Array = df.parent.nativePath.split("\\");
				if(t_nativePathArr.length > 0)
					prefixStr = t_nativePathArr[t_nativePathArr.length -1];
			}
			df.load();
			df.addEventListener(Event.COMPLETE, onComplete);
			dic[df.nativePath] = df;
		}
		
		protected function onComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onComplete);
			var df2:File = event.currentTarget as File;
			
			var extension:String = df2.extension ;
			var prefixStr:String = "";
			
			if(df2.parent.isDirectory)
			{
				var t_nativePathArr:Array = df2.parent.nativePath.split("\\");
				if(t_nativePathArr.length > 0)
					prefixStr = t_nativePathArr[t_nativePathArr.length -1];
			}
			
			var crc:CRC32=new CRC32();
			var ba:ByteArray=new ByteArray();
			ba.writeUTFBytes(String(df2.data));
			crc.update(ba,0,ba.length);
			var file_name:String =crc.getValue().toString(16).toLowerCase()
			var destination:File = new File();
			var lastName:String = (df2.name.split("."))[0] ; 
			
			if(prefixStr == "")
			{
				destination = destination.resolvePath(df2.parent.url+"/"+file_name);
			}	
			else
			{
				destination = destination.resolvePath(df2.parent.url+"/"+lastName+"_"+file_name+"."+extension);
			}
//			trace()
			for(var i:int = 0 ; i <dirPicArr.length ; i++ ){
				var url:String = dirPicArr[i].getRelativePath(df2);
				if(url!=null){
					var mainUrl:String = dirPicArr[i].nativePath.split("\\")[ dirPicArr[i].nativePath.split("\\").length -1];
					trace("url",url,mainUrl)
					var FileInfo:XML = <FileInfo crc ={file_name} resUrl ={url}></FileInfo>;
					runPop.txtLog.appendText(df2.url+"\n");
					(versionsXml as XML).appendChild(FileInfo);
					fileCopiedHandler();
				}
			}
		}
		
		private var completeI:int = 0;
		
		private function fileCopiedHandler():void
		{
			cIndex ++;
			if(cIndex < files.length){
				doCRCFile();
				runPop.txtLog.scrollV = runPop.txtLog.maxScrollV ;
			}else{
				this.dispatchEvent(new Event("Turn_Complete"));
				runPop.txtLog.appendText("转换成功"+"\n");
				runPop.txtLog.scrollV = runPop.txtLog.maxScrollV ;
			}
		}
		
		public function SaveXml():void{
			var fileR:FileReference = new FileReference();
			fileR.save(versionsXml,".xml");
			fileR.addEventListener(Event.SELECT , onSelectComplete);
		}
		
		protected function onSelectComplete(event:Event):void
		{
			this.dispatchEvent(new Event("XML_SAVE_COMPLETE"));
			runPop.txtLog.appendText("保存成功"+"\n");
			runPop.txtLog.scrollV = runPop.txtLog.maxScrollV ;
		}
	}
}class Lock{}