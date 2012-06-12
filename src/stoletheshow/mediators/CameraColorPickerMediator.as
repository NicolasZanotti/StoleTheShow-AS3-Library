package stoletheshow.mediators
{
	import stoletheshow.control.Disposable;
	import stoletheshow.display.helpers.DisplayListHelper;
	import stoletheshow.model.CameraFeed;
	import stoletheshow.model.Events;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;


	/**
	 * @author Nicolas Zanotti
	 */
	public class CameraColorPickerMediator extends EventDispatcher implements Disposable
	{
		private var _videoContainer:DisplayObjectContainer;
		private var _previewContainer:DisplayObjectContainer;
		private var _startButton:DisplayObject;
		private var _stopButton:DisplayObject;
		protected var feed:CameraFeed;
		protected var events:Events;

		public function CameraColorPickerMediator(videoContainer:DisplayObjectContainer, previewContainer:Sprite, startButton:DisplayObject, stopButton:DisplayObject)
		{
			_videoContainer = videoContainer;
			_previewContainer = previewContainer;
			_startButton = startButton;
			_stopButton = stopButton;
			init();
		}

		/* ------------------------------------------------------------------------------- */
		/*  Controller methods */
		/* ------------------------------------------------------------------------------- */
		protected function init():void
		{
			// Configure components
			feed = new CameraFeed();
			feed.addEventListener(CameraFeed.CAMERA_AVAILABLE, onCameraAvailable);
			feed.addEventListener(CameraFeed.CAMERA_UNAVAILABLE, onCameraUnavailable);
			

			// Configure listeners
			events = new Events();
			events.add(_startButton, MouseEvent.CLICK, onStartClick);
			events.add(_stopButton, MouseEvent.CLICK, onStopClick);

			// Restore state
			_videoContainer.visible = false;
			_startButton.visible = _stopButton.visible = feed.isEnabled;
		}

		public function dispose():void
		{
			feed.dispose();
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event listeners */
		/* ------------------------------------------------------------------------------- */
		protected function onStartClick(event:MouseEvent):void
		{
			feed.start(20, 20, _videoContainer.stage.frameRate);
			events.add(this, Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onStopClick(event:MouseEvent):void
		{
			feed.stop();
		}
		
		protected function onEnterFrame(event:Event):void {
		
		}

		protected function onCameraAvailable(event:Event):void
		{
			new DisplayListHelper(_videoContainer).removeChildren();
			
			_videoContainer.addChild(feed.video);
			trace(_videoContainer.numChildren);
			_videoContainer.visible = true;
		}

		protected function onCameraUnavailable(event:Event):void
		{
			trace("unavailable");
		}
	}
}
