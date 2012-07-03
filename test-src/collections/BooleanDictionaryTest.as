package collections
{
	import flexunit.framework.Assert;

	import stoletheshow.collections.BooleanDictionary;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class BooleanDictionaryTest extends Sprite
	{
		private var dict:BooleanDictionary;

		[Before]
		public function createDummyStringDictionary():void
		{
			dict = new BooleanDictionary();
		}

		[Test]
		public function checkAllTrue():void
		{
			dict.foo = true;
			dict.bar = true;
			Assert.assertTrue(dict.all(true));
			Assert.assertFalse(dict.all(false));
		}

		[Test]
		public function checkAllFalse():void
		{
			dict.foo = false;
			dict.bar = false;
			Assert.assertTrue(dict.all(false));
			Assert.assertFalse(dict.all(true));
		}

		[Test]
		public function checkMixed():void
		{
			dict.foo = false;
			dict.bar = true;
			Assert.assertFalse(dict.all(false));
			Assert.assertFalse(dict.all(true));
		}
	}
}