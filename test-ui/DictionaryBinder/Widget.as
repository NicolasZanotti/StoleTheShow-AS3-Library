package
{
	import flash.text.TextField;

	import stoletheshow.display.Textdisplayable;

	import flash.display.Sprite;

	/**
	 * @author Nicolas Zanotti
	 */
	public class Widget extends Sprite implements Textdisplayable
	{
		public var tf:TextField;

		public function Widget()
		{
		}

		public function set text(s:String):void
		{
			tf.text = s;
		}

		public function get text():String
		{
			return tf.text;
		}
	}
}
