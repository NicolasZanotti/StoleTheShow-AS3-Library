package stoletheshow.model
{
	import stoletheshow.control.Disposable;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * Keeps track of events. Based on code by Grant Skinner, from his talk on resource management. 
	 * 
	 * @author Grant Skinner, Nicolas Zanotti
	 * @see http://gskinner.com/talks/resource-management/
	 */
	public class Events implements Disposable
	{
		protected var _dispatchers:Dictionary;
		protected var _paused:Boolean;

		/**
		 * Adds an Event Listener and saves it inside a dictionary for Disposal
		 * @author Grant Skinner, adapted by Nicolas Zanotti
		 */
		public function add(dispatcher:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (_dispatchers == null) _dispatchers = new Dictionary(true);
			dispatcher.addEventListener(type, listener, useCapture, 0, true);
			
			var hash:Object = _dispatchers[dispatcher];
			if (hash == null) hash = _dispatchers[dispatcher] = {};
			
			var arr:Array = hash[type];
			if (arr == null) hash[type] = arr = [];

			// Check for duplicates:
			for (var i:uint = 0, obj:Object, n:uint = arr.length;i < n;i++)
			{
				obj = arr[i];
				if (obj.l == listener && obj.u == useCapture) return;
			}
			arr.push({l:listener, u:useCapture});
		}

		/**
		 * Removes an Event Listener
		 * @author Grant Skinner, adapted by Nicolas Zanotti
		 */
		public function remove(dispatcher:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
			if (_dispatchers == null || _dispatchers[dispatcher] == null || _dispatchers[dispatcher][type] == null) return;
			
			var arr:Array = _dispatchers[dispatcher][type];
			
			for (var i:uint = 0, obj:Object, n:uint = arr.length;i < n;i++)
			{
				obj = arr[i];
				if (obj.l == listener && obj.u == useCapture)
				{
					arr.splice(i, 1);
					return;
				}
			}
		}

		/**
		 * Removes all Event Listeners
		 * @author Grant Skinner, adapted by Nicolas Zanotti
		 * 
		 * If within a class you add an eventlistener to *ANY* object, even with abstract/inline functions and weak references, or if the object is "this" -> GC *is* prevented *UNTIL* the event is removed.
		 */
		public function removeAll():void
		{
			var types:Object, arr:Array, obj:Object;

			for (var dispatcher:Object in _dispatchers)
			{
				types = _dispatchers[dispatcher];
				for (var type:String in types)
				{
					arr = types[type];
					while (arr.length > 0)
					{
						obj = arr.pop();
						(dispatcher as EventDispatcher).removeEventListener(type, (obj.l as Function), Boolean(obj.u));
					}
				}
			}
		}

		public function dispose():void
		{
			removeAll();
			_dispatchers = null;
		}

		// ---------------------------------------------------------------------
		// Getters and setters
		// ---------------------------------------------------------------------
		public function set paused(b:Boolean):void
		{
			if (b == _paused) return;

			_paused = b;

			var types:Object, a:Array, n:int, obj:Object;

			for (var dispatcher:Object in _dispatchers)
			{
				types = _dispatchers[dispatcher];

				for (var type:String in types)
				{
					a = types[type];
					n = a.length;

					for (var i:int = 0; i < n; i++)
					{
						obj = a[i];

						if (_paused) (dispatcher as EventDispatcher).removeEventListener(type, (obj.l as Function), Boolean(obj.u));
						else (dispatcher as EventDispatcher).addEventListener(type, (obj.l as Function), Boolean(obj.u), 0, true);
					}
				}
			}
		}

		public function get paused():Boolean
		{
			return _paused;
		}
	}
}