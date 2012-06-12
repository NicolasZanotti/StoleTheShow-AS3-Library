package collections
{
	import flexunit.framework.Assert;

	import stoletheshow.collections.StringDictionary;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class StringDictionaryTest extends Sprite
	{
		private var dict:StringDictionary;

		[Before]
		public function createDummyStringDictionary():void
		{
			dict = new StringDictionary({"KEY1":"ENTRY1", "KEY2":"ENTRY2"});
		}

		[Test]
		public function checkEntries():void
		{
			Assert.assertEquals(dict.getEntry("KEY1"), "ENTRY1");
			Assert.assertEquals(dict.getEntry("KEY2"), "ENTRY2");
		}

		[Test]
		public function checkEntryForInexistentEntry():void
		{
			Assert.assertEquals(dict.getEntry("NOTHING"), "[NOTHING]");
		}

		[Test]
		public function checkKeys():void
		{
			Assert.assertEquals(dict.getKey("ENTRY1"), "KEY1");
			Assert.assertEquals(dict.getKey("ENTRY2"), "KEY2");
		}

		[Test]
		public function checkEntryForInexistentKey():void
		{
			Assert.assertEquals(dict.getKey("NOTHING"), "");
		}
	}
}