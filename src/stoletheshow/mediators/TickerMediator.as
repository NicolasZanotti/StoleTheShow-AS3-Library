package stoletheshow.mediators {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Nicolas Zanotti
	 * @version 20090326
	 */
	public class TickerMediator 
	{
		private var _viewableWidth:Number;
		private var _delimiter:String;
		private var _texts:Array;
		private var _twin:TextField;
		private var _container:DisplayObjectContainer;
		private var _textField:TextField;
		public var pixelsPerFrame:Number = 1;

		public function TickerMediator(container:DisplayObjectContainer, textField:TextField, delimiter:String, ...texts) 
		{
			_container = container;
			_textField = textField;
			_delimiter = delimiter;
			_texts = texts;
			
			build();
		}

		private function build():void 
		{
			_viewableWidth = _container.width;

			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = _textField.wordWrap = false;
			_textField.x = 1;
			
			updateText(_texts);
			
			// duplicate the textfield;
			_twin = new TextField();
			_twin.width = _textField.width;
			_twin.selectable = _textField.selectable;
			_twin.text = _textField.text;
			_twin.setTextFormat(_textField.getTextFormat());
			_twin.embedFonts = _textField.embedFonts;
			_twin.x = _twin.width;
			
			
			// optimize for animation
			_textField.antiAliasType = _twin.antiAliasType = AntiAliasType.ADVANCED;
			_textField.cacheAsBitmap = _twin.cacheAsBitmap = true;
			
			_container.addChild(_twin);
		}

		private function onEnterFrame(event:Event):void 
		{
			// repetative animation
			if (_textField.x <= -_textField.width) 
			{
				_twin.x -= pixelsPerFrame;
				_textField.x = _twin.width + (_textField.x + _textField.width) - pixelsPerFrame;
			}
			else if (_twin.x <= -_twin.width) 
			{
				_textField.x -= pixelsPerFrame;
				_twin.x = _textField.width + (_twin.x + _twin.width) - pixelsPerFrame;
			} 
			else 
			{
				_textField.x -= pixelsPerFrame;
				_twin.x -= pixelsPerFrame;
			}
			
			/* old version wasn't exact
			_textField.x -= pixelsPerFrame;
			_twin.x -= pixelsPerFrame;
			
			if (!_textFieldUpdated && _twin.x <= 0) {
				_textFieldUpdated = true;
				_twinUpdated = false;
				_textField.x = _twin.width;
			}
			
			if (!_twinUpdated && _textField.x <= 0) {
				_twinUpdated = true;
				_textFieldUpdated = false;
				_twin.x = _textField.width;
			}
			*/
		}

		public function updateText(texts:Array):void 
		{
			_textField.text = "";
			for each (var s:String in texts) _textField.appendText(s + _delimiter);
			if (_twin != null) _twin.text = _textField.text;
		}

		public function start():void 
		{
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		public function stop():void 
		{
			_container.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
		}
	}
}