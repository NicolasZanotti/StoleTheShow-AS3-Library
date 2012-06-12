package stoletheshow.collections {

	/**
	 * Allows a preloader to check if the Object has completed loading.
	 * Usefull in Loading Cue's inside an Enterframe Event.
	 * @author Nicolas Zanotti
	 */
	public interface Loadable {
		function get loaded() : Boolean;

		function load(serviceURI : String, langauge : int) : void;
	}
}