/**
 * Generates a Controller Class and traces it in the output window.
 * 
 * @author Nicolas Zanotti
 */

/* ------------------------------------------------------------------------------- */
/*  Getters */
/* ------------------------------------------------------------------------------- */
function getFrameLabels(timeLine)
{
	var frameLabels = [];
	var layersLength = timeLine.layers.length;
	var layer, frame, framesLength;
	
	for (var i = 0; i < layersLength; i++) 
	{
		layer = timeLine.layers[i];
		framesLength = layer.frames.length;
		
		for (var j = 0; j < framesLength; j++) 
		{
			frame = layer.frames[j];
			if (frame.startFrame != j) continue;
			if (frame.name.length > 0) frameLabels.push(frame.name);
		}
	}
	return frameLabels;
}

function getLinkageInLibrary(className)
{
	var items = fl.getDocumentDOM().library.items;
	var item, split, itemClassName;
	
	for (var n = 0; n < items.length; n++) 
	{
		item = items[n];
		
		if (!item.linkageClassName) continue;
		
		split = item.linkageClassName.split(".");
		itemClassName = split[split.length - 1];
		
		if (itemClassName == className) return "import " + item.linkageClassName + ";";
	}
	
	return "import " + className + ";";
}

function getCurrentClip(timeline)
{
	var name, domain, type;

	type = timeline.frameCount > 1 ? "MovieClip" : "Sprite";
	
	var a = getLinkedClass(timeline.name).split(".");
	
	if (a.length == 1) 
	{
		name = a[0];
		domain = "";
	}
	else 
	{
		name = a.pop();
		domain = a.join(".");
	}
	
	return {"name": name, "domain": domain, "type": type};
}

function getLinkedClass(timelineName)
{
	var items = fl.getDocumentDOM().library.items;
	var itemName;
	var className;
	
	if (timelineName == "Scene 1") return "Main";
	
	for (var n = 0; n < items.length; n++) 
	{
		itemName = items[n].name.split('/').pop();
		if (itemName == timelineName) return items[n].linkageClassName || timelineName;
	}
	
	return timelineName;
}

function getInstanceNames(timeline)
{
	var layer, frame, element;
	var instanceNames = [];
	var obj;
	
	// Go through all frames in all layers and search for instance variables.
	for (var i = 0; i < timeline.layers.length; i++) 
	{
		layer = timeline.layers[i];
		for (var j = 0; j < layer.frames.length; j++) 
		{
			frame = layer.frames[j];
			for (var k = 0; k < frame.elements.length; k++) 
			{
				element = frame.elements[k];
				
				if (element.name == "") continue;
				
				obj = {}
				obj.name = element.name;
				obj.type = "DisplayObject";
				
				if (element.elementType == "text") 
				{
					obj.type = "TextField";
				}
				else if (element.libraryItem) 
				{
					if (element.libraryItem.linkageClassName || element.libraryItem.linkageBaseClass) 
					{
						obj.type = element.libraryItem.linkageClassName.split(".").pop();
					}
					else if (element.elementType == "instance") 
					{
						switch (element.symbolType)
						{
							case "movie clip":
								obj.type = "MovieClip";
								break;
							case "button":
								obj.type = "SimpleButton";
								break;
						}
					}
				}
				instanceNames.push(obj);
			}
		}
	}
	
	return instanceNames;
}

function hasDuplicateInstanceNames(instanceNames)
{
	a = new Array();
	for (var prop in instanceNames) a.push(instanceNames[prop].name);
	a.sort();
	var len = a.length;
	for (var i = 0; i < len; i++) if (a[i + 1] == a[i]) return true;
	return false;
}

function hasDuplicateFrameLabels(frameLabels) 
{
	a = frameLabels.concat();
	a.sort();
	var len = a.length;
	for (var i = 0; i < len; i++) if (a[i + 1] == a[i]) return true;
	return false;
}

function hasLoaders(instanceNames) 
{
	for (var prop in instanceNames) if (instanceNames[prop].hasOwnProperty("type") && instanceNames[prop].type == "UILoader") return true;
    return false;
}

function hasButtons(instanceNames) 
{
    for (var prop in instanceNames) if (instanceNames[prop].hasOwnProperty("type") && isButton(instanceNames[prop].type)) return true;
    return false;
}

function hasTextFields(instanceNames)
{
	for (var prop in instanceNames) 
	{
		if (instanceNames[prop].hasOwnProperty("type")) 
		{
			if (isTextEnabled(instanceNames[prop].type)) return true;
			if (isLabelEnabled(instanceNames[prop].type)) return true;
		}
	}
    return false;
}

function isButton(type)
{
	var types = ["SimpleButton", "Button"];
	for (var prop in types) if (type == types[prop]) return true;
	return false;
}

function isTextEnabled(type) 
{
	var types = ["TextField", "Label"];
	for (var prop in types) if (type == types[prop]) return true;
	return false;
}

function isLabelEnabled(type) 
{
	var types = ["RadioButton", "Button", "CheckBox"];
	for (var prop in types) if (type == types[prop]) return true;
	return false;
}

