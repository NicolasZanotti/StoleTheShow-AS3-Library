package
{
	import stoletheshow.mediators.CameraColorPickerMediator;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Nicolas Zanotti
	 */
	public class WebcamColorPickerMediatorTest extends Sprite
	{
		protected var mediator:CameraColorPickerMediator;
		public var videoContainer:Sprite;
		public var previewContainer:Sprite;
		public var btStart:SimpleButton;
		public var btStop:SimpleButton;

		public function WebcamColorPickerMediatorTest()
		{
			loaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}

		private function onComplete(event:Event):void
		{
			mediator = new CameraColorPickerMediator(videoContainer, previewContainer, btStart, btStop);
		}
	}
}