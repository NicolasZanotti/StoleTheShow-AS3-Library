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

		[Before]
		public function createDummyList():void
		{
			list = new List();

			list.add(1);
			list.add(2);
			list.add(3);
			list.add(4);
		}

		[Test]
		public function checkNext():void
		{
			Assert.assertEquals(list.next, 1);
			Assert.assertEquals(list.next, 2);
			Assert.assertEquals(list.next, 3);
			Assert.assertEquals(list.next, 4);
			Assert.assertEquals(list.next, 1);
		}

		[Test]
		public function checkPrevious():void
		{
			Assert.assertEquals(list.previous, 4);
			Assert.assertEquals(list.previous, 3);
			Assert.assertEquals(list.previous, 2);
			Assert.assertEquals(list.previous, 1);
			Assert.assertEquals(list.previous, 4);
		}

		[Test]
		public function checkIncrement():void
		{
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
			var i:uint = 4;

			list.skipToLast();

			while (list.hasPrevious)
			{
				Assert.assertEquals(list.previous, i);
				i--;
			}
		}
	}
}