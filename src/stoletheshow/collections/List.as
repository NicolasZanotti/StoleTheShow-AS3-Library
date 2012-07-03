package stoletheshow.collections
{
	/**
	 * @author Nicolas Zanotti
	 */
	public class List
	{
		protected var _container:Array;
		protected var _index:int = -1;
		protected var _length:uint;

		public function List(container:Array)
		{
			_container = container;
			_length = container.length;
		}

		public function get next():Object
		{
			_index = (_index + 1) % _length;
			return _container[_index];
		}

		public function get previous():Object
		{
			_index = _index < 1 ? _length - 1 : _index - 1;
			return _container[_index];
		}

		public function get hasNext():Boolean
		{
			return (_index == -1 && _length == 1) ? false : (_index < _length - 1);
		}

		public function get hasPrevious():Boolean
		{
			return _index > 0;
		}

		public function skipToLast():void
		{
			_index = _length;
		}
	}
}