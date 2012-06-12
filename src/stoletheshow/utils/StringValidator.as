package stoletheshow.utils 
{

	/**
	 * Utility methods for validating Strings.
	 * 
	 * @author Elkana Aron, Nicolas Zanotti
	 */
	public class StringValidator 
	{
		public function StringValidator() 
		{
		}
		
		/**
		 * Check for valid swiss zipcodes
		 */
		public function isValidPLZ(s:String):Boolean 
		{
			var pattern:RegExp = /^[1-9]{1}[0-9]{3}$/;
			return pattern.test(s);
		}
		
		/**
		 * Check for Swiss mobile phonenumbers
		 */
		public function isValidMobile(s:String):Boolean 
		{
			var pattern:RegExp = /^07[6-9]{1}[1-9]{1}[0-9]{6}$/;
			return pattern.test(s);			
		}

		/**
		 * Use this to restrict the possible charachters of a TextField or TextInput.
		 */
		public function restrictForEmail():String 
		{
			return "a-zA-Z0-9_\\-.@";
		}

		/**
		 * Crude check for email validity. Combine this with restrictForEmail and a server-side check.
		 */
		public function hasEmailCharacters(s:String):Boolean 
		{
			return (s.length > 5 && s.indexOf("@") != -1 && s.indexOf(".") != -1);
		}
	}
}