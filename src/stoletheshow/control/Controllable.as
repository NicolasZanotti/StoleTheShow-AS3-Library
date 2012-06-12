package stoletheshow.control 
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	/**
	 * @author Nicolas Zanotti
	 */
	public interface Controllable extends Disposable, IEventDispatcher
	{
		function init():void;

		function get root():DisplayObject;
	}
}