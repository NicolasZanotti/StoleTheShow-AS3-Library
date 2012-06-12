package stoletheshow.display.helpers
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;

	/**
	 * @author Nicolas Zanotti
	 * @version 20090423 Now supports text aligned on the right
	 */
	public class SimpleButtonHelper
	{
		public function SimpleButtonHelper()
		{
		}

		/**
		 * Align each SimpleButton to the TextField below. 
		 */
		public function alignButtonsToTexts(children:Array):void
		{
			for each (var i:DisplayObject in children)
			{
				if (i is SimpleButton)
				{
					for each (var j:DisplayObject in children)
					{
						if (j is TextField && i.hitTestObject(j))
						{
							i.width = (j as TextField).textWidth + 4;
							i.height = (j as TextField).textHeight + 4;
							i.y = j.y;
							switch ((j as TextField).getTextFormat().align)
							{
								case "right" :
									i.x = j.x + j.width - i.width;
									break;
								case "center" :
									i.x = j.x + ((j.width * 0.5) - (i.width * 0.5));
									break;
								default :
									i.x = j.x;
							}
							continue;
						}
					}
				}
			}
		}

		public function disableTabs(children:Array):void
		{
			for each (var i:DisplayObject in children) if (i is SimpleButton) (i as SimpleButton).tabEnabled = false;
		}
	}
}
