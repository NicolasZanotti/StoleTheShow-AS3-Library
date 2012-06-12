package stoletheshow.model
{
	import flash.geom.ColorTransform;

	/**
	 * @author Nicolas Zanotti
	 * 
	 * Refactored from the RGB Class by Nicholas Dunbar
	 * @see http://www.actionscript-flash-guru.com/blog/36-uint-to-6-digit-rgb-hex--actionscript-30-as3
	 */
	public class Color
	{
		protected var _colorTransform:ColorTransform;

		public function Color(hex:*)
		{
			_colorTransform = new ColorTransform();
			value = hex;
		}

		/**
		 * @return the hex/oct value of the RGB object as uint 
		 */
		public function get value():uint
		{
			return _colorTransform.color;
		}

		public function set value(hex:*):void
		{
			_colorTransform.color = hex;
		}

		/**
		 * @return a 6 character string representing the RGB
		 * 
		 */
		public function get hexadecimal():String
		{
			var hexStr:String = convertChannelToHexStr(_colorTransform.redOffset) + convertChannelToHexStr(_colorTransform.greenOffset) + convertChannelToHexStr(_colorTransform.blueOffset);
			var n:uint = hexStr.length;

			if (n < 6)
			{
				for (var j:uint; j < (6 - n); j++)
				{
					hexStr += "0";
				}
			}

			return hexStr;
		}

		/**
		 * @return the octal value of the RGB object as a string
		 */
		public function get octal():String
		{
			return "0x" + hexadecimal;
		}

		/**
		 * converts the uint chanel representation of a color to a hex string 
		 * @param hex
		 * @return the string representation of the hex, this does not return the RGB format of a hex like 00ff00 use uintToRGBHex getting a string that is always 6  characters long
		 */
		protected function convertChannelToHexStr(hex:uint):String
		{
			if (hex > 255) throw new Error("Hex overload");

			var hexStr:String = hex.toString(16);

			if (hexStr.length < 2) hexStr = "0" + hexStr;

			return hexStr;
		}

		public function get colorTransform():ColorTransform
		{
			return _colorTransform;
		}
	}
}
