package  
{
	import stoletheshow.control.Controllable;
	import stoletheshow.control.Controller;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Nicolas Zanotti
	 */
	public class Widget extends MovieClip implements Controllable
	{
		public var ct:Controller;
		public var bt:SimpleButton;
		private var _tickCounter:uint = 0;

		public function Widget() 
		{
			ct = new Controller(this);
		}

		private function onBtClick(event:Event):void 
		{
			trace("Widget: onBtClick()");
		}

		private function onStageEnterFrame(event:Event):void 
		{
			trace(_tickCounter++);
		}

		public function init():void
		{
			// add listeners
			ct.events.add(bt, MouseEvent.CLICK, onBtClick);
			ct.events.add(stage, Event.ENTER_FRAME, onStageEnterFrame);
		}

		public function dispose():void
		{
			trace("Widget: dispose()");
			ct = null;
		}
	}
}
