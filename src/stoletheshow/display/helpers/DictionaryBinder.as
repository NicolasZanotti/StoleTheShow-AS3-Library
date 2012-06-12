package stoletheshow.display.helpers
{
	import avmplus.getQualifiedClassName;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import stoletheshow.collections.StringCollectable;
	import stoletheshow.display.Textdisplayable;



	/**
	 * Applies dictionairy values to display objects based on the key and the instance name.
	 * 
	 * @usage <code>
	 * 		var tf = addChild(new TextField());
	 *		tf.name = "foo";
	 *		
	 *		new DictionaryBinder({"foo": "Bar"}).bindChildrenOf(this);
	 * </code>
	 * 
	 * Currently works with the following types:
	 * 		• TextField and TLFTextField
	 * 		• SimpleButton (including states)
	 * 		• TextDisplayable
	 * 		• Label
	 * 		• Button
	 * 		• TextArea
	 * 		• TextInput
	 * 		• RadioButton
	 * 		• CheckBox
	 * 
	 * @author Nicolas Zanotti
	 */
	public class DictionaryBinder
	{
		protected var _dict:Object;

		public function DictionaryBinder(dict:Object)
		{
			_dict = dict;
		}

		public function bindChildrenOf(container:DisplayObjectContainer):void
		{
			var children:Array = new DisplayListHelper(container).children;

			for each (var obj:Object in children)
			{
				if (_dict.hasOwnProperty(obj.name)) applyByType(obj) || applyByClassName(obj);
			}
		}

		protected function applyByType(obj:Object):Boolean
		{
			if (obj is TextField || obj is Textdisplayable)
			{
				obj.text = getEntry(obj.name);
				return true;
			}

			if (obj is SimpleButton)
			{
				applyTextToSimpleButton(obj as SimpleButton, getEntry(obj.name));
				return true;
			}

			return false;
		}

		protected function applyByClassName(obj:Object):Boolean
		{
			var name:String = getQualifiedClassName(obj);

			if (name.indexOf("Text") != -1 || name.indexOf("Label") != -1)
			{
				obj.text = getEntry(obj.name);
				return true;
			}

			if (name.indexOf("Button") != -1 || name.indexOf("CheckBox") != -1)
			{
				obj.label = getEntry(obj.name);
				return true;
			}

			return false;
		}

		protected function applyTextToSimpleButton(button:SimpleButton, text:String):void
		{
			if (button.upState is TextField) (button.upState as TextField).text = text;
			if (button.overState is TextField) (button.overState as TextField).text = text;
			if (button.downState is TextField) (button.downState as TextField).text = text;
			if (button.hitTestState is TextField) (button.hitTestState as TextField).text = text;
		}

		protected function getEntry(key:String):String
		{
			return _dict is StringCollectable ? _dict.getEntry(key) : _dict[key];
		}
	}
}
