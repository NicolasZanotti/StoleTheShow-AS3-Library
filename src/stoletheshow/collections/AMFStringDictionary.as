package stoletheshow.collections
{
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.Responder;

	/**
	 * Handles the loading of an AMF based StringDictionary.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class AMFStringDictionary extends StringDictionary implements Loadable
	{
		private var _connection:NetConnection;
		
		/**
		 * @param connection, the NetConnection needs to be opened before loading ist possible.
		 */
		public function AMFStringDictionary(connection:NetConnection)
		{
			_connection = connection;
		}

		private function onFault(error:Object):void
		{
			throw new Error("Dictionary: " + error.description);
		}

		private function onGet(result:Object):void
		{
			data = result;
			loaded = true;
		}

		public function load(serviceURI:String, language:int):void
		{
			if (_connection.uri.length < 1) throw new Error("NetConnection not connected to server");
			_connection.call(serviceURI, new Responder(onGet, onFault), language);
		}

		public function set loaded(isLoaded:Boolean):void
		{
			_isLoaded = isLoaded;
			if (isLoaded)
			{
				dispatchEvent(new Event(Event.COMPLETE, true, true));
				dispatchEvent(new Event(Event.CHANGE, true, true));
			}
		}
	}
}
