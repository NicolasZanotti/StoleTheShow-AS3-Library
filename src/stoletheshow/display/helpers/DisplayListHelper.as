package stoletheshow.display.helpers
{
	import stoletheshow.control.Disposable;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;

	/**
	 * @author Nicolas Zanotti
	 */
	public class DisplayListHelper
	{
		protected var _container:DisplayObjectContainer;

		public function DisplayListHelper(container:DisplayObjectContainer)
		{
			_container = container;
		}

		public function get children():Array
		{
			for (var n:int = _container.numChildren, i:int = 0, all:Array = []; i < n; i++)
			{
				all[i] = _container.getChildAt(i);
			}
			return all;
		}

		public function getChildrenOfType(type:Class):Array
		{
			var all:Array = children, selected:Array = [];

			for (var i:int = 0, n:int = all.length; i < n; i++)
			{
				if (all[i] is type) selected.push(all[i]);
			}

			return selected;
		}

		/**
		 * Removes the children of a DisplayObject after attempting to call any disposal methods.
		 */
		public function removeChildren():void
		{
			var obj:DisplayObject;
			while (_container.numChildren > 0)
			{
				obj = _container.removeChildAt(0);

				// Test if disposable
				if (obj is Disposable) (obj as Disposable).dispose();

				// Test for the most common objec types. Note: using getQualifiedClassName to find out the type did not stop the MovieClip.
				if (obj is MovieClip) (obj as MovieClip).stop();
				else if (obj is Bitmap) (obj as Bitmap).bitmapData.dispose();
				else if (obj is Loader) (obj as Loader).unloadAndStop();
			}
		}
	}
}