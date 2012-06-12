package stoletheshow.net.weborb 
{
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import stoletheshow.control.Disposable;


	/**
	 * NetConnection that automatically connects to WebOrb.
	 * @author Nicolas Zanotti
	 */
	public class WebOrbConnection extends NetConnection implements Disposable
	{
		public function WebOrbConnection() 
		{
			super();
			objectEncoding = ObjectEncoding.AMF3;
			connect("/weborb.aspx");
		}

		public function dispose():void 
		{
			close();
		}
	}
}