package collections
{
	import flexunit.framework.Assert;

	import stoletheshow.collections.List;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class ListTest extends Sprite
	{
		private var list:List;

		[Test]
		public function checkNext():void
		{
			list = new List([1, 2, 3, 4]);
			Assert.assertEquals(list.next, 1);
			Assert.assertEquals(list.next, 2);
			Assert.assertEquals(list.next, 3);
			Assert.assertEquals(list.next, 4);
			Assert.assertEquals(list.next, 1);
		}

		[Test]
		public function checkPrevious():void
		{
			list = new List([1, 2, 3, 4]);
			Assert.assertEquals(list.previous, 4);
			Assert.assertEquals(list.previous, 3);
			Assert.assertEquals(list.previous, 2);
			Assert.assertEquals(list.previous, 1);
			Assert.assertEquals(list.previous, 4);
		}

		[Test]
		public function checkIncrement():void
		{
			list = new List([1, 2, 3, 4]);
			var i:uint = 1;

			while (list.hasNext)
			{
				Assert.assertEquals(list.next, i);
				i++;
			}
		}

		[Test]
		public function checkDecrement():void
		{
			list = new List([1, 2, 3, 4]);
			var i:uint = 4;

			list.skipToLast();

			while (list.hasPrevious)
			{
				Assert.assertEquals(list.previous, i);
				i--;
			}
		}

		[Test]
		public function checkSingleEntryhasNext():void
		{
			list = new List([1]);
			Assert.assertFalse(list.hasNext);
		}

		[Test]
		public function checkSingleEntryhasPrev():void
		{
			list = new List([1]);
			Assert.assertFalse(list.hasPrevious);
		}

		[Test]
		public function checkSingleEntryNextPrev():void
		{
			list = new List([1]);
			Assert.assertEquals(list.next, 1);
			Assert.assertEquals(list.previous, 1);
		}
	}
}