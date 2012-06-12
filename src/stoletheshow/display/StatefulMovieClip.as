package stoletheshow.display
{
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;


	/**
	 * Forces a MovieClip to be controlled only via the state attribute. Calling any animation methods will result in an error.
	 * 
	 * This is useful for components that have different view states placed on the timeline.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class StatefulMovieClip extends MovieClip implements StateChangeable
	{

		public function set state(name:String):void { super.gotoAndStop(name); }

		public function get state():String { return currentLabel; }

		override public function gotoAndPlay(frame:Object, scene:String = null):void { throw new IllegalOperationError(); }

		override public function gotoAndStop(frame:Object, scene:String = null):void { throw new IllegalOperationError(); }

		override public function nextFrame():void { throw new IllegalOperationError(); }

		override public function nextScene():void { throw new IllegalOperationError(); }

		override public function play():void { throw new IllegalOperationError(); }

		override public function prevFrame():void { throw new IllegalOperationError(); }

		override public function prevScene():void { throw new IllegalOperationError(); }
	}
}