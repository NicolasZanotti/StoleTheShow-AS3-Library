package stoletheshow.loaders
{
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import stoletheshow.control.Disposable;
	import stoletheshow.display.StateChangeable;


	/**
	 * Mangages the loading of a SWF by incrementing the first frames of the main movieclip.
	 * • Displays loading information until the destination frame is loaded.
	 * • Dispatches events according to the current loading state.
	 * 
	 * IMPORTANT: Make sure all the classes are exported into the "EXTERNAL_LOADER" frame (e.g. frame 2), or else the loader won't apear quick enough.
	 * See 'File' -> 'Publish Settings' -> 'ActionScript Settings' -> 'Export Classes in Frame'. Make sure it is not set to frame 1.
	 * 
	 * @author Nicolas Zanotti
	 */
	public class Bootstrapper extends EventDispatcher implements Disposable
	{
		public static const CLASSES_FRAME_COMPLETE:String = "classes_frame_complete";
		public static const EXTERNAL_COMPLETE:String = "external_complete";
		public static const DESTINATION_FRAME_COMPLETE:String = "destination_frame_complete";
		public static const TOTALFRAMES_COMPLETE:String = "totalframes_complete";
		public var externalAssetsLoaded:Boolean = true;
		private var _main:MovieClip;
		private var _percentAnimation:MovieClip;
		private var _percentText:TextField;
		private var _state:State;
		private var _destinationFrame:uint;
		private var _classesFrame:uint;
		private var _haltLoad:Boolean = false;

		public function Bootstrapper(main:MovieClip, destinationFrame:uint = 3, classesFrame:uint = 2)
		{
			_main = main;
			_destinationFrame = destinationFrame;
			_classesFrame = classesFrame;
		}

		public function withLoaderAnimation(movieClipWith100Frames:MovieClip):Bootstrapper
		{
			_percentAnimation = movieClipWith100Frames;
			_percentAnimation.gotoAndStop(1);
			return this;
		}

		public function withLoaderPercentageText(textField:TextField):Bootstrapper
		{
			_percentText = textField;
			return this;
		}

		/**
		 * Cover the entire movie with sprite that displays an error message.
		 * This way, any faulty animations will be hidden underneath if the flash player can't run any code.
		 * The sprite will be emptied if the version is correct. If it is removed from the stage it can cause errors.
		 */
		public function withPlayerVerionError(targetVersion:Number, errorMessageFPVersion:DisplayObjectContainer):Bootstrapper
		{
			var versionNumbers:Array = Capabilities.version.split(" ")[1].split(",");
			var capableVersion:Number = Number(versionNumbers[0]) + Number(versionNumbers[1]) / 10;
			_haltLoad = capableVersion < targetVersion;
			if (!_haltLoad) while (errorMessageFPVersion.numChildren > 0) errorMessageFPVersion.removeChildAt(0);
			return this;
		}

		/**
		 * Wait for any external assets/services that need to be loaded. Set externalAssetsLoaded to true when everything is complete.
		 */
		public function waitForExternalLoad():Bootstrapper
		{
			externalAssetsLoaded = false;
			return this;
		}

		public function init():void
		{
			_main.stop();
			if (!_haltLoad)
			{
				_state = new State();
				_main.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}

		public function dispose():void
		{
			_main.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
			_main = null;
			_state = null;
			_percentAnimation = null;
			_percentText = null;
		}

		private function onEnterFrame(event:Event):void
		{
			if (_state.allEventsDispatched) dispose();
			updateState();
			updatePercent();
			updateFramesAndEvents();
		}

		private function updateState():void
		{
			_state.classesFrameLoaded = _main.framesLoaded >= _classesFrame;
			_state.destinationFrameLoaded = _main.framesLoaded >= _destinationFrame;
			_state.externalAssetsLoaded = _state.classesFrameLoaded && externalAssetsLoaded;
			_state.totalFramesLoaded = _main.framesLoaded == _main.totalFrames;
		}

		private function updatePercent():void
		{
			if (_state.percentLoaded == 100) return;
			_state.percentLoaded = Math.floor(_main.loaderInfo.bytesLoaded / _main.loaderInfo.bytesTotal * 100);
			if (_percentAnimation != null && _percentAnimation.stage != null) _percentAnimation.gotoAndStop(_state.percentLoaded);
			if (_percentText != null && _percentText.stage != null) _percentText.text = _state.percentLoaded.toString() + "%";
		}

		private function updateFramesAndEvents():void
		{
			if (_state.frameClassesReady)
			{
				_state.classesFrameEventDispatched = true;
				_main is StateChangeable ? _main.state = _classesFrame : _main.gotoAndStop(_classesFrame);
				dispatchEvent(new Event(CLASSES_FRAME_COMPLETE));
			}

			if (_state.externalReady)
			{
				_state.externalAssetsEventDispatched = true;
				dispatchEvent(new Event(EXTERNAL_COMPLETE));
			}

			if (_state.frameDestiniationReady)
			{
				_state.destiniationFrameEventDispatched = true;
				_main is StateChangeable ? _main.state = _destinationFrame : _main.gotoAndStop(_destinationFrame);
				dispatchEvent(new Event(DESTINATION_FRAME_COMPLETE));
			}

			if (_state.totalFramesReady)
			{
				_state.totalFramesEventDispatched = true;
				dispatchEvent(new Event(TOTALFRAMES_COMPLETE));
			}
		}

		public function frameLoaded(labelName:String):Boolean
		{
			for (var i:int = 0, n:int = _main.currentLabels.length, label:FrameLabel; i < n; i++)
			{
				label = _main.currentLabels[i] as FrameLabel;
				if (label.name == labelName && _main.framesLoaded < label.frame) return false;
			}
			return true;
		}

		public function get percentLoaded():int
		{
			return _state == null ? 0 : _state.percentLoaded;
		}
	}
}
class State
{
	public var percentLoaded:int = 0;
	// Loaded Frames and Assets
	public var classesFrameLoaded:Boolean = false;
	public var destinationFrameLoaded:Boolean = false;
	public var externalAssetsLoaded:Boolean = false;
	public var totalFramesLoaded:Boolean = false;
	// Events Dispatched
	public var classesFrameEventDispatched:Boolean = false;
	public var destiniationFrameEventDispatched:Boolean = false;
	public var totalFramesEventDispatched:Boolean = false;
	public var externalAssetsEventDispatched:Boolean = false;

	public function get allEventsDispatched():Boolean
	{
		return classesFrameEventDispatched && destiniationFrameEventDispatched && totalFramesEventDispatched && totalFramesEventDispatched;
	}

	public function get frameClassesReady():Boolean
	{
		return classesFrameLoaded && !classesFrameEventDispatched;
	}

	public function get frameDestiniationReady():Boolean
	{
		return classesFrameEventDispatched && externalAssetsEventDispatched && destinationFrameLoaded && !destiniationFrameEventDispatched;
	}

	public function get externalReady():Boolean
	{
		return externalAssetsLoaded && !externalAssetsEventDispatched;
	}

	public function get totalFramesReady():Boolean
	{
		return classesFrameEventDispatched && externalAssetsEventDispatched && destiniationFrameEventDispatched && totalFramesLoaded && !totalFramesEventDispatched;
	}
}