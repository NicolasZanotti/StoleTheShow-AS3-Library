package stoletheshow.collections
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * Holds string values that can be accessed using keys. Allows data to be loaded via XML.
	 * 
	 * @author Nicolas Zanotti, Elkana Aron
	 * @playerversion Flash 9.0.28.0
	 */
	public class XMLStringDictionary extends StringDictionary implements Loadable
	{
		private var _loader:URLLoader;
		public var delimitUnderscoreOnClient:Boolean = false;
		public var delimitUnderscoreOnServer:Boolean = true;
		public var entryNodeName:String = "item";
		public var keyAttributeName:String = "key";

		private final function onError(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}

		private final function onComplete(event:Event):void
		{
			event.stopImmediatePropagation();
			try
			{
				data = parseXMLtoObject(XML(_loader.data));
			}
			catch (e:TypeError)
			{
				throw new Error(e.message);
			}
			
			// set state to loaded
			_isLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE, true, true));
			dispatchEvent(new Event(Event.CHANGE, true, true));
			
			// clean up
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader = null;
		}

		/**
		 * Parse XML content to an associative array.
		 * 
		 * <node = key="KEY-KEY_1">value</node>
		 * 
		 * Because associative arrays don't allow minus signs, they must be converted to underscores.
		 */
		private final function parseXMLtoObject(xml:XML):Object
		{
			var obj:Object = {};
			var nodes:XMLList = xml.elements(entryNodeName);
			var n:XML;
			var key:String;
			for each (n in nodes)
			{
				key = n.attribute(keyAttributeName);
				if (delimitUnderscoreOnClient && key.search("-") != -1)
				{
					obj[key.split("-").join("_")] = n.toString();
				}
				else
				{
					obj[key] = n.toString();
				}
			}
			return obj;
		}

		private final function loadRequest(request:URLRequest):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_loader.load(request);
		}

		public override function setEntry(key:String, value:String):void
		{
			if (key.search("-") != -1) super.setEntry(key.split("-").join("_"), value);
			else super.setEntry(key, value);
			dispatchEvent(new Event(Event.CHANGE, true, true));
		}

		public override function getEntry(key:String):String
		{
			if (delimitUnderscoreOnClient && key.search("-") != -1) return super.getEntry(key.split("-").join("_"));
			return super.getEntry(key);
		}

		public function load(serviceURI:String, languageID:int):void
		{
			var request:URLRequest = new URLRequest(serviceURI);
			var variables:URLVariables = new URLVariables();
			variables.lang = languageID > 0 ? languageID : 1;
			variables.delimitUnderscore = delimitUnderscoreOnServer ? 1 : 0;
			request.data = variables;
			loadRequest(request);
		}

		public function loadWithVariables(serviceURI:String, variables:URLVariables):void
		{
			var request:URLRequest = new URLRequest(serviceURI);
			request.data = variables;
			loadRequest(request);
		}

		public override function get loaded():Boolean
		{
			return _isLoaded;
		}
	}
}