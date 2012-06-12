package stoletheshow.mediators
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import stoletheshow.control.Disposable;


	/**
	 * @author  Elkana Aron
	 * Because nobody else wants to write scroll classes in 2009.
	 * 
	 * @version 20090113 (Nicolas Zanotti) Added show and hide event dispatching and update function.
	 * @version 20090508 (Nicolas Zanotti) Added up and down arrows and mousewheel
	 */
	public class ScrollMediator extends EventDispatcher implements Disposable
	{
		public static const SHOW:String = "show";
		public static const HIDE:String = "hide";
		private var _scrollBarMinimumY:Number, _scrollBarMaximumY:Number;
		private var _bar:Sprite, _upArrow:Sprite, _downArrow:Sprite, _trough:Sprite;
		private var _content:DisplayObject;
		private var _mask:DisplayObject;
		private var _enableScroll:Boolean = true, _autoHide:Boolean = true, _scrollingUp:Boolean = true;

		public function ScrollMediator(bar:Sprite, trough:Sprite, content:DisplayObject, mask:DisplayObject, upArrow:Sprite = null, downArrow:Sprite = null) 
		{
			_bar = bar;
			_trough = trough;
			_content = content;
			_mask = mask;
			_upArrow = upArrow;
			_downArrow = downArrow;

			_content.mask = _mask;
			_content.addEventListener(Event.CHANGE, update, false, 0, true);
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, moveBar, false, 0, true);

			_scrollBarMinimumY = _trough.y;
			_scrollBarMaximumY = _trough.height + _trough.y - _bar.height;
			
			_bar.y = _trough.y;

			_trough.addEventListener(MouseEvent.CLICK, onTroughClick, false, 0, true);
			
			update();
		}

		private function drag(event:MouseEvent):void 
		{
			_content.stage.addEventListener(MouseEvent.MOUSE_UP, stopdrag);
			_content.stage.addEventListener(MouseEvent.MOUSE_MOVE, scroll);
			_bar.startDrag(false, new Rectangle(_trough.x, _trough.y, 0, _trough.height - _bar.height));		
		}

		private function stopdrag(e:Event):void 
		{
			_content.stage.removeEventListener(MouseEvent.MOUSE_UP, stopdrag);
			_content.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scroll);
			_bar.stopDrag();
		}

		private function scroll(event:Event = null):void 
		{
			_content.y = _mask.y - (_content.height - _mask.height) * (_bar.y - _trough.y) / (_trough.height - _bar.height);
		}

		private function setScroll(enable:Boolean):void 
		{
			_enableScroll = enable;
			
			_enableScroll ? _bar.addEventListener(MouseEvent.MOUSE_DOWN, drag) : _bar.removeEventListener(MouseEvent.MOUSE_DOWN, drag);
			
			_bar.buttonMode = _bar.useHandCursor = enable;
			
			if (_upArrow) 
			{
				_upArrow.buttonMode = _upArrow.useHandCursor = enable;
				if (_enableScroll) 
				{
					_upArrow.addEventListener(MouseEvent.MOUSE_DOWN, onUpArrowMouseDown, false, 0, true);
					_upArrow.addEventListener(MouseEvent.MOUSE_UP, onUpArrowMouseUp, false, 0, true);
					_upArrow.addEventListener(MouseEvent.MOUSE_OUT, onUpArrowMouseUp, false, 0, true);
				} 
				else 
				{
					_upArrow.removeEventListener(MouseEvent.MOUSE_DOWN, onUpArrowMouseDown, false);
					_upArrow.removeEventListener(MouseEvent.MOUSE_UP, onUpArrowMouseUp, false);
					_upArrow.removeEventListener(MouseEvent.MOUSE_OUT, onUpArrowMouseUp, false);
				}
			}
			if (_downArrow) 
			{
				_downArrow.buttonMode = _downArrow.useHandCursor = enable;
				if (_enableScroll) 
				{
					_downArrow.addEventListener(MouseEvent.MOUSE_DOWN, onDownArrowMouseDown, false, 0, true);
					_downArrow.addEventListener(MouseEvent.MOUSE_UP, onDownArrowMouseUp, false, 0, true);
					_downArrow.addEventListener(MouseEvent.MOUSE_OUT, onDownArrowMouseUp, false, 0, true);
				} 
				else 
				{
					_downArrow.removeEventListener(MouseEvent.MOUSE_DOWN, onDownArrowMouseDown, false);
					_downArrow.removeEventListener(MouseEvent.MOUSE_UP, onDownArrowMouseUp, false);
					_downArrow.removeEventListener(MouseEvent.MOUSE_OUT, onDownArrowMouseUp, false);
				}
			}
		}

		private function moveBar(event:Event):void 
		{
			if (_bar.y >= _scrollBarMinimumY && _bar.y <= _scrollBarMaximumY) event is MouseEvent ? _bar.y -= (event as MouseEvent).delta * 2 : _scrollingUp ? _bar.y += 2 : _bar.y -= 2;
			if (_bar.y > _scrollBarMaximumY) _bar.y = _scrollBarMaximumY;
			if (_bar.y < _scrollBarMinimumY) _bar.y = _scrollBarMinimumY;
			scroll();
		}
		
		private function onTroughClick(e : MouseEvent) : void
		{
			var newY : Number = _trough.mouseY + (_bar.height / 2);
			
			if (newY >= _scrollBarMinimumY && newY <= _scrollBarMaximumY) _bar.y = newY;
			if (newY > _scrollBarMaximumY) _bar.y = _scrollBarMaximumY;
			if (newY < _scrollBarMinimumY) _bar.y = _scrollBarMinimumY;
						scroll();
		}

		private function onUpArrowMouseUp(event:MouseEvent):void
		{
			_content.stage.removeEventListener(Event.ENTER_FRAME, moveBar, false);
		}

		private function onUpArrowMouseDown(event:MouseEvent):void
		{
			_scrollingUp = false;
			_content.stage.addEventListener(Event.ENTER_FRAME, moveBar, false, 0, true);
		}

		private function onDownArrowMouseUp(event:MouseEvent):void
		{
			_content.stage.removeEventListener(Event.ENTER_FRAME, moveBar, false);
		}

		private function onDownArrowMouseDown(event:MouseEvent):void
		{
			_scrollingUp = true;
			_content.stage.addEventListener(Event.ENTER_FRAME, moveBar, false, 0, true);
		}

		public function update(event:Event = null):void 
		{
			if(_content.height <= _mask.height) 
			{
				setScroll(false);
				if(_autoHide) 
				{
					_bar.visible = false;
					if (_upArrow) _upArrow.visible = false;
					if (_downArrow) _downArrow.visible = false;
					dispatchEvent(new Event(HIDE, true));
				}
			} 
			else 
			{
				setScroll(true);
				_bar.visible = true;
				if (_upArrow) _upArrow.visible = true;
				if (_downArrow) _downArrow.visible = true;
				dispatchEvent(new Event(SHOW, true));
			}
			_content.y = _mask.y;
		}

		public function set enable(enable:Boolean):void 
		{
			setScroll(enable);
		}

		public function get enable():Boolean 
		{
			return _enableScroll;
		}

		public function set autoHide(autoHide:Boolean):void 
		{
			_autoHide = autoHide;
		}

		public function dispose():void
		{
			_content.removeEventListener(Event.CHANGE, update, false);
			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, moveBar, false);
			
			_trough.removeEventListener(MouseEvent.CLICK, onTroughClick, false);
			
			_bar = null;
			_content = null;
			_mask = null;
			_upArrow = null;
			_downArrow = null;
		}	
	}
}
