package stoletheshow.mediators
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import stoletheshow.control.Disposable;
	import stoletheshow.model.CameraFeed;


	/**
	 * Takes a picture after a countdown, similar to Apple's Photo Booth.
	 * 
	 * FIXME Halt the camera stream when not in use.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class CameraSnapshotMediator extends EventDispatcher implements Disposable
	{
		public static const SNAPSHOT_COMPLETE:String = "snapshot_complete";
		public var feed:CameraFeed;
		protected var _isStreamingWebcam:Boolean;
		protected var _countdownTakePictureEventName:String;
		protected var _countdownAnimationCompleteEventName:String;
		protected var _videoContainer:DisplayObjectContainer;
		protected var _countdownAnimation:MovieClip;
		protected var _startButton:DisplayObject;

		public function CameraSnapshotMediator(startButton:DisplayObject, videoContainer:DisplayObjectContainer, countdownAnimation:MovieClip, countdownTakePictureEventName:String, countdownAnimationCompleteEventName:String)
		{
			_startButton = startButton;
			_videoContainer = videoContainer;
			_countdownAnimation = countdownAnimation;
			_countdownAnimationCompleteEventName = countdownAnimationCompleteEventName;
			_countdownTakePictureEventName = countdownTakePictureEventName;
			init();
		}

		protected function init():void
		{
			// Add Listeners
			_startButton.addEventListener(MouseEvent.CLICK, onStartSnapshot, false, 0, true);
			_countdownAnimation.addEventListener(_countdownTakePictureEventName, onSnapshot, false, 0, true);
			_countdownAnimation.addEventListener(_countdownAnimationCompleteEventName, onSnapShotAnimationComplete, false, 0, true);

			// Configure Compontents
			_countdownAnimation.buttonMode = _countdownAnimation.mouseChildren = _countdownAnimation.mouseEnabled = false;

			feed = new CameraFeed();
			feed.addEventListener(CameraFeed.CAMERA_AVAILABLE, onCameraAvailable);
			feed.addEventListener(CameraFeed.CAMERA_UNAVAILABLE, onCameraUnavailable);
			feed.start(_videoContainer.width, _videoContainer.height, _videoContainer.stage.frameRate);

			// Restore State
			toggleSnapShot(false);
		}

		protected function onStartSnapshot(event:MouseEvent):void
		{
			startCamera();
			toggleSnapShot(false);
			_countdownAnimation.gotoAndPlay(2);
		}

		protected function onCameraAvailable(event:Event):void
		{
			startCamera();
		}

		protected function onCameraUnavailable(event:Event):void
		{
			_videoContainer.visible = false;
		}

		protected function startCamera():void
		{
			if (_isStreamingWebcam) return;

			_videoContainer.addChild(feed.video);
			_videoContainer.visible = true;
			_isStreamingWebcam = true;

			toggleSnapShot(true);
		}

		/**
		 * At this point the camera has made a picture
		 */
		protected function onSnapshot(event:Event = null):void
		{
			try
			{
				var bmpd:BitmapData = new BitmapData(feed.video.width, feed.video.height);
				bmpd.draw(feed.video);
			}
			catch (error:Error)
			{
				trace(error.message);
				return;
			}

			// clean up previous
			while (_videoContainer.numChildren > 0) _videoContainer.removeChildAt(0);

			// add the new image
			_videoContainer.addChild(new Bitmap(bmpd));
			_isStreamingWebcam = false;

			dispatchEvent(new Event(SNAPSHOT_COMPLETE));
		}

		protected function onSnapShotAnimationComplete(event:Event):void
		{
			_countdownAnimation.gotoAndStop(1);
			toggleSnapShot(true);
		}

		protected function toggleSnapShot(show:Boolean):void
		{
			_startButton.visible = show;
		}

		public function dispose():void
		{
			// Remove Listeners
			_startButton.removeEventListener(MouseEvent.CLICK, onStartSnapshot, false);
			_countdownAnimation.removeEventListener(_countdownTakePictureEventName, onSnapshot, false);
			_countdownAnimation.removeEventListener(_countdownAnimationCompleteEventName, onSnapShotAnimationComplete, false);

			_videoContainer.removeChild(feed.video);
			feed.dispose();
		}

		public function get bitmapData():BitmapData
		{
			if (_videoContainer.getChildAt(0) != null) return (_videoContainer.getChildAt(0) as Bitmap).bitmapData;
			return null;
		}
	}
}