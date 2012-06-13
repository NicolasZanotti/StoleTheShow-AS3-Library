/**
 * Gets the frame labels of a timeline.
 *
 * @author Nicolas Zanotti
 * @param {Object} timeLine
 * @return {Array} frameLabels
 */
function getFrameLabels(timeLine) {
	var frameLabels = [];
	var layer;
	var layersLength = timeLine.layers.length;
	var frame;
	var framesLength;

	for(var i = 0; i < layersLength; i++) {
		layer = timeLine.layers[i];
		framesLength = layer.frames.length;

		for(var j = 0; j < framesLength; j++) {
			frame = layer.frames[j];
			if(frame.startFrame != j)
				continue;
			if(frame.name.length > 0)
				frameLabels.push(frame.name);
		}
	}
	return frameLabels;
}

/**
 * Generates a class named FrameLabels and adds a static constant of each label.
 * @author Nicolas Zanotti
 * @param {Object} frameLabels
 * @return {String} output
 */
function generateFrameLabelsClassCode(frameLabels) {
	var output = "";
	var tab = "\t";
	var newline = "\n";

	output += "package" + newline;
	output += "{" + newline;
	output += tab + "public class FrameLabels" + newline;
	output += tab + "{" + newline;
	for(var i = frameLabels.length - 1; i >= 0; i--)
		output += tab + tab + "public static const " + frameLabels[i] + ":String = " + '"' + frameLabels[i] + '"' + ";" + newline;
	output += tab + "}" + newline;
	output += "}";

	return output;
}

function traceFrameLabels() {
	// var timelineOfSelection = fl.getDocumentDOM().selection[0].libraryItem.timeline;
	var currentTimeline = fl.getDocumentDOM().getTimeline();
	var frameLabels = getFrameLabels(currentTimeline);

	fl.outputPanel.clear();
	if(frameLabels.length == 0) {
		fl.trace("No frame labels found");
	} else {
		fl.trace(generateFrameLabelsClassCode(frameLabels));
	}
}

traceFrameLabels(); 