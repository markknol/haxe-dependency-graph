package;

import js.Lib;
import js.Browser.*;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import Parser;
import js.html.Element;
import js.html.FileReader;
import js.html.SelectElement;
/**
 * ...
 * @author Mark Knol
 */
class Main
{
	static function main() new Main();
	
	private var _context:CanvasRenderingContext2D;
	private var _linksContainer:Element;
	private var _parser:Parser = new Parser();
	private var graphData:Array<DepInfo>;
	private var _canvas:CanvasElement;

	public function new()
	{
		//graphData = _parser.parse(Builder.include("bin/dump/js/.dependencies.dump"), graphData);
	//	graphData = _parser.parse(Builder.include("bin/dump/macro/.dependencies.dump"), graphData);
		
		
		_canvas = cast document.getElementById("canvas");
		_canvas.width = window.innerWidth;
		_canvas.height = window.innerHeight;
		_context = _canvas.getContext2d();
		addDragDrop(document.getElementById("canvas"));
	}
	
	public function clear()
	{
		graphData = null;
	}
	
	public function loadFile(fileContent:String)
	{
		clear();
		graphData = _parser.parse(fileContent, graphData);
		
		_linksContainer = document.getElementById("links");
		
		var dropdown:SelectElement = cast document.getElementById("dropdown");
		removeChildrenOf(dropdown);
		for (index in 0...graphData.length)
		{
			var item = graphData[index];
			if (item.path.dir.indexOf("std") != -1) continue;
			
			var option = document.createOptionElement();
			option.textContent = item.className;
			option.value = index + "";
			dropdown.appendChild(option);
		}
		dropdown.onchange = function()
		{
			var item = graphData[Std.parseInt(dropdown.value)];
			showDependendies(item);
		}
		
		if (graphData.length > 0)
		{
			showDependendies(graphData[0]);
		}
	}
	
	private function addDragDrop(element:Element) 
	{
		element.ondragover = function() { element.classList.add('dragover'); return false; };
		element.ondragend = function() { element.classList.remove('dragover'); return false; };
		element.ondrop = function(e) {
		  element.classList.remove('dragover');
		  e.preventDefault();

		  var files:Array<Dynamic> = e.dataTransfer.files;
		  for (file in files)
		  { 
			  var reader = new FileReader();
			  reader.onload = function (event) {
				var text = event.target.result;
				loadFile(text);
			  };
			  console.log(file);
			  reader.readAsText(file);
		  }

		  return false;
		};
	}
	
	private function showDependendies(info:DepInfo) 
	{
		var width = _context.canvas.width;
		var height = _context.canvas.height;

		// clear old stuff
		_context.clearRect(0, 0, width, height);
		removeChildrenOf(_linksContainer);
		
		createDiv(info, width / 2, height / 2, "selected");
		
		_context.beginPath();
		var total = info.dependencies.length;
		for (i in 0 ... total)
		{
			var dep = info.dependencies[i];
			var angle1 = (i / total) * (Math.PI * 2);
			var x1 = width / 2 + Math.sin(angle1) * width/3; 
			var y1 = height / 2 + Math.cos(angle1) * height/4;
			//_context.fillText(dep.className, x, y);
			
			_context.moveTo(width / 2, height / 2);
			_context.lineTo(x1, y1);
			createDiv(dep, x1, y1);
			/*
			var total2 = dep.dependencies.length;
			for (j in 0 ... total2)
			{
				var depdep = dep.dependencies[j];
				if (depdep != info)
				{
					var angle2 = (angle1 + Math.PI) - (j / total2) * (Math.PI * 2);
					
					var x2 = x1 + Math.sin(angle2) * width / 7; 
					var y2 = y1 + Math.cos(angle2) * height / 8;
					
					_context.moveTo(x1, y1);
					_context.lineTo(x2, y2);
					createDiv(depdep, x2, y2);
				}
			}
			*/
		}
		_context.strokeStyle = "1px solid #666";
		_context.stroke();
	}
	
	private function removeChildrenOf(element:Element)
	{
		while (element.children.length != 0) element.children[0].remove();
	}
	
	private function createDiv(dep:DepInfo, x:Float, y:Float, cssClass:String = "")
	{
		var anchor = document.createAnchorElement();
		anchor.innerText = dep.className;
		anchor.className = "dep " + cssClass;
		anchor.href = dep.pathAsString;
		anchor.onclick = function(e) {
			showDependendies(dep);
			e.preventDefault();
		}
		anchor.style.left = '${x}px';
		anchor.style.top = '${y}px';
		_linksContainer.appendChild(anchor);
	}
/*
	function drop_handler(event:DragEvent)
	{
		trace("Dropped file");
		event.preventDefault();
		// If dropped items aren't files, reject them
		var dataTransfer = event.dataTransfer;
		if (dataTransfer.files != null)
		{
			for (index in 0 ... dataTransfer.files.length)
			{
				var file = dataTransfer.files.item(index);
				trace("item.name = " + file.name);
			}
		}
		else
		{
			dataTransfer.clear();
		}
	}
	*/
}