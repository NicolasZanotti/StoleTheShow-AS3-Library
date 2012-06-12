package stoletheshow.model
{
	/**
	 * Holds all links in an application
	 * 
	 * @author Nicolas Zanotti
	 */
	public class URLs
	{
		protected var _base:String = "";

		public function URLs(loaderInfo:Object = null)
		{
			// Attempt to extract the base URL from the loaderInfo object.
			if (loaderInfo != null && loaderInfo.hasOwnProperty("url") && loaderInfo.url.indexOf("file://") == -1)
			{
				_base = new RegExp("^(?:[^/]+://)?([^/:]+)").exec(loaderInfo.url)[0];
			}
		}

		public function get baseURL():String
		{
			return _base;
		}

		public function set baseURL(s:String):void
		{
			// Make sure there is no trailing slash in the domain string
			_base = s.substr(-1, 1) == "/" ? s.substr(0, s.length - 1) : s;
		}
	}
}