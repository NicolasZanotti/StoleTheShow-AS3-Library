package stoletheshow.display 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * This class spreads out the creation of a bitmap animation over a predefined period of time.
	 * 
	 * Usage:
	 * <pre>
	 * 		var bitmapAnimation:DelayedBitmapAnimation = new DelayedBitmapAnimation();
	 * 		bitmapAnimation.pauseBetweenIterations = 20;
	 *		bitmapAnimation.draw(movieClip);
	 *		addChild(bitmapAnimation);
	 * </pre>
	 * 
	 * TODO Use ActionScript Workers when it becomes available for Flash Player "Dolores".
	 * @see http://www.adobe.com/devnet/flashplatform/whitepapers/roadmap.html
	 * 
	 * @author Nicolas Zanotti
	 * @see BitmapAnimation
	 */
	public class DelayedBitmapAnimation extends BitmapAnimation 
	{
		/**
		 * The amount of time in milliseconds to wait before processing the next bitmap.
		 */
		public var pauseBetweenIterations:int = 10;
		private var _timer:Timer;
		private	var _bmpd:BitmapData;
		private var _source:MovieClip;
		private var _transparent:Boolean;
		private var _fillColor:int;

		public function DelayedBitmapAnimation()
		{
			super(null);
		}

		override public function draw(mc:MovieClip, transparent:Boolean = false, fillColor:int = 0x000000):void 
		{
			_bitmapDatas = [];
			_source = mc;
			_bitmapDatasLength = _source.totalFrames;
			_transparent = transparent;
			_fillColor = fillColor;
			
			_timer = new Timer(pauseBetweenIterations);
			_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			_timer.start();
		}

		private function onTimer(event:TimerEvent):void
		{
			// This is a similar operation to the parent classes parse method.
			_source.gotoAndStop(_timer.currentCount);
			try 
			{
				_bmpd = new BitmapData(_source.width, _source.height, _transparent, _fillColor);
				_bmpd.draw(_source);
			}
			catch (error:Error) 
			{
				//trace(error.message);
				return;
			}
			_bitmapDatas[_timer.currentCount - 1] = _bmpd;
			
			if (_timer.currentCount - 1 == _bitmapDatasLength) 
			{
				// clean up and stop the loop
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer, false);
				_timer = null;
				_bmpd.dispose();
				_bmpd = null;
				_source = null;
				_fillColor = 0;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}
