package collections
{
	import flexunit.framework.Assert;

	import stoletheshow.collections.XMLStringDictionary;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class XMLStringDictionaryTest extends Sprite
	{
		private var dict:XMLStringDictionary;

		[Before]
		public function createDummyStringDictionary():void
		{
			dict = new XMLStringDictionary(<dict><item key="KEY-KEY_1">ENTRY1</item><item key="KEY-KEY_2">ENTRY2</item></dict>);
		}

		[Test]
		public function checkEntries():void
		{
			Assert.assertEquals(dict.getEntry("KEY-KEY_1"), "ENTRY1");
			Assert.assertEquals(dict.getEntry("KEY-KEY_2"), "ENTRY2");
		}
	}
}