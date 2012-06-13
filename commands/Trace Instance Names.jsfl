/**
 * Traces the instance names of a DisplayObject to the output window.
 *
 * @author Nicolas Zanotti
 */

function getInstanceNamesFromFramesAndLayers(timeline) {
	var layer, frame, element, obj;
	var instanceNames = [];

	for(var i = 0; i < timeline.layers.length; i++) {

		layer = timeline.layers[i];

		for(var j = 0; j < layer.frames.length; j++) {

			frame = layer.frames[j];

			for(var k = 0; k < frame.elements.length; k++) {

				element = frame.elements[k];

				if(element.name != "") {

					obj = createObject(element);

					if(!existsInArray(instanceNames, obj)) {
						instanceNames.push(obj);
					}
				}
			}
		}
	}

	return instanceNames;
}

function createObject(element) {
	var obj = {}
	obj.name = element.name;
	obj.type = "DisplayObject";

	if(element.elementType == "text") {
		obj.type = "TextField";
	} else if(element.libraryItem) {
		if(element.libraryItem.linkageClassName || element.libraryItem.linkageBaseClass) {
			obj.type = element.libraryItem.linkageClassName.split(".").pop();
		} else if(element.elementType == "instance") {
			switch (element.symbolType) {
				case "movie clip":
					obj.type = "MovieClip";
					break;
				case "button":
					obj.type = "SimpleButton";
					break;
			}
		}
	}

	return obj;
}

function existsInArray(arr, obj) {
	for(var i = 0; i < arr.length; i++) {
		if(arr[i].name == obj.name && arr[i].type == obj.type) {
			return true;
		}
	}

	return false;
}

function traceInstanceNames(instanceNames) {
	fl.outputPanel.clear();
	
	for(var i = 0, n = instanceNames.length; i < n; i++) {
		fl.trace("public var " + instanceNames[i].name + ":" + instanceNames[i].type + ";");
	}
}

traceInstanceNames(getInstanceNamesFromFramesAndLayers(fl.getDocumentDOM().getTimeline()));