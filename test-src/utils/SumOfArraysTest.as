package utils
{
	import flexunit.framework.Assert;

	import stoletheshow.utils.sumOfArrays;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class SumOfArraysTest extends Sprite
	{
		[Test]
		public function testTwoArrays():void
		{
			var sum:Array = sumOfArrays([1, 2], [1, 2]);
			Assert.assertEquals(sum.length, 2);
			Assert.assertEquals(sum[0], 2);
			Assert.assertEquals(sum[1], 4);
		}

		[Test]
		public function testThreeArrays():void
		{
			var sum:Array = sumOfArrays([1, 2, 3], [1, 2, 3]);
			Assert.assertEquals(sum.length, 3);
			Assert.assertEquals(sum[0], 2);
			Assert.assertEquals(sum[1], 4);
			Assert.assertEquals(sum[2], 6);
		}
	}
}