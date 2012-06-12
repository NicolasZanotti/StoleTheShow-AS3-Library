package stoletheshow.collections 
{

	/**
	 * @author Nicolas Zanotti
	 */
	public class List 
	{
		protected var _a:Array = [];
		protected var _index:int = -1;

		public function List()
		{
		}

		public function add(obj:Object):void 
		{
			_a.push(obj);
		}

		public function next():Object 
		{
			_index++;
			_index = _index % _a.length;	
			return _a[_index];
		}

		public function previous():Object
		{
			if (_index == 0 || isNaN(_index)) 
			{
				_index = _a.length - 1;
			}
			else 
			{
				_index--;
			}
			return _a[_index];
		}

		public function get length():uint 
		{
			return _a.length;
		}
	}
}