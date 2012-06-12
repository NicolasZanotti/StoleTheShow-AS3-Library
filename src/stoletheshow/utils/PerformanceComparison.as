package stoletheshow.utils 
{
	import flash.utils.getTimer;	

	/**
	 * @author Nicolas Zanotti, pimped by Elkana Aron, then pimped again by Nicolas Zanotti
	 */
	public class PerformanceComparison 
	{
		private var _iterations:int;
		private var _functions:Array;
		public var results:Array = [];

		public function PerformanceComparison(iterations:int,...functions:Array) 
		{
			_iterations = iterations;
			_functions = functions;
		}

		public function start():String 
		{
			var start:int = 0;
			var time:Number;
			var i:int = 0;
			var n:int;
			var f:Function;
			var s:String = "";
			var times:Array = [];
			var percentages:Array = [];
			var functionsLength:uint = _functions.length;
			
			for(n = 0;n < functionsLength; n++) 
			{
				start = getTimer();
				i = _iterations;
				f = _functions[n] as Function;
				while(i--) f();
				time = new Number(getTimer() - start);
				times[n] = time;
			}
			
			// check fastest time and set to 100%
			var fastestTime:Number = times[0];
			for each (time in times) if (time < fastestTime) fastestTime = time;
			
			// add up the percentages
			for each (time in times) percentages.push(Math.round(time * 100 / fastestTime - 100) || 0);
			
			// put together the results in a string
			for(n = 0;n < functionsLength; n++) 
			{
				s += "Test " + (n + 1) + "\t" + "time: " + times[n];
				if (percentages[n]) s += "\t" + percentages[n] + "% slower";
				s += "\n";
			}
			
			results.push(s);
			return s;
		}
	}
}