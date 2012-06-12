package stoletheshow.model 
{

	/**
	 * Abstract ValueObject that applies an object to itself. 
	 * Good for applying dynamic objects (like loaded JSON) to statically typed ValueObjects.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class ValueObject 
	{
		public function ValueObject(obj:Object = null) 
		{
			if (obj != null) for (var i:String in obj) this[i] = obj[i];
		}
	}
}