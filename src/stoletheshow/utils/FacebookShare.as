package stoletheshow.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	/**
	 * Shares a link on Facebook.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class FacebookShare
	{
		public function FacebookShare()
		{
		}

		public function sharePageInPopup():void
		{
			if (ExternalInterface.available)
			{
				var code:XML = <script>
							      <![CDATA[
							        function shareFacebook(){
							          var d=document
							          var f='http://www.facebook.com/share'
							          var l=d.location
							          var e=encodeURIComponent
							          var t=d.title
							          var p='.php?src=bm&v=4&i=1277427231&u='+e(l.href)+'&t='+e(t);
							          try{if(!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z) {a=function() {if (!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=626,height=436'))l.href=f+p};if (/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0);
							        }
							      ]]>
							    </script>;
				ExternalInterface.call(code);
			}
		}

		public function shareLinkInNewWindow(url:String, title:String):void
		{
			var vars:URLVariables = new URLVariables();
			vars.u = url;
			vars.t = title;

			var urlFacebookShare:URLRequest = new URLRequest("http://www.facebook.com/sharer.php");
			urlFacebookShare.data = vars;
			urlFacebookShare.method = URLRequestMethod.GET;

			navigateToURL(urlFacebookShare, "_blank");
		}
	}
}
