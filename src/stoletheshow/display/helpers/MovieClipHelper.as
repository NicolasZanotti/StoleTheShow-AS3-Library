package stoletheshow.display.helpers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * @author Nicolas Zanotti
	 */
	public class MovieClipHelper extends DisplayListHelper
	{
		public function MovieClipHelper(clip:MovieClip)
		{
			super(clip as DisplayObjectContainer);
		}

		public function getFrameByName(frameName:String):int
		{
			for each (var fl:FrameLabel in (_container as MovieClip).currentLabels)
			{
				if (fl.name == frameName) return fl.frame;
			}
			return 1;
		}
	}
}