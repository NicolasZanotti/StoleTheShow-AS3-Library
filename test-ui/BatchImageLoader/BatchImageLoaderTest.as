package
{
	import stoletheshow.loaders.BatchImageLoader;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Nicolas Zanotti
	 */
	public class BatchImageLoaderTest extends Sprite
	{
		public var loader:BatchImageLoader;
		var url1:String = "http://farm8.static.flickr.com/7105/7361325254_63fb09705e_t.jpg", url2:String = "http://farm8.static.flickr.com/7103/7361320268_44fe4db6f5_t.jpg", url3:String = "http://farm8.static.flickr.com/7245/7176096069_88ba1225c9_t.jpg";
		var image1:Bitmap, image2:Bitmap, image3:Bitmap;

		public function BatchImageLoaderTest()
		{
			loader = new BatchImageLoader();
			loader.addEventListener(BatchImageLoader.ALL_COMPLETE, onComplete);
			loader.load([url1, url2, url3]);

			image1 = addChild(loader.getImage(url1)) as Bitmap;
			image1.x = 0;

			image2 = addChild(loader.getImage(url2)) as Bitmap;
			image2.x = 150;

			image3 = addChild(loader.getImage(url3)) as Bitmap;
			image3.x = 300;
		}

		private function onComplete(event:Event):void
		{
			trace("onComplete");
			
			image1.bitmapData = loader.getImage(url1).bitmapData;
			image2.bitmapData = loader.getImage(url2).bitmapData;
			image3.bitmapData = loader.getImage(url3).bitmapData;
		}
	}
}