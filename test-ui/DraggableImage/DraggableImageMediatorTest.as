package
{
	import stoletheshow.display.helpers.BitmapHelper;
	import stoletheshow.control.Controllable;
	import stoletheshow.control.Controller;
	import stoletheshow.mediators.ZoomableImageMediator;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author Nicolas Zanotti
	 */
	public class DraggableImageMediatorTest extends Sprite implements Controllable
	{
		public var ct:Controller;
		public var handcursor:MovieClip;
		public var container:Sprite;
		public var mediator:ZoomableImageMediator;
		private var _zoom:int = 0;

		public function DraggableImageMediatorTest()
		{
			ct = new Controller(this);
		}

		private function onStageKeyDown(event:KeyboardEvent):void
		{
			var previousZoomLevel:int = _zoom;

			if (event.keyCode == Keyboard.NUMBER_1 && _zoom < 4) _zoom++;
			else if (event.keyCode == Keyboard.NUMBER_2 && _zoom > -4) _zoom--;

			if (_zoom != previousZoomLevel) mediator.source = getSource(_zoom);
		}

		private function getSource(zoomLevel:int):BitmapData
		{
			var source:BitmapData = new BitmapHelper().getAssetAsBitmap("TestPattern").bitmapData;

			switch (zoomLevel)
			{
				case -4 :
					return new BitmapHelper().scale(.2, source);
				case -3 :
					return new BitmapHelper().scale(.25, source);
				case -2 :
					return new BitmapHelper().scale(.5, source);
				case -1 :
					return new BitmapHelper().scale(.75, source);
				case 1 :
					return new BitmapHelper().scale(1.25, source);
				case 2 :
					return new BitmapHelper().scale(1.5, source);
				case 3 :
					return new BitmapHelper().scale(1.75, source);
				case 4 :
					return new BitmapHelper().scale(2, source);
			}

			return source;
		}

		public function init():void
		{
			// Configure components
			var source:BitmapData = getSource(0);
			var size:Rectangle = new Rectangle(0, 0, 640, 480);

			mediator = new ZoomableImageMediator(container, source, size, true).withCursor(handcursor) as ZoomableImageMediator;

			// Configure listeners
			trace("Use key 1 to zoom in, key to 2 to zoom out");
			ct.events.add(stage, KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}

		public function dispose():void
		{
		}
	}
}