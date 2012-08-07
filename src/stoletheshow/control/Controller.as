package stoletheshow.control
{
	import stoletheshow.display.helpers.DisplayListHelper;
	import stoletheshow.model.Events;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Multi-purpose utility class for controlling a DisplayObject.
	 * 
	 * 1. Initializes/disposes the owner based on its inclusion in the display list.
	 * 2. Keeps track of the owners events.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class Controller
	{
		protected var _owner:Controllable;
		protected var _hasEvents:Boolean = false;
		protected var _events:Events;
		protected var _isLocked:Boolean = false;

		public function Controller(owner:Controllable)
		{
			_owner = owner;
			
			_owner.addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			_owner.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event Handlers */
		/* ------------------------------------------------------------------------------- */
		protected function onAdded(event:Event):void
		{
			event.stopPropagation();

			_owner.removeEventListener(Event.ADDED_TO_STAGE, onAdded, false);
			_owner.init();
		}

		protected function onRemoved(event:Event):void
		{
			event.stopPropagation();

			if (_hasEvents)
			{
				_events.dispose();
				_events = null;
				_hasEvents = false;
			}

			if (_owner is MovieClip)
			{
				(_owner as MovieClip).stop();
			}

			if (_owner is DisplayObjectContainer && (_owner as DisplayObjectContainer).numChildren > 0)
			{
				new DisplayListHelper(_owner as DisplayObjectContainer).removeChildren();
			}

			_owner.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false);
			_owner.dispose();
			_owner = null;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Getters and setters */
		/* ------------------------------------------------------------------------------- */
		public function get events():Events
		{
			if (!_hasEvents)
			{
				_events = new Events();
				_hasEvents = true;
			}

			return _events;
		}
	}
}