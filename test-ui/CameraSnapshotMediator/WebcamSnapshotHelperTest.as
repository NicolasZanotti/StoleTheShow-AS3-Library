package  
{
	import stoletheshow.mediators.CameraSnapshotMediator;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Nicolas Zanotti
	 */
	public class WebcamSnapshotHelperTest extends Sprite 
	{
		protected var mediator:CameraSnapshotMediator;
		public var emptyBtStartSnapshot:SimpleButton;
		public var videoHolder:MovieClip;
		public var countdown:MovieClip;

		public function WebcamSnapshotHelperTest()
		{
			mediator = new CameraSnapshotMediator(emptyBtStartSnapshot, videoHolder, countdown, "takePicture", "animationComplete");
			mediator.addEventListener(CameraSnapshotMediator.SNAPSHOT_COMPLETE, onSnapShotComplete);
		}

		private function onSnapShotComplete(e:Event):void 
		{
			trace("Snapshot complete");
		}
	}
}