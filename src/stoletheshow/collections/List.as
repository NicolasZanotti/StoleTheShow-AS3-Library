package stoletheshow.collections
{
	/**
	 * @author Nicolas Zanotti
	 */
	public class List
	{
		protected var _container:Array;
		protected var _index:int = -1;

		public function List(container:Array)
		{
			_container = container;
		}

		public function get next():Object
		{
			_index = (_index + 1) % _container.length;
			return _container[_index];
		}

		public function get previous():Object
		{
			_index = _index < 1 ? _container.length - 1 : _index - 1;
			return _container[_index];
		}

		public function get hasNext():Boolean
		{
			return _index < _container.length - 1;
		}

		public function get hasPrevious():Boolean
		{
			return _index > 0;
		}

		public function skipToLast():void
		{
			_index = _container.length;
		}
	}
}