package stoletheshow.mediators
{
	import stoletheshow.control.Disposable;
	import stoletheshow.display.helpers.DisplayListHelper;
	import stoletheshow.model.CameraFeed;
	import stoletheshow.model.Color;
	import stoletheshow.model.Events;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Nicolas Zanotti
	 */
	public class CameraColorPickerMediator extends EventDispatcher implements Disposable
	{
		public static const COLOR_CHOSEN:String = "color_chosen";
		protected var _videoContainer:DisplayObjectContainer;
		protected var _startButton:DisplayObject;
		protected var _chooseButton:DisplayObject;
		protected var _colorValue:TextField;
		protected var feed:CameraFeed;
		protected var events:Events;
		protected var _color:Color;

		public function CameraColorPickerMediator(videoContainer:DisplayObjectContainer, startButton:DisplayObject, chooseButton:DisplayObject)
		{
			_videoContainer = videoContainer;
			_startButton = startButton;
			_chooseButton = chooseButton;
			init();
		}

		public function withColorValueDisplay(colorValue:TextField):CameraColorPickerMediator
		{
			_colorValue = colorValue;
			_color = new Color(0xFFFFFF);
			return this;
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
			events.add(_chooseButton, MouseEvent.CLICK, onStopClick);

			// Restore state
			state = States.idle;
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
			feed.start(1, 1, _videoContainer.stage.frameRate);

			new DisplayListHelper(_videoContainer).removeChildren();
			_videoContainer.addChild(feed.video);

			state = States.recording;

			trace('_colorValue: ' + (_colorValue.text));
			if (_colorValue != null) events.add(_colorValue, Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onStopClick(event:MouseEvent):void
		{
			feed.stop();

			if (_colorValue != null) events.remove(_colorValue, Event.ENTER_FRAME, onEnterFrame);

			state = States.idle;
		}

		protected function onEnterFrame(event:Event):void
		{
			_color.value = feed.bitmapData.getPixel(0, 0);
			_colorValue.text = _color.octal;
		}

		protected function onCameraAvailable(event:Event):void
		{
			trace("camera available");
		}

		protected function onCameraUnavailable(event:Event):void
		{
			trace("unavailable");
		}

		/* ------------------------------------------------------------------------------- */
		/*  Getters and setters */
		/* ------------------------------------------------------------------------------- */
		protected function set state(name:String):void
		{
			switch(name)
			{
				case States.idle:
					_chooseButton.visible = false;
					_startButton.visible = feed.isEnabled;
					break;
				case States.recording:
					_chooseButton.visible = true;
					_startButton.visible = false;
					break;
			}
		}

		public function get color():Color
		{
			return _color;
		}
	}
}
class States
{
	public static var recording:String = "recording";
	public static var idle:String = "idle";
}
