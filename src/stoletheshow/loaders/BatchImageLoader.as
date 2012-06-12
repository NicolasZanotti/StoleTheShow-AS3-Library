package stoletheshow.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	import stoletheshow.control.Disposable;

	/**
	 * Loads multiple images and provides placeholder BitmapData for immediate use.
	 * 
	 * @usage <code>
	 * 	var loader = new BatchImageLoader();
	 *	loader.addEventListener(BatchImageLoader.ALL_COMPLETE, onComplete);
	 *	loader.load(["image1.png", "image2.png", "image3.png", "image4.png"]);
	 *	
	 *	var image1:Bitmap = addChild(loader.getImage("image1.png")) as Bitmap;
	 *	// place images...
	 *	
	 *	function onComplete():void {
	 *		image1.bitmapData = loader.getImage("image1.png").bitmapData;
	 *	}
	 *	
	 * </code>
	 * 
	 * TODO Add an auto-update mechanism
	 * TODO Pass placeholder image?
	 * 
	 * @author Nicolas Zanotti
	 */
	public class BatchImageLoader extends EventDispatcher implements Disposable
	{
		public static const FIRST_COMPLETE:String = "first_complete";
		public static const LOAD_ERROR:String = "first_error";
		public static const ALL_COMPLETE:String = "all_complete";
		protected var _urls:Array;
		protected var _amountLoaded:uint;
		protected var _data:Object = {};

		public function BatchImageLoader()
		{
		}

		/* ------------------------------------------------------------------------------- */
		/*  Public */
		/* ------------------------------------------------------------------------------- */
		public function load(urls:Array):void
		{
			_urls = urls;

			// Remove Duplicates
			_urls = _urls.filter(isSame);

			// Load all images
			for each (var url:String in _urls)
			{
				// Insert a placeholder Bitmap so it can be accessed immediately.
				_data[url] = new Bitmap(new BitmapData(1, 1, false, 0xFFFFFF));

				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
				loader.load(new URLRequest(url));
			}
		}

		public function getImage(url:String):Bitmap
		{
			if (url.length < 1) throw new Error("URL too short");
			if (_data[url] == null) throw new Error("URL '" + url + "' has no image");

			var duplicate:Bitmap = new Bitmap();
			duplicate.bitmapData = _data[url].bitmapData;
			return duplicate;
		}

		public function dispose():void
		{
			for each (var bmp:Bitmap in _data) bmp.bitmapData.dispose();
			_data = null;
			_urls = null;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event handlers */
		/* ------------------------------------------------------------------------------- */
		protected function onError(event:IOErrorEvent):void
		{
			trace(event.text);
			// Move on even if the image can't be loaded.
			dispatchEvent(new Event(LOAD_ERROR));
			_amountLoaded++;
		}

		protected function onLoaderComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			var bitmap:Bitmap = loader.content as Bitmap;

			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete, false);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError, false);

			var url:String = loader.contentLoaderInfo.url;

			trace("Loaded from " + url);

			// overwrite the placeholder data
			(_data[url] as Bitmap).bitmapData = bitmap.bitmapData;

			_amountLoaded++;

			if (_urls[0] == url) dispatchEvent(new Event(FIRST_COMPLETE));
			if (_amountLoaded == _urls.length)
			{
				dispatchEvent(new Event(ALL_COMPLETE));

				// Clean up
				_urls = null;
			}
		}

		/* ------------------------------------------------------------------------------- */
		/*  Helper Methods */
		/* ------------------------------------------------------------------------------- */
		protected final function isSame(e:*, i:int, a:Array):Boolean
		{
			return a.indexOf(e) == i;
		}
	}
}