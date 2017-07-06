package;

import js.Lib;
import js.Browser.*;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import Parser;
import js.html.Element;
import js.html.SelectElement;
/**
 * ...
 * @author Mark Knol
 */
class Main
{
	static function main() new Main();
	
	private var _context:CanvasRenderingContext2D;
	private var _container:Element;

	public function new()
	{
		var parser = new Parser();
		var graphData = parser.parse(Builder.include("bin/game/.dependencies.dump"));
		
		var canvas:CanvasElement = cast document.getElementById("canvas");
		_context = canvas.getContext2d();
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;
		_container = document.getElementById("links");
		
		var dropdown:SelectElement = cast document.getElementById("dropdown");
		for (index in 0...graphData.length)
		{
			var item = graphData[index];
			if (item.path.dir.indexOf("std") != -1) continue;
			
			var option = document.createOptionElement();
			option.textContent = item.className;
			dropdown.appendChild(option);
		}
		dropdown.onchange = function()
		{
			var item = graphData[dropdown.selectedIndex];
			showDependendies(item);
		}
		
	}
	
	private function showDependendies(info:DepInfo) 
	{
		var width = _context.canvas.width;
		var height = _context.canvas.height;

		// clear old stuff
		_context.clearRect(0, 0, width, height);
		while (_container.children.length != 0 ) _container.children[0].remove();
		
		createDiv(info, width / 2, height / 2, "selected");
		
		_context.beginPath();
		var total = info.dependencies.length;
		for (i in 0 ... total)
		{
			var dep = info.dependencies[i];
			var angle = (i / total) * (Math.PI * 2);
			var x1 = width / 2 + Math.sin(angle) * width/3; 
			var y1 = height / 2 + Math.cos(angle) * height/4;
			//_context.fillText(dep.className, x, y);
			
			_context.moveTo(width / 2, height / 2);
			_context.lineTo(x1, y1);
			createDiv(dep, x1, y1);
			
			var total = dep.dependencies.length-1;
			for (j in 0 ... total)
			{
				var depdep = dep.dependencies[j];
				if (depdep != info)
				{
					var angle = (j / total) * (Math.PI * 2);
					
					var x2 = x1 + Math.sin(angle) * width / 7; 
					var y2 = y1 + Math.cos(angle) * height / 8;
					
					_context.moveTo(x1, y1);
					_context.lineTo(x2, y2);
					createDiv(depdep, x2, y2);
				}
			}
			
		}
		_context.strokeStyle = "1px solid #666";
		_context.stroke();
	}
	
	private function createDiv(dep:DepInfo, x:Float, y:Float, cssClass:String = "")
	{
		var div = document.createAnchorElement();
		div.innerText = dep.className;
		div.className = "dep " + cssClass;
		div.style.left = '${x}px';
		div.style.top = '${y}px';
		_container.appendChild(div);
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