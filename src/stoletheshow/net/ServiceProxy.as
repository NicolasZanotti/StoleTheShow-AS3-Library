package stoletheshow.net 
{
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;

	/**
	 * Abstract Service Proxy
	 * @author Nicolas Zanotti
	 */
	public class ServiceProxy extends EventDispatcher
	{
		protected var _connection:NetConnection;

		public function ServiceProxy(connection:NetConnection) 
		{
			_connection = connection;
			if (_connection == null) throw new Error("Serviceproxy: Connection not defined.");
		}
		
		/**
		* Bind this to globally handle NetConnection errors.
		*/
		public function errorHandler(error:Object):void
		{
			if (error.description != null) throw new Error(error.description);
		}
	}
}