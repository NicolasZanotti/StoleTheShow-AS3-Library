package stoletheshow.utils
{
	/**
	 * @author Julien Villiger, Nicolas Zanotti
	 */

	public function uniqueRandomNumbers(length:Number):Array
	{
		var randomNumber:Number, randomNumbers:Array = [], exists:Boolean;

		for (var i:int = 0;i < length; i++)
		{
			exists = false;
			randomNumber = Math.floor(Math.random() * length);

			for (var j:int = 0, n:uint = randomNumbers.length;j < n; j++)
			{
				if (randomNumber == randomNumbers[j])
				{
					exists = true;
					break;
				}
			}

			exists ? i-- : randomNumbers.push(randomNumber);
		}

		return randomNumbers;
	}
}