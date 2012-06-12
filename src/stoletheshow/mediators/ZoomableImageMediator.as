package stoletheshow.mediators
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	/**
	 * @author Nicolas Zanotti
	 */
	public class ZoomableImageMediator extends DraggableImageMediator
	{
		public var interpolatePositionOnSourceChange:Boolean;

		public function ZoomableImageMediator(container:DisplayObjectContainer, source:BitmapData, size:Rectangle, keepPositionOnSourceChange:Boolean = false)
		{
			this.interpolatePositionOnSourceChange = keepPositionOnSourceChange;
			super(container, source, size);
		}

		override public function set source(source:BitmapData):void
		{
			if (interpolatePositionOnSourceChange && _source != null)
			{
				_st.previouseSource.width = _source.width;
				_st.previouseSource.height = _source.height;
			}

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
			interpolatePositionOnSourceChange ? interpolatePosition() : center();
			draw();
			
			_st.wasTooSmall = !dragAllowed;
		}

		public function interpolatePosition():void
		{
			if (!dragAllowed || _st.wasTooSmall || _st.previouseSource.width == 0 || _st.previouseSource.height == 0)
			{
				center();
				return;
			}

			// @see http://en.wikipedia.org/wiki/Rule_of_three_(mathematics)#Rule_of_Three
			var a:uint, b:uint, c:uint;

			a = _st.previouseSource.width;
			b = _st.copyPixelsSource.x;
			c = _source.width;
			_st.copyPixelsSource.x = c * b / a;

			a = _st.previouseSource.height;
			b = _st.copyPixelsSource.y;
			c = _source.height;
			_st.copyPixelsSource.y = c * b / a;

			// Reset the state
			_st.previouseSource = new Rectangle();
			_st.wasTooSmall = false;
		}
	}
}
