package stoletheshow.model
{
	import flash.display.BitmapData;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityPanel;

	import stoletheshow.control.Disposable;

	/**
	 * Checks for a users camera. Tested for the Web and AIR for Android.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class CameraFeed extends EventDispatcher implements Disposable
	{
		public static var CAMERA_AVAILABLE:String = "camera_available";
		public static var CAMERA_UNAVAILABLE:String = "camera_unavailable";
		protected var _camera:Camera;
		protected var _video:Video;
		protected var _hasChosenCamera:Boolean = false;
		protected var _bitmapData:BitmapData;

		public function CameraFeed()
		{
		}

		public function start(width:int, height:int, fps:int = 30, bandwidth:int = 0, quality:int = 100):void
		{
			_bitmapData = new BitmapData(width, height, false, 0xFFFFFF);
			
			if (!_hasChosenCamera && Camera.names.length > 1)
			{
				Security.showSettings(SecurityPanel.CAMERA);
				_hasChosenCamera = true;
			}

			_camera = Camera.getCamera();

			if (_camera && isEnabled)
			{
				_camera.setQuality(bandwidth, quality);
				_camera.setMode(width, height, fps, true);
				_video = new Video(width, height);
				_video.attachCamera(_camera);
				_camera.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity, false, 0, true);
				_camera.addEventListener(StatusEvent.STATUS, onCameraStatus, false, 0, true);
			}
			else
			{
				dispatchEvent(new Event(CAMERA_UNAVAILABLE));
			}
		}

		public function stop():void
		{
			_video.attachCamera(null);
		}

		public function dispose():void
		{
			_video.attachCamera(null);
			_video.clear();
			_video = null;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event handlers */
		/* ------------------------------------------------------------------------------- */
		protected function onCameraStatus(event:StatusEvent):void
		{
			_camera.removeEventListener(StatusEvent.STATUS, onCameraStatus, false);

			switch (event.code)
			{
				case "Camera.Muted":
					dispatchEvent(new Event(CAMERA_UNAVAILABLE));
					break;
				case "Camera.Unmuted":
					// User clicked Accept
					break;
			}
		}

		protected function onCameraActivity(event:ActivityEvent):void
		{
			if (event.activating)
			{
				_camera.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity, false);
				dispatchEvent(new Event(CAMERA_AVAILABLE));
			}
		}

		/* ------------------------------------------------------------------------------- */
		/*  Getters and setters */
		/* ------------------------------------------------------------------------------- */
		public function get camera():Camera
		{
			return _camera;
		}

		public function get video():Video
		{
			return _video;
		}

		public function get isEnabled():Boolean
		{
			return Camera.isSupported && !Capabilities.avHardwareDisable;
		}

		public function get bitmapData():BitmapData
		{
			_bitmapData.draw(video);
			return _bitmapData;
		}
	}
}