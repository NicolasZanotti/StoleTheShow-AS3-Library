package
{
	import stoletheshow.loaders.Bootstrapper;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Nicolas Zanotti
	 */
	public class BootstrapperTest extends MovieClip
	{
		public var bootstrapper:Bootstrapper;
		public var loaderAnimation:MovieClip;
		public var errorMessageFPVersion:Sprite;

		public function BootstrapperTest()
		{
			bootstrapper = new Bootstrapper(this).withPlayerVerionError(10.2, errorMessageFPVersion).withLoaderAnimation(loaderAnimation).withLoaderPercentageText(loaderAnimation.tfPercent);

			bootstrapper.addEventListener(Bootstrapper.CLASSES_FRAME_COMPLETE, onClassesFrameComplete);
			bootstrapper.addEventListener(Bootstrapper.EXTERNAL_COMPLETE, onExternalComplete);
			bootstrapper.addEventListener(Bootstrapper.DESTINATION_FRAME_COMPLETE, onDestinationFrameComplete);
			bootstrapper.addEventListener(Bootstrapper.TOTALFRAMES_COMPLETE, onTotalFramesComplete);

			bootstrapper.init();
		}

		private function onClassesFrameComplete(event:Event):void
		{
			trace("onClassesFrameComplete: Initialize model objects here.");
		}

		private function onExternalComplete(event:Event):void
		{
			trace("onExternalComplete: Initialize external resources here.");
		}
		
		private function onDestinationFrameComplete(event:Event):void
		{
			trace("onDestinationFrameComplete: Home screen is placed here.");
		}

		private function onTotalFramesComplete(event:Event):void
		{
			trace("onTotalFramesComplete: Bootstrapper is done.");
			bootstrapper.dispose();
			bootstrapper = null;
		}

		public function set state(name:String):void
		{
			trace('Changing state to: ' + (name));
			gotoAndStop(name);
		}

		public function get state():String
		{
			return currentFrameLabel;
		}
	}
}
