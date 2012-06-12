package stoletheshow.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * A Dictionary for holding String Values, dispatches Events on change.
	 * 
	 * @author Nicolas Zanotti
	 * @playerversion Flash 9.0.28.0
	 */
	public class StringDictionary extends EventDispatcher implements StringCollectable
	{
		protected var _data:Object = {};
		protected var _isLoaded:Boolean = false;

		public function StringDictionary(data:Object = null)
		{
			if (data != null) this.data = data;
		}

		override public function toString():String
		{
			var s:String = "";
			for (var i:String in _data) s += "\n" + i + "\t\t" + _data[i];
			return s;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Getters and Setters */
		/* ------------------------------------------------------------------------------- */
		public function getEntry(key:String):String
		{
			if (_data.hasOwnProperty(key)) return _data[key];
			return "[" + key + "]";
		}

		public function setEntry(key:String, value:String):void
		{
			if (key == null || value == null) throw new Error(key + " is null");
			_data[key] = value;
			dispatchEvent(new Event(Event.CHANGE, true, true));
		}

		public function getEntryAsAnchor(key:String, underline:Boolean = false, eventName:String = "anchorClick"):String
		{
			if (underline) return '<a href="event:' + eventName + '"><u>' + getEntry(key) + '</u></a>';
			else return '<a href="event:' + eventName + '">' + getEntry(key) + '</a>';
		}

		public function getEntryAsBullet(key:String):String
		{
			return "<li>" + getEntry(key) + "</li>";
		}

		public function getKey(entry:String):String
		{
			for (var s:String in _data) if (_data[s] == entry) return s;
			return "";
		}

		/**
		 * Data is checked when in development mode.
		 */
		public final function set data(data:Object):void
		{
			_data = data;
			dispatchEvent(new Event(Event.CHANGE, true, true));

			// Debugging: Check each entry if it's a String. Uncommented for better performance.
			// for (var i:String in _data) if (_data[i] == null || !(_data[i] is String)) throw new Error(i + " is not a valid entry [null: " + (_data[i] == null) + ", type:" + typeof(_data[i]) + "]");

			_isLoaded = true;
		}

		public function get loaded():Boolean
		{
			return _isLoaded;
		}
	}
}