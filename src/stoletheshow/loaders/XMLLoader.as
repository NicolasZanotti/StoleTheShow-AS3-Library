package stoletheshow.loaders 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Julien Villiger, Nicolas Zanotti
	 * 
	 * Loads XML and dispatches Event when its done.
	 * 
	 */
	public class XMLLoader extends EventDispatcher 
	{
		public var content:XML;

		public function XMLLoader() 
		{
		}

		public function loadXML(url:String):void 
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoad, false, 0, true);			loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			loader.load(new URLRequest(url));
		}

		private function onLoad(event:Event):void 
		{
			var loader:URLLoader = event.target as URLLoader;

			content = new XML(loader.data);
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			// Clean up
			loader.removeEventListener(Event.COMPLETE, onLoad, false);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError, false);
		}

		private function onError(event:IOErrorEvent):void 
		{
			throw new Error("Could not load XML " + event.text);
		}
	}
}