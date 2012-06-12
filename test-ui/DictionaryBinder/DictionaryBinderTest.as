package
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.text.TLFTextField;

	import stoletheshow.display.helpers.DictionaryBinder;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;




	/**
	 * @author Nicolas Zanotti
	 */
	public class DictionaryBinderTest extends Sprite
	{
		public var title:TLFTextField;
		public var author:SimpleButton;
		public var intro:TextArea;
		public var preview:TextField;
		public var unknown:TextField;
		public var light:Widget;
		public var search:TextField;
		public var age:TextInput;
		public var enter:RadioButton;
		public var gender:CheckBox;
		public var send:Button;
		protected var en:Dictionary;
		protected var de:Dictionary;

		public function DictionaryBinderTest()
		{
			en = new Dictionary();
			en.title = "The Last Question";
			en.author = "by Isaac Asimov";
			en.intro = "The last question was asked for the first time, half in jest, on May 21, 2061";
			en.preview = "Alexander Adell and Bertram Lupov were two of the faithful attendants of Multivac.";
			en.light = "Let there be light";
			en.search = "Search…";
			en.age = "Age…";
			en.enter = "Please enter";
			en.gender = "Gender";
			en.send = "Send";

			de = new Dictionary();
			de.title = "Die letzte Frage";
			de.author = "von Isaac Asimov";
			de.intro = "Die letzte Frage wurde, halb im Scherz, zum ersten mal am 21 Mai 2061 gefragt";
			de.preview = "Alexander Adell und Bertram Lupov waren zwei treue Bediener des Multivac.";
			de.light = "Und es werde Licht";
			de.search = "Suchen…";
			de.age = "Alter…";
			de.enter = "Bitte eingeben";
			de.gender = "Geschlecht";
			de.send = "Senden";

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			trace("Press 1 for english, 2 for german");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}

		private function onKeyboardDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.NUMBER_1)
			{
				new DictionaryBinder(en).bindChildrenOf(this);
			}
			else if (event.keyCode == Keyboard.NUMBER_2)
			{
				new DictionaryBinder(de).bindChildrenOf(this);
			}
		}
	}
}