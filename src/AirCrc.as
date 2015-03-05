package
{
	import com.SingleList;
	import com.event.EventMessage;
	import com.load.GetNewSwf;
	import com.save.LocalSave;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import ui.Title;

	[SWF(height="800",width="600",backgroundColor="0x00ffffff")]
	public class AirCrc extends Sprite
	{
		private var openBt:Sprite ; 
		
		private var xmlBt:Sprite ;
		
		private var listArr:Array ;
		
		private var listOpenIndex:int ; 
		
		private var listTurnIndex:int ; 
		
		public function AirCrc()
		{
			init();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage)
		}
		
		private var window:NativeWindow
		protected function onAddStage(event:Event):void
		{
			window = stage.nativeWindow ; 
		
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMove);
			
			LocalSave.getInstance().init();
			var arr:Array = LocalSave.getInstance().getConfigObj();
			
			if(arr.length >0){
				creatList(arr);
			}
		}
		
		protected function onMove(event:MouseEvent):void
		{
			window.startMove();
		}
		
		private function init():void{
			GetNewSwf.getInstance().addEventListener("Turn_Complete" , onTurnComplete) ; 
			listArr = new Array();
			
			initSkin();
			this.addChild(GetNewSwf.getInstance());
			GetNewSwf.getInstance().x = 5 ;
			GetNewSwf.getInstance().y = 75 ;
			GetNewSwf.getInstance().addEventListener(EventMessage.GET_FILE_PATH,onGetPath);
//			openBt = new Sprite();
//			openBt.graphics.beginFill(0x666666,1);
//			openBt.filters =[ new DropShadowFilter(2,45,0x999999,1)];
//			openBt.graphics.drawRoundRect(0,0,75,34,20,20);
//			openBt.graphics.endFill() ; 
//			openBt.x = 250 ;
//			openBt.y = 20;
//			this.addChild(openBt);
//			openBt.addEventListener(MouseEvent.CLICK , onSelectPicture);
//			textInit(openBt,"OPEN");
			
//			xmlBt = new Sprite();
//			xmlBt.graphics.beginFill(0x666666,1);
//			xmlBt.filters =[ new DropShadowFilter(2,45,0x999999,1)];
//			xmlBt.graphics.drawRoundRect(0,0,75,34,20,20);
//			xmlBt.graphics.endFill() ; 
//			xmlBt.x = 350 ;
//			xmlBt.y = 20;
//			this.addChild(xmlBt);
//			textInit(xmlBt,"SAVE");
		}
		
		private var skinTitle:Title ; 
		private function initSkin():void{
			skinTitle = new Title();
			skinTitle.btnAdd.buttonMode = true ;
			skinTitle.btnAdd.addEventListener(MouseEvent.CLICK , onAddList);
			this.addChild(skinTitle);
		}
		
		private function creatList(_arr:Array):void{
			for(var i:int = 0 ; i <_arr.length ; i++ ){
				var list:SingleList = new SingleList();
				list.changeAddress(String(_arr[i]))
				GetNewSwf.getInstance().setFile(String(_arr[i]))
				listArr.push(list);
				this.addChild(list);
				list.x = 0 ;
				list.y = list.height * (listArr.length - 1) + 312;
				list.addEventListener(EventMessage.CLICK_OPEN_BT , onClickOpen);
				list.addEventListener(EventMessage.CLICK_TURN_BT , onClickTurn);
			}
		}
		
		protected function onAddList(event:MouseEvent):void
		{
			var list:SingleList = new SingleList();
			listArr.push(list);
			this.addChild(list);
			list.x = 0 ;
			list.y = list.height * (listArr.length - 1) + 312;
			list.addEventListener(EventMessage.CLICK_OPEN_BT , onClickOpen);
			list.addEventListener(EventMessage.CLICK_TURN_BT , onClickTurn);
		}
		
		protected function onClickTurn(event:Event):void
		{
			listTurnIndex = listArr.indexOf(event.currentTarget);
			setAddress(listTurnIndex);
		}
		
		private var addressArr:Array = new Array();
		
		private function setAddress(_i:int):void{
			if(str!=""){
				var str:String = listArr[listTurnIndex].addressTxt ; 
				var myPattern:RegExp  = / \ /g;
				var path:String = str.replace(RegExp,"/");
				GetNewSwf.getInstance().changeFile(path);
				if(path!=""){
					addressArr.push(path);
				}
				saveAddress(addressArr)
			}
		}
		
		private function saveAddress(_arr:Array):void{
			LocalSave.getInstance().saveConfigObj(_arr);
		}
		
		
		
		protected function onClickOpen(event:Event):void
		{
			listOpenIndex = listArr.indexOf(event.currentTarget) ; 
			GetNewSwf.getInstance().init();
		}
		
		private function changeListTxt(_i:int,_str:String):void{
			listArr[_i].changeAddress(_str);
		}
		
		private function onGetPath(e:EventMessage):void{
			changeListTxt(listOpenIndex,e.filePath);
		}
		
		protected function onSaveXml(event:MouseEvent):void
		{
			GetNewSwf.getInstance().SaveXml();
		}
		private function textInit(_sp:Sprite,_str:String):void{
			var tx:TextField = new TextField();
			tx.defaultTextFormat = new TextFormat(null,16,0xffffff);
			tx.text = _str;
			_sp.addChild(tx);
			tx.mouseEnabled = false ; 
			tx.width = 75;
			tx.height = 34 ;
			tx.autoSize=  TextFieldAutoSize.CENTER;
			tx.x =openBt.width /2 - tx.width/2;
			tx.y = openBt.height /2 - tx.height/2;
		}
		
		
		protected function onTurnComplete(event:Event):void
		{
			xmlBt.addEventListener(MouseEvent.CLICK , onSaveXml);
		}
		
		protected function onXmlSaveComplete(event:Event):void
		{
			openBt.addEventListener(MouseEvent.CLICK , onSelectPicture);
		}
		
		protected function onSelectPicture(event:MouseEvent):void
		{
			GetNewSwf.getInstance().init();
			xmlBt.removeEventListener(MouseEvent.CLICK , onSaveXml);
//			openBt.removeEventListener(MouseEvent.CLICK , onSelectPicture);
		}
	}
}