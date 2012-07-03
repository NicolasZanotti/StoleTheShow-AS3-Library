package stoletheshow.collections
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * Holds string values that can be accessed using keys. Allows data to be loaded and parsed from XML.
	 * 
	 * Using delimitUnderscore transforms any values using a dash "-" to an underscore.
	 * This allows DisplayObjects to have the same variable name as the key for easy data-binding.
	 * @see DictionaryBinder
	 * 
	 * @usage <code>
	 *  // Directly with XML data
	 * 	var dict:XMLStringDictionary = new XMLStringDictionary(xml);
	 * 	dict.getEntry("KEY-KEY_1");
	 * 	
	 * 	// Or from a service
	 * 	var dict:XMLStringDictionary = new XMLStringDictionary();
	 * 	dict.addEventListener(Event.CHANGE, onLoad);
	 * 	dict.load("http://example.com/dict.xml");
	 * </code>
	 * 
	 * @author Nicolas Zanotti, Elkana Aron
	 */
	public class XMLStringDictionary extends StringDictionary implements Loadable
	{
		private var _loader:URLLoader;
		public var delimitUnderscoreOnClient:Boolean = false;
		public var delimitUnderscoreOnServer:Boolean = true;
		public var entryNodeName:String = "item";
		public var keyAttributeName:String = "key";

		public function XMLStringDictionary(xml:XML = null, delimitUnderScore:Boolean = false)
		{
			delimitUnderscoreOnClient = delimitUnderScore;
			if (xml != null) super(parse(xml));
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

		/* ------------------------------------------------------------------------------- */
		/*  Helper methods */
		/* ------------------------------------------------------------------------------- */
		protected function loadRequest(request:URLRequest):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_loader.load(request);
		}

		/**
		 * Parse XML content to an associative array.
		 * 
		 * <item key="KEY-KEY_1">ENTRY1</item>
		 * 
		 * Because associative arrays don't allow minus signs, they must be converted to underscores.
		 */
		protected function parse(xml:XML):Object
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

		/* ------------------------------------------------------------------------------- */
		/*  Getters and setters */
		/* ------------------------------------------------------------------------------- */
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

		public override function get loaded():Boolean
		{
			return _isLoaded;
		}

		/* ------------------------------------------------------------------------------- */
		/*  Event handlers */
		/* ------------------------------------------------------------------------------- */
		private final function onError(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}

		private final function onComplete(event:Event):void
		{
			event.stopImmediatePropagation();
			try
			{
				data = parse(XML(_loader.data));
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
	}
}