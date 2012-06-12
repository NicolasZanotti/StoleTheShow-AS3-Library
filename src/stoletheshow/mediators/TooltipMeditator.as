package stoletheshow.mediators 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import stoletheshow.display.Textdisplayable;


	/**
	 * @author Nicolas Zanotti
	 */
	public class TooltipMeditator 
	{
		public var isShowing:Boolean = false;
		private var _tt:DisplayObject;
		private var _container:DisplayObjectContainer;

		public function TooltipMeditator(container:DisplayObjectContainer, tooltip:DisplayObject) 
		{
			_container = container;
			_tt = tooltip;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event Handlers */
		/* ------------------------------------------------------------------------------- */
		private function onMouseMove(event:MouseEvent):void 
		{
			_tt.x = _container.mouseX;
			_tt.y = _container.mouseY;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Public methods */
		/* ------------------------------------------------------------------------------- */
		public function show(text:String):void 
		{
			if (isShowing) return;
			_container.addChild(_tt);
			_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			if (_tt is Textdisplayable) (_tt as Textdisplayable).text = text;
			isShowing = true;
		}

		public function hide():void 
		{
			if (!isShowing) return;
			if (_tt is Textdisplayable) (_tt as Textdisplayable).text = "";
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
			_container.removeChild(_tt);
			isShowing = false;
		}
	}
}
