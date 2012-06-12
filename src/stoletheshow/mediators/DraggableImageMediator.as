package stoletheshow.mediators
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import stoletheshow.control.Disposable;
	import stoletheshow.model.Events;


	/**
	 * @author Nicolas Zanotti
	 */
	public class DraggableImageMediator implements Disposable
	{
		public var bmp:Bitmap;
		protected var _events:Events = new Events();
		protected var _container:DisplayObjectContainer;
		protected var _cursor:MovieClip;
		protected var _source:BitmapData;
		protected var _st:State = new State();

		public function DraggableImageMediator(container:DisplayObjectContainer, source:BitmapData, size:Rectangle)
		{
			_container = container;

			// Create Bitmap
			bmp = new Bitmap(new BitmapData(size.width, size.height, false, 0xCDCDCD));
			container.addChild(bmp);
			_st.copyPixelsSource.width = bmp.width;
			_st.copyPixelsSource.height = bmp.height;

			// Configure listeners
			_events.add(container, MouseEvent.MOUSE_MOVE, onContainerMouseMove);
			_events.add(container, MouseEvent.MOUSE_OUT, onContainerMouseOut);
			_events.add(container, MouseEvent.MOUSE_DOWN, onContainerMouseDown);
			_events.add(container, MouseEvent.MOUSE_OVER, onContainerMouseOver);
			_events.add(container, MouseEvent.MOUSE_UP, onContainerMouseUp);
			_events.add(container, Event.ENTER_FRAME, onContainerEnterFrame);
			
			this.source = source;
		}

		public function withCursor(movieClipWithTwoFrames:MovieClip):DraggableImageMediator
		{
			_st.useCursor = true;

			_cursor = movieClipWithTwoFrames;
			_cursor.gotoAndStop(1);
			_cursor.mouseEnabled = false;
			_cursor.mouseChildren = false;
			_cursor.visible = false;

			return this;
		}

		// ---------------------------------------------------------------------
		// Event Handlers
		// ---------------------------------------------------------------------
		protected function onContainerEnterFrame(event:Event):void
		{
			event.stopPropagation();

			if (_st.mouseIsDown)
			{
				// Check the X-Axis
				if (_container.mouseX > _st.previousMousePosition.x)
				{
					_st.copyPixelsSource.x -= (_container.mouseX - _st.previousMousePosition.x);
				}
				else if (_container.mouseX < _st.previousMousePosition.x)
				{
					_st.copyPixelsSource.x += (_st.previousMousePosition.x - _container.mouseX);
				}

				if (_container.mouseY > _st.previousMousePosition.y)
				{
					_st.copyPixelsSource.y -= (_container.mouseY - _st.previousMousePosition.y);
				}
				else if (_container.mouseY < _st.previousMousePosition.y)
				{
					_st.copyPixelsSource.y += (_st.previousMousePosition.y - _container.mouseY);
				}

				// Update the state
				_st.previousMousePosition.x = _container.mouseX;
				_st.previousMousePosition.y = _container.mouseY;

				// Check if copyPixelsSource is within the boundries of the original bitmap
				if (_st.copyPixelsSource.x < 0)
				{
					_st.copyPixelsSource.x = 0;
				}
				else if (_st.copyPixelsSource.x > _st.maxX)
				{
					_st.copyPixelsSource.x = _st.maxX;
				}

				if (_st.copyPixelsSource.y < 0)
				{
					_st.copyPixelsSource.y = 0;
				}
				else if (_st.copyPixelsSource.y > _st.maxY)
				{
					_st.copyPixelsSource.y = _st.maxY;
				}

				draw();
			}
		}

		protected function onContainerMouseOut(event:MouseEvent):void
		{
			event.stopPropagation();

			if (_st.useCursor)
			{
				_cursor.gotoAndStop(1);
				_cursor.visible = false;
				Mouse.show();
			}
			_st.mouseIsDown = false;
		}

		protected function onContainerMouseOver(event:MouseEvent):void
		{
			event.stopPropagation();
			if (_st.useCursor)
			{
				_cursor.visible = true;
				Mouse.hide();
			}
		}

		protected function onContainerMouseMove(event:MouseEvent):void
		{
			event.stopPropagation();

			if (_st.useCursor)
			{
				_cursor.x = _container.stage.mouseX;
				_cursor.y = _container.stage.mouseY;
			}
			event.updateAfterEvent();
		}

		protected function onContainerMouseDown(event:MouseEvent):void
		{
			event.stopPropagation();
			_st.mouseIsDown = true;
			_st.previousMousePosition.x = _container.mouseX;
			_st.previousMousePosition.y = _container.mouseY;

			if (_st.useCursor) _cursor.gotoAndStop(2);
		}

		protected function onContainerMouseUp(event:MouseEvent):void
		{
			event.stopPropagation();
			if (_st.useCursor) _cursor.gotoAndStop(1);
			_st.mouseIsDown = false;
		}

		// ---------------------------------------------------------------------
		// Image drawing methods
		// ---------------------------------------------------------------------
		public function draw():void
		{
			bmp.bitmapData.lock();
			bmp.bitmapData.copyPixels(_source, _st.copyPixelsSource, _st.copyPixelsDestination);
			bmp.bitmapData.unlock();
		}

		public function center():void
		{
			_st.copyPixelsSource.x = -((bmp.width - source.width) / 2);
			_st.copyPixelsSource.y = -((bmp.height - source.height) / 2);
		}

		public function clear():void
		{
			bmp.bitmapData.lock();
			bmp.bitmapData.fillRect(new Rectangle(0, 0, bmp.width, bmp.height), 0xFFFFFFFF);
			bmp.bitmapData.unlock();
		}

		// ---------------------------------------------------------------------
		// Controller Classes
		// ---------------------------------------------------------------------
		public function dispose():void
		{
			_events.removeAll();

			bmp.bitmapData.dispose();

			bmp = null;
			_container = null;
			_st = null;
		}

		// ---------------------------------------------------------------------
		// Getters and Setters
		// ---------------------------------------------------------------------
		public function get source():BitmapData
		{
			return _source;
		}

		public function set source(source:BitmapData):void
		{
			_source = source;

			// Reset state
			_st.maxX = _source.width - bmp.width;
			_st.maxY = _source.height - bmp.height;

			if (dragAllowed)
			{
				Mouse.hide();
				_events.paused = false;
				if (_cursor != null) _cursor.visible = true;
			}
			else
			{
				Mouse.show();
				_events.paused = true;
				if (_cursor != null) _cursor.visible = false;
			}

			clear();
			center();
			draw();
		}

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function get cursor():MovieClip
		{
			return _cursor;
		}

		public function get dragAllowed():Boolean
		{
			return source != null && bmp != null && (source.width > bmp.width) && (source.height > bmp.height);
		}
	}
}
import flash.geom.Point;
import flash.geom.Rectangle;

internal class State
{
	public var previouseSource:Rectangle = new Rectangle();
	public var wasTooSmall:Boolean = false;
	public var copyPixelsDestination:Point = new Point();
	public var copyPixelsSource:Rectangle = new Rectangle();
	public var mouseIsDown:Boolean = false;
	public var previousMousePosition:Point = new Point();
	public var distanceFromClick:Point = new Point();
	public var maxX:int = -1;
	public var maxY:int = -1;
	public var useCursor:Boolean = false;
}
