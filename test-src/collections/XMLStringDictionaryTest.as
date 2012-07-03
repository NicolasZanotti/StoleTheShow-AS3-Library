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
		
		[Test]
		public function checkEmptyConstructor():void
		{
			dict = new XMLStringDictionary();
		}

		[Test]
		public function checkEntries():void
		{
			var xml:XML = <dict><item key="KEY-KEY_1">ENTRY1</item><item key="KEY-KEY_2">ENTRY2</item></dict>;
			dict = new XMLStringDictionary(xml);
			Assert.assertEquals("ENTRY1", dict.getEntry("KEY-KEY_1"));
			Assert.assertEquals("ENTRY2", dict.getEntry("KEY-KEY_2"));
		}

		[Test]
		public function checkDelimitUnderscore():void
		{
			var xml:XML = <dict><item key="KEY-KEY_1">ENTRY1</item><item key="KEY-KEY_2">ENTRY2</item></dict>;
			dict = new XMLStringDictionary(xml, true);

			Assert.assertEquals("ENTRY1", dict.getEntry("KEY_KEY_1"));
			Assert.assertEquals("ENTRY2", dict.getEntry("KEY_KEY_2"));
		}
	}
}