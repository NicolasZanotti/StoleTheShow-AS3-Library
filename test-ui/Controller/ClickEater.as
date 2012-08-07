package
{
	import stoletheshow.control.Controllable;
	import stoletheshow.control.Controller;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Nicolas Zanotti
	 */
	public class ClickEater extends Sprite implements Controllable
	{
		private var _ct:Controller;

		public function ClickEater()
		{
			_ct = new Controller(this);
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event Handlers */
		/* ------------------------------------------------------------------------------- */
		private function onLock(event:Event = null):void
		{
			visible = true;
		}

		private function onUnlock(event:Event = null):void
		{
			visible = false;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Controller Methods */
		/* ------------------------------------------------------------------------------- */
		public function init():void
		{
			// Configure listeners
			_ct.events.add(stage, "interface_lock", onLock);
			_ct.events.add(stage, "interface_unlock", onUnlock);

			// Restore state
			onUnlock();
		}

		public function dispose():void
		{
		}
	}
}