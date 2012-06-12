package model
{
	import stoletheshow.model.URLs;

	import org.flexunit.Assert;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class URLsTest extends Sprite
	{
		[Test]
		public function testLocalURL():void
		{
			Assert.assertEquals(new URLs({"url": "file:///C:/Library/bin/URLsTest.swf"}).baseURL, "");
		}
		
				[Test]
		public function testBaseURL():void
		{
			Assert.assertEquals(new URLs({"url": "http://www.domain.com/folder/file.swf"}).baseURL, "http://www.domain.com");
		}
		
		
				[Test]
		public function testSecureBaseURL():void
		{
			Assert.assertEquals(new URLs({"url": "https://www.domain.com/folder/file.swf"}).baseURL, "https://www.domain.com");
		}
		
				[Test]
		public function testForLocalPath():void
		{
			Assert.assertEquals(new URLs({"url": "http://sub.domain.com/_swf/test.swf"}).baseURL, "http://sub.domain.com");
		}
	}
}