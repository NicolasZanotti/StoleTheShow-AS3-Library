package stoletheshow.mediators
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import stoletheshow.control.Disposable;
	import stoletheshow.display.StateChangeable;
	import stoletheshow.model.Events;
	import stoletheshow.utils.NumberHumanizer;


	/**
	 * Mediates between the Youtube Player and Component buttons.
	 * 
	 * <code>
	 * 		loader = new Loader();
	 *		loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
	 *		loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"), new LoaderContext());
	 *		
	 *		function onLoaderInit(event:Event):void
	 *		{
	 *			addChild(loader);
	 *			mediator = new YoutubePlayerMediator(loader.content).withPlayPauseButton(btPlayPause).withSoundButton(btSound).withTime(tfTimeTotal, tfTime).withScrubber(scrubber);
	 *			mediator.playerWidth = 640;
	 *			mediator.playerHeight = 360;
	 *		} 
	 * </code>
	 * 
	 * @author Nicolas Zanotti
	 * @version 20101209
	 * @see http://code.google.com/intl/de-DE/apis/youtube/flash_api_reference.html
	 * @see SWISS Ecard at P:\Swiss International Airlines\SWISS-XMAS-ECARD\4_DIGITAL\Flash
	 */
	public class YoutubePlayerMediator implements Disposable
	{
		public var player:Object;
		public var playerWidth:Number = 480;
		public var playerHeight:Number = 360;
		protected var humanizer:NumberHumanizer;
		protected var events:Events;
		/* ------------------------------------------------------------------------------- */
		/*  DisplayObjects */
		/* ------------------------------------------------------------------------------- */
		protected var btPlayPause:DisplayObject;
		protected var btSound:DisplayObject;
		protected var tfTotalTime:TextField;
		protected var tfCurrentTime:TextField;
		protected var mcScrubber:MovieClip;
		/* ------------------------------------------------------------------------------- */
		/*  Timers */
		/* ------------------------------------------------------------------------------- */
		protected var timeUpdate:Timer;
		protected var scrubberUpdate:Timer;
		/* ------------------------------------------------------------------------------- */
		/*  State */
		/* ------------------------------------------------------------------------------- */
		protected var hasPlayPauseButton:Boolean = false;
		protected var hasSoundButton:Boolean = false;
		protected var hasTimeDisplay:Boolean = false;
		protected var hasScrubber:Boolean = false;

		public function YoutubePlayerMediator(chromelessYoutubePlayer:Object)
		{
			// Bind data
			player = chromelessYoutubePlayer;

			// Configure listeners
			events = new Events();
			events.add(player as EventDispatcher, "onReady", onPlayerReady);
			events.add(player as EventDispatcher, "onError", onPlayerError);
			events.add(player as EventDispatcher, "onStateChange", onPlayerStateChange);
			events.add(player as EventDispatcher, "onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}

		/* ------------------------------------------------------------------------------- */
		/*  Component Initializers */
		/* ------------------------------------------------------------------------------- */
		public function withPlayPauseButton(playPauseButton:DisplayObject):YoutubePlayerMediator
		{
			btPlayPause = playPauseButton;
			events.add(playPauseButton, MouseEvent.CLICK, onPlayPauseClick);
			hasPlayPauseButton = true;
			return this;
		}

		public function withSoundButton(soundButton:DisplayObject):YoutubePlayerMediator
		{
			btSound = soundButton;
			events.add(soundButton, MouseEvent.CLICK, onSoundClick);
			hasSoundButton = true;
			return this;
		}

		public function withTime(totalTime:TextField, currentTime:TextField):YoutubePlayerMediator
		{
			humanizer = new NumberHumanizer();
			tfTotalTime = totalTime;
			tfCurrentTime = currentTime;
			timeUpdate = new Timer(1000);
			events.add(timeUpdate, TimerEvent.TIMER, onTimeUpdateTimerTick);
			hasTimeDisplay = true;
			return this;
		}

		public function withScrubber(animationFrom0to100Percent:MovieClip):YoutubePlayerMediator
		{
			mcScrubber = animationFrom0to100Percent;
			scrubberUpdate = new Timer(100);
			events.add(scrubberUpdate, TimerEvent.TIMER, onScrubberUpdateTimerTick);
			events.add(mcScrubber, MouseEvent.CLICK, onScrubberClick);
			hasScrubber = true;
			return this;
		}

		/* ------------------------------------------------------------------------------- */
		/*  User Input Handlers */
		/* ------------------------------------------------------------------------------- */
		protected function onScrubberClick(event:MouseEvent):void
		{
			var time:Number = mcScrubber.mouseX * player.getDuration() / mcScrubber.width;
			player.seekTo(time, false);
		}

		protected function onPlayPauseClick(event:MouseEvent):void
		{
			if (player.getPlayerState() == YoutubePlayerStates.PLAYING)
			{
				player.pauseVideo();
			}
			else if (player.getPlayerState() == YoutubePlayerStates.PAUSED)
			{
				player.playVideo();
			}
			else if (player.getPlayerState() == YoutubePlayerStates.ENDED)
			{
				player.seekTo(0, false);
			}
		}

		protected function onSoundClick(event:Event):void
		{
			if (player.isMuted())
			{
				player.unMute();
				if (btSound is StateChangeable) (btSound as StateChangeable).state = "UNMUTE";
			}
			else
			{
				player.mute();
				if (btSound is StateChangeable) (btSound as StateChangeable).state = "MUTE";
			}
		}

		/* ------------------------------------------------------------------------------- */
		/*  Timer Events */
		/* ------------------------------------------------------------------------------- */
		protected function onTimeUpdateTimerTick(event:TimerEvent):void
		{
			tfCurrentTime.text = humanizer.secondsToTime(player.getCurrentTime());
		}

		protected function onScrubberUpdateTimerTick(event:TimerEvent):void
		{
			var frame:int = player.getCurrentTime() * mcScrubber.totalFrames / player.getDuration();
			mcScrubber.gotoAndStop(frame);
		}

		/* ------------------------------------------------------------------------------- */
		/*  Youtube Player Event Handlers */
		/* ------------------------------------------------------------------------------- */
		protected function onPlayerReady(event:Event):void
		{
			// Event.data contains the event parameter, which is the Player API ID
			trace("player ready:", Object(event).data);
			player.setSize(playerWidth, playerHeight);
		}

		protected function onPlayerError(event:Event):void
		{
			trace("player error:", Object(event).data);
		}

		protected function onPlayerStateChange(event:Event):void
		{
			trace("player state:", Object(event).data);

			switch (Object(event).data)
			{
				case YoutubePlayerStates.PLAYING :
					if (hasPlayPauseButton)
					{
						if (btPlayPause is StateChangeable) (btPlayPause as StateChangeable).state = "PLAY";
					}
					if (hasTimeDisplay)
					{
						tfTotalTime.text = humanizer.secondsToTime(player.getDuration());
						timeUpdate.start();
					}
					if (hasScrubber)
					{
						scrubberUpdate.start();
					}
					break;
				case YoutubePlayerStates.PAUSED :
					if (hasPlayPauseButton)
					{
						if (btPlayPause is StateChangeable) (btPlayPause as StateChangeable).state = "PAUSE";
					}
					if (hasTimeDisplay)
					{
						timeUpdate.stop();
					}
					if (hasScrubber)
					{
						scrubberUpdate.stop();
					}
					break;
				case YoutubePlayerStates.UNSTARTED :
					if (hasPlayPauseButton)
					{
						if (btPlayPause is StateChangeable) (btPlayPause as StateChangeable).state = "PAUSE";
					}
					if (hasTimeDisplay)
					{
						timeUpdate.stop();
						tfCurrentTime.text = tfTotalTime.text = "00:00";
					}
					if (hasScrubber)
					{
						scrubberUpdate.stop();
						mcScrubber.gotoAndStop(1);
					}
					break;
				case YoutubePlayerStates.ENDED :
					if (hasPlayPauseButton)
					{
						if (btPlayPause is StateChangeable) (btPlayPause as StateChangeable).state = "PAUSE";
					}
					if (hasTimeDisplay)
					{
						timeUpdate.stop();
						tfCurrentTime.text = tfTotalTime.text;
					}
					if (hasScrubber)
					{
						scrubberUpdate.stop();
						mcScrubber.gotoAndStop(mcScrubber.totalFrames);
					}
					break;
			}
		}

		protected function onVideoPlaybackQualityChange(event:Event):void
		{
			trace("video quality:", Object(event).data);
		}

		public function dispose():void
		{
			events.removeAll();
			events = null;
			player = null;

			if (hasPlayPauseButton)
			{
				btPlayPause = null;
			}

			if (hasSoundButton)
			{
				btSound = null;
			}

			if (hasTimeDisplay)
			{
				timeUpdate.stop();
				timeUpdate = null;
			}
		}
	}
}
/**
 * @author Nicolas Zanotti
 */
internal class YoutubePlayerStates
{
	public static const UNSTARTED:int = -1;
	public static const ENDED:int = 0;
	public static const PLAYING:int = 1;
	public static const PAUSED:int = 2;
	public static const BUFFERING:int = 3;
	public static const VIDEO_CUED:int = 5;
}