/* ------------------------------------------------------------------------------- */
/*  Code Generators */
/* ------------------------------------------------------------------------------- */
function generateFrameLabelCode(frameLabels)
{
	var code = "";
	for (var i = frameLabels.length - 1; i >= 0; i--) code += "\t" + "public static const " + frameLabels[i].split(" ").join("_").toUpperCase() + ":String = " + '"' + frameLabels[i] + '"' + ";" + "\n";
	return code
}

function generateEventHandlerName(name, event) 
{
	return "on" + name.charAt(0).toUpperCase() + name.substr(1).toLowerCase() + event.charAt(0).toUpperCase() + event.substr(1).toLowerCase();
}

function generateInstanceNamesCode(instanceNames) 
{
	var code = "";
	for (var prop in instanceNames) code += "\t\tpublic var " + instanceNames[prop].name + ":" + instanceNames[prop].type + ";" + "\n";
	return code;
}

function generateButtonEventsCode(instanceNames) 
{
	var code = "";
	var len = instanceNames.length;
	
	for (var i = 0; i < len; i++) 
	{
		obj = instanceNames[i];
		if (isButton(obj.type)) code += "\t\t\tct.events.add(" + obj.name + ", MouseEvent.CLICK, " + generateEventHandlerName(obj.name, "click") + ");" + "\n";
	}
	
	return code;
}

function generateButtonEventHandlersCode(instanceNames) 
{
	var code = "";
	var t = "\t";
	var n = "\n";
	var name;
	
	for (var prop in instanceNames) 
	{
		if (isButton(instanceNames[prop].type)) 
		{
			name = generateEventHandlerName(instanceNames[prop].name, "click");
			code += t + t + "private function " + name + "(event:MouseEvent):void" + n;
			code += t + t + "{" + n;
			code += t + t + t + "event.stopPropagation();" + n;
			code += t + t + t + "trace(\"" + instanceNames[prop].name + " clicked\");" + n;
			code += t + t + "}" + n;
			code += n;
		}
	}
	
	return code;
}

function generateLoaderEventHandlersCode(instanceNames) 
{
	var code = "";
	var t = "\t";
	var n = "\n";
	var name;
	
	for (var prop in instanceNames) 
	{
		if (instanceNames[prop].type == "UILoader") 
		{
			name = generateEventHandlerName(instanceNames[prop].name, "complete");
			code += t + t + "private function " + name + "(event:Event):void" + n;
			code += t + t + "{" + n;
			code += t + t + t + "event.stopPropagation();" + n;
			code += t + t + t + "trace(\"" + instanceNames[prop].name + " complete\");" + n;
			code += t + t + "}" + n;
			code += n;
			
			name = generateEventHandlerName(instanceNames[prop].name, "error");
			code += t + t + "private function " + name + "(event:IOErrorEvent):void" + n;
			code += t + t + "{" + n;
			code += t + t + t + "event.stopPropagation();" + n;
			code += t + t + t + "trace(\"" + instanceNames[prop].name + " error\");" + n;
			code += t + t + "}" + n;
			code += n;
		}
	}
	
	return code;
}

function generateLoaderEventsCode(instanceNames) 
{
	var code = "";
	var len = instanceNames.length;
	
	for (var i = 0; i < len; i++) 
	{
		obj = instanceNames[i];
		if (obj.type == "UILoader") 
		{
			code += "\t\t\tct.events.add(" + obj.name + ", Event.COMPLETE, " + generateEventHandlerName(obj.name, "complete") + ");" + "\n";
			code += "\t\t\tct.events.add(" + obj.name + ", IOErrorEvent.IO_ERROR, " + generateEventHandlerName(obj.name, "error") + ");" + "\n";
		}
	}
	
	return code;
}

function generateTextFieldDictionaryCode(instanceNames)
{
	var code = "";
	var obj;
	var len = instanceNames.length;
	
	for (var i = 0; i < len; i++) 
	{
		obj = instanceNames[i];
		
		if (isTextEnabled(obj.type)) 
		{
			code += "\t\t\t" + obj.name + ".text = dict.getEntry(\"\");" + "\n";
		}
		else if (isLabelEnabled(obj.type)) 
		{
			code += "\t\t\t" + obj.name + ".label = dict.getEntry(\"\");" + "\n";
		}
	}

	return code;
}

function generateImportCode(clip, instanceNames) 
{
	var a = new Array();
	var unique = new Array();
	var code = "";
	var prop;
	
	// Add all types
	a.push(clip.type);
	for (prop in instanceNames) a.push(instanceNames[prop].type);
	
	// Build unique array
	o:for(var i = 0, n = a.length; i < n; i++)
	{
		for(var x = 0, y = unique.length; x < y; x++) if(unique[x]==a[i]) continue o;
		unique[unique.length] = a[i];
	}
	
	a = new Array();

	for (prop in unique) 
	{
		switch (unique[prop])
		{
			case "MovieClip":
				a.push("import flash.display.MovieClip;");
				break;
			case "Sprite":
				a.push("import flash.display.Sprite;");
				break;
			case "SimpleButton":
				a.push("import flash.display.SimpleButton;");
				break;
			case "TextField":
				a.push("import flash.text.TextField;");
				break;
			default:
				a.push(getLinkageInLibrary(unique[prop]));
		}
	}
	
	a.sort();
	
	for (prop in a) code += "\t" + a[prop] + "\n";
	
	return code;
}

function generateClassCode(author, clip, frameLabels, instanceNames, addButtonsListeners, addDictionary, addLoaderListeners)
{
	var code = "";
	var t = "\t";
	var n = "\n";
	
	code += "package " + clip.domain + n;
	code += "{" + n;
	
	if (addDictionary) code += t + "import stoletheshow.collections.StringCollectable;" + n;
	
	code += t + "import stoletheshow.control.Controllable;" + n;
	code += t + "import stoletheshow.control.Controller;" + n
	code += n;
	
	if (instanceNames.length != 0) code += generateImportCode(clip, instanceNames);
	if (addButtonsListeners) code += t + "import flash.events.MouseEvent;" + n;
	if (addLoaderListeners) code += t + "import flash.events.Event;" + n + t + "import flash.events.IOErrorEvent;" + n;
	
	code += n;
	code += t + "/**" + n;
	code += t + " * @author " + author + n;
	code += t + " */" + n;
	code += t + "public class " + clip.name + " extends " + clip.type + " implements Controllable" + n;
	code += t + "{" + n;
	code += t + t + "public var ct:Controller;" + n;
	
	if (instanceNames.length != 0) code += generateInstanceNamesCode(instanceNames);
	
	if (frameLabels.length != 0) code += t + t + "public var framelabels:" + clip.name + "FrameLabels = new " + clip.name + "FrameLabels();" + n;
	code += n;
	code += t + t + "public function " + clip.name + "()" + n;
	code += t + t + "{" + n;
	code += t + t + t + "ct = new Controller(this);" + n;
	code += t + t + "}" + n;
	code += n;
	
	if (addButtonsListeners || addLoaderListeners)
	{
		code += t + t + "//---------------------------------------------------------------------" + n;
		code += t + t + "//  Event Handlers" + n;
		code += t + t + "//---------------------------------------------------------------------" + n;
	}
	
	if (addButtonsListeners) code += generateButtonEventHandlersCode(instanceNames);
	
	if (addLoaderListeners) code += generateLoaderEventHandlersCode(instanceNames);
	
	code += t + t + "//---------------------------------------------------------------------" + n;
	code += t + t + "//  Controller Methods" + n;
	code += t + t + "//---------------------------------------------------------------------" + n;
	code += t + t + "public function init():void" + n;
	code += t + t + "{" + n;
	
	if (addButtonsListeners || addLoaderListeners) code += t + t + t + "// Configure listeners" + n;

	if (addButtonsListeners) code += generateButtonEventsCode(instanceNames);

	if (addLoaderListeners) code += generateLoaderEventsCode(instanceNames);
	
	if (addButtonsListeners && addDictionary) code += n;
	
	if (addDictionary)
	{
		code += t + t + t + "// Bind properties" + n;
		code += t + t + t + "var dict:StringCollectable; // TODO Point dict variable to dictionary" + n;
		code += generateTextFieldDictionaryCode(instanceNames);
	}
	
	code += t + t + "}" + n;
	code += n;
	code += t + t + "public function dispose():void" + n
	code += t + t + "{" + n;
	code += t + t + t + "ct = null;" + n;
	code += t + t + "}" + n;
	code += t + "}" + n;
	code += "}";
	if (clip.type == "MovieClip" && frameLabels.length != 0) 
	{
		code += n;
		code += "internal class " + clip.name + "FrameLabels" + n;
		code += "{" + n;
		code += generateFrameLabelCode(frameLabels);
		code += "}";
	}
	return code;
}

/* ------------------------------------------------------------------------------- */
/*  Map Objects */
/* ------------------------------------------------------------------------------- */
function init()
{
	fl.outputPanel.clear();
	
	if (!fl.getDocumentDOM()) 
	{
		alert("Please open a file before using this command.");
		return;
	}
	
	var currentTimeline = fl.getDocumentDOM().getTimeline() || fl.getDocumentDOM().selection[0].libraryItem.timeline;
	
	var instanceNames = getInstanceNames(currentTimeline);
	if (hasDuplicateInstanceNames(instanceNames)) 
	{
		alert("Found duplicate instance names.");
		return;
	}
	
	var frameLabels = getFrameLabels(currentTimeline);
	if (hasDuplicateFrameLabels(frameLabels)) 
	{
		alert("Found duplicate frame labels.");
		return;
	}
	
	var code = generateClassCode("YOUR_NAME", getCurrentClip(currentTimeline), frameLabels, instanceNames, hasButtons(instanceNames), hasTextFields(instanceNames), hasLoaders(instanceNames));
	
	fl.trace(code);
}

init();