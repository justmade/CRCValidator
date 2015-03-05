package com
{
	import com.event.EventMessage;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import ui.SingleAddres;
	
	public class SingleList extends Sprite
	{
		private var skin:SingleAddres ;
		public var addressTxt:String; 
		public function SingleList()
		{
			init();
		}
		
		private function init():void{
			skin = new SingleAddres();
			this.addChild(skin);
			skin.btnOpen.addEventListener(MouseEvent.CLICK , onOpen);
			skin.btnTurn.addEventListener(MouseEvent.CLICK , onTurn);
			skin.btnOpen.buttonMode = true; 
			skin.btnTurn.buttonMode = true; 
		}
		
		public function changeAddress(_str:String):void{
			skin.txtAddress.text = _str;
			addressTxt = _str;
		}
		
		protected function onTurn(event:MouseEvent):void
		{
			var e:EventMessage = new EventMessage(EventMessage.CLICK_TURN_BT);
			this.dispatchEvent(e);
		}
		
		protected function onOpen(event:MouseEvent):void
		{
			var e:EventMessage = new EventMessage(EventMessage.CLICK_OPEN_BT);
			this.dispatchEvent(e);
		}
	}
}