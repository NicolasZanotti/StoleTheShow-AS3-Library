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
			Assert.assertEquals(dict.all(true), true);
			Assert.assertEquals(dict.all(false), false);
		}

		[Test]
		public function checkAllFalse():void
		{
			dict.foo = false;
			dict.bar = false;
			Assert.assertEquals(dict.all(false), true);
			Assert.assertEquals(dict.all(true), false);
		}

		[Test]
		public function checkMixed():void
		{
			dict.foo = false;
			dict.bar = true;
			Assert.assertEquals(dict.all(false), false);
			Assert.assertEquals(dict.all(true), false);
		}
	}
}