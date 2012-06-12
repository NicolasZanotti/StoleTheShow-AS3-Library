package stoletheshow.collections {

	/**
	 * This can be applied to Collection classes such such as Dictionairies
	 * @author Nicolas Zanotti
	 */
	public interface StringCollectable {
		function getEntry(key : String) : String;

		function setEntry(key : String, value : String) : void;
	}
}
