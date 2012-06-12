package stoletheshow.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * This class converts a MovieClip into a bitmap sequence. Optimal for decompressing Videos or complex vector animations.
	 * 
	 * Usage:
	 * <pre>
	 * 		var bitmapAnimation:BitmapAnimation = new BitmapAnimation();
	 *		bitmapAnimation.draw(movieClip);
	 *		addChild(bitmapAnimation);
	 * </pre>
	 * 
	 * @author Nicolas Zanotti
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @param Array containing BitmapData
	 */
	public class BitmapAnimation extends Sprite
	{
		protected var _bitmapDatas:Array, _filters:Array;
		protected var _index:int = -1, _bitmapDatasLength:int;
		protected var _isPlaying:Boolean = false;
		public var bitmap:Bitmap = new Bitmap();

		public function BitmapAnimation(bitmapDatas:Array = null)
		{
			if (bitmapDatas) 
			{
				_bitmapDatas = bitmapDatas;
				_bitmapDatasLength = bitmapDatas.length;
			}
			
			addChild(bitmap);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}

		private function onAddedToStage(event:Event):void
		{
			// like a MovieClip, play the sequence automatically.
			gotoAndPlay(1);
		}

		private function onRemovedFromStage(event:Event):void
		{
			stop();
		}

		private function onEnterFrame(event:Event = null):void
		{
			_index++;
			_index = _index % _bitmapDatasLength;
			// copypixels will decreas performance by ca. 5%			bitmap.bitmapData = _bitmapDatas[_index];
		}

		public function draw(mc:MovieClip, transparent:Boolean = false, fillColor:int = 0x000000):void 
		{
			_bitmapDatas = [];
			_bitmapDatasLength = mc.totalFrames;
			var bmpd:BitmapData;
			for (var i:int = 0;i < _bitmapDatasLength;i++) 
			{
				mc.gotoAndStop(i + 1);
				try 
				{
					// Flash may throw an error if it can't keep up.
					// If multiple BitmapAnimations use the same basis, pass the bitmap array in the constructor after processing the first.
					bmpd = new BitmapData(mc.width, mc.height, transparent, fillColor);
					bmpd.draw(mc);
				}
				catch (error:Error) 
				{
					//trace(error.message);
					return;
				}
				_bitmapDatas[i] = bmpd;
			}
		}

		public override function set filters(filters:Array):void 
		{
			_filters = filters;
			
			if (!_bitmapDatasLength) return;
			
			var filter:BitmapFilter;
			var bitmap:BitmapData;
			var sourceRect:Rectangle = new Rectangle(0, 0, (_bitmapDatas[0] as BitmapData).width, (_bitmapDatas[0] as BitmapData).height);
			var destPoint:Point = new Point(0, 0);
			
			for each (filter in filters) 
			{
				for each (bitmap in _bitmapDatas) 
				{
					try 
					{
						bitmap.applyFilter(bitmap, sourceRect, destPoint, filter);
					}
					catch(error:Error)
					{
						//trace(error.message);
					}
				}
			}
		}

		public override function get filters():Array 
		{
			return _filters;
		}
		
		public override function set cacheAsBitmap(value:Boolean):void 
		{
			// Enabling cacheAsBitmap will result in a huge performance hit.
		}
		
		public override function get cacheAsBitmap():Boolean 
		{
			return super.cacheAsBitmap;
		}

		public function get bitmapSequence():Array 
		{
			return _bitmapDatas;
		}

		public function gotoAndStop(frame:int):void 
		{
			if (_isPlaying) stop();
			bitmap.bitmapData = _bitmapDatas[frame - 1];
		}

		public function gotoAndPlay(frame:int):void 
		{
			if (_isPlaying) stop();
			// -1 for array, -1 because it gets added again onEnterframe
			_index = frame - 2;
			play();
		}

		public function nextFrame():void 
		{
			onEnterFrame();
		}

		public function prevFrame():void 
		{
			_index--;
			if (_index < 0) _index = _bitmapDatasLength -1;
			bitmap.bitmapData = _bitmapDatas[_index];
		}

		public function play():void 
		{
			if (!_bitmapDatasLength || _isPlaying) return;
			if (!bitmap.bitmapData) bitmap.bitmapData = _bitmapDatas[0];
			
			_isPlaying = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		public function stop():void 
		{
			if (!_isPlaying) return;
			_isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
		}
		
		public function dispose():void 
		{
			stop();
			removeChild(bitmap);
			bitmap = null;
			_bitmapDatas = null;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false);
		}
	}
}