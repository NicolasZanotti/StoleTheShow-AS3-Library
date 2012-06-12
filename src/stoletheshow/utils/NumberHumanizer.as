package stoletheshow.utils
{
	/**
	 * @author Patrick Lauber, ported to AS3 by Nicolas Zanotti
	 */
	public class NumberHumanizer
	{
		public function NumberHumanizer()
		{
		}

		/**
		 * Converts 100000 to 100'000.
		 */
		public function chunkDecimals(n:Number):String
		{
			var s:String = "";
			var subK:Number;
			var tnum:Number = n;

			while (tnum / 1000 > 1)
			{
				subK = tnum - (1000 * Math.floor(tnum / 1000));
				s = "'" + addLeadingZeros(subK, 3) + s;
				tnum = Math.floor(tnum / 1000);
			}

			s = (tnum != 0) ? tnum + s : String(tnum);

			return s;
		}
		
		/**
		 * Converts 21312 to 00021312.
		 */
		public function addLeadingZeros(n:Number, totalDigits:Number):String
		{
			var s:String = "";
			for (var i:Number = 0;i < totalDigits;i++) s += "0";
			var sn:String = String(n);
			var fs:String = s.substr(0, s.length - sn.length) + sn;
			return fs;
		}
		
		
		/**
		 * Converts 1.2 to 00:01.
		 */
		public function secondsToTime(sec:Number):String
		{
			var h:Number = Math.floor(sec / 3600);
			var m:Number = Math.floor((sec % 3600) / 60);
			var s:Number = Math.floor((sec % 3600) % 60);
			return(h == 0 ? "" : (h < 10 ? "0" + h.toString() + ":" : h.toString() + ":")) + (m < 10 ? "0" + m.toString() : m.toString()) + ":" + (s < 10 ? "0" + s.toString() : s.toString());
		}
	}
}