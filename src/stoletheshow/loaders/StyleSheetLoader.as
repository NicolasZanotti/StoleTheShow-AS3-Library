package stoletheshow.loaders 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;

	/**
	 * @author Elkana Aron, Nicolas Zanotti
	 */
	public class StyleSheetLoader extends EventDispatcher
	{
		protected var _css:StyleSheet;

		public function StyleSheetLoader() 
		{
		}

		public function load(url:String):void 
		{
			var loader:URLLoader = new URLLoader();  
			loader.addEventListener(Event.COMPLETE, onLoad, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			loader.load(new URLRequest(url)); 			
		}

		public function onLoad(event:Event):void 
		{
			var loader:URLLoader = event.currentTarget as URLLoader;
			
			_css = new StyleSheet();
			
			try 
			{
				_css.parseCSS(loader.data);
			}
			catch(error:Error) 
			{
				trace(error.message);
				return;
			}
			dispatchEvent(new Event(Event.COMPLETE));
			
			// Clean up
			loader.removeEventListener(Event.COMPLETE, onLoad, false);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError, false);
		}

		private function onError(event:IOErrorEvent):void 
		{
			throw new Error("Could not load XML " + event.text);
		} 

		public function get css():StyleSheet 
		{		
			return _css;			
		}	
	}
}
