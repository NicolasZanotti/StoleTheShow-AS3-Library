package stoletheshow.collections
{
	/**
	 * Simple dictionary of Boolean values. Can check if all are true or false.
	 * 
	 * Usage:
	 * 
	 * <code>
	 * 
	 * var dict = new BooleanDictionary();
	 * dict.foo = true;
	 * dict.bar = true;
	 * 
	 * dict.all(true); // returns true
	 * dict.all(false); // returns false
	 * 
	 * </code>
	 * 
	 * @author Nicolas Zanotti
	 */
	public dynamic class BooleanDictionary
	{
		public function BooleanDictionary(objectOfBooleanValues:Object = null)
		{
			if (objectOfBooleanValues != null) for (var i:String in objectOfBooleanValues) this[i] = objectOfBooleanValues[i];
		}

		public function all(isTrue:Boolean):Boolean
		{
			for each (var b:Boolean in this) if (b != isTrue) return false;
			return true;
		}
	}
}