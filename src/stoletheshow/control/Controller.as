package stoletheshow.control
{
	import stoletheshow.display.helpers.DisplayListHelper;
	import stoletheshow.model.Events;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Initializes/disposes the owner and its events when it is added/removed to the DisplayList.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class Controller
	{
		public static var INTERFACE_LOCK:String = "interface_lock";
		public static var INTERFACE_UNLOCK:String = "interface_unlock";
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
		protected function onAdded(e:Event):void
		{
			e.stopPropagation();

			_owner.removeEventListener(Event.ADDED_TO_STAGE, onAdded, false);
			_owner.init();
		}

		protected function onRemoved(e:Event):void
		{
			e.stopPropagation();

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
		
		/**
		 * Block interaction with the interface. For instance when a form is being submitted.
		 */
		public function set locked(isLocked:Boolean):void
		{
			_isLocked = isLocked;
			
			// TODO cover owner with clickEater
			
			_owner.root.stage.dispatchEvent(new Event(_isLocked ? INTERFACE_LOCK : INTERFACE_UNLOCK));
		}

		public function get locked():Boolean
		{
			return _isLocked;
		}
	}
}