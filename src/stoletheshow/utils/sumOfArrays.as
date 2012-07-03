package stoletheshow.utils
{
	/**
	 * <code>
	 * 	var sum:Array = sumOfArrays([1,2], [1,2]); // returns [2, 4]
	 * </code>
	 * 
	 * @return An array with the sum of each value.
	 * @author Nicolas Zanotti
	 */

	public function sumOfArrays(...args):Array
	{
		var sum:Array = [];
		var arrays:Array = [];
		var longestArrayLength:uint = 0;

		for (var i:int = 0, n:int = args.length; i < n; i++)
		{
			if (args[i] is Array)
			{
				arrays.push(args[i]);
				longestArrayLength = args[i].length > longestArrayLength ? args[i].length : longestArrayLength;
			}
		}

		for (var j:int = 0; j < longestArrayLength; j++)
		{
			sum[j] = 0;

			for (i = 0; i < n; i++)
			{
				sum[j] += isNaN(arrays[i][j]) ? 0 : arrays[i][j];
			}
		}

		return sum;
	}
}