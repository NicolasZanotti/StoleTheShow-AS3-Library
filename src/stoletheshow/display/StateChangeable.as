package stoletheshow.display 
{

	/**
	 * @author Nicolas Zanotti
	 */
	public interface StateChangeable 
	{
		function set state(name:String):void
		
		function get state():String
	}
}