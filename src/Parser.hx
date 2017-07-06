package;
import haxe.io.Path;

using StringTools;

/**
 * Parses dependency files
 * 
 * @author Mark Knol
 */
class Parser
{
	public function new()
	{

	}

	public function parse(dumpFile:String, ?infos:Array<DepInfo>):Array<DepInfo>
	{
		// find correct line endings
		var lineEnd = (dumpFile.indexOf("\r\n") != -1) ? "\r\n" : (dumpFile.indexOf("\n") != -1 ? "\n" : "\r");

		// split on line end
		var list = dumpFile.split(lineEnd);
		list.pop(); // last line is empty in file, dunno know why
		if (infos == null) infos = [];
		var isRelation = false;
		for (fileName in list)
		{
			isRelation = false;
			if (fileName.endsWith(":"))
			{
				fileName = fileName.substr(0, fileName.lastIndexOf(":"));
			}
			else
			{
				isRelation = true;
				fileName = fileName.replace("\t", "");
			}

			var path = new Path(fileName);
			var pathAsString = path.toString();
			var existingInfo = Lambda.find(infos, function(i) return i.pathAsString == pathAsString);
			if (existingInfo != null)
			{
				infos[infos.length - 1].dependencies.push(existingInfo);
				existingInfo.dependants.push(infos[infos.length - 1]);
			}
			else
			{
				var info = new DepInfo(path, infos.length);
				if (isRelation)
				{
					infos[infos.length - 1].dependencies.push(info);
					info.dependants.push(infos[infos.length - 1]);
				}
				else
				{
					infos.push(info);
				}
			}
		}
		return infos;
	}
}

class DepInfo
{
	public var id:Int; // unique?
	public var path:Path;
	public var pathAsString:String;
	
	public var className:String;
	public var dependencies:Array<DepInfo> = [];
	public var dependants:Array<DepInfo> = [];

	public function new(path:Path, id:Int)
	{
		this.path = path;
		pathAsString = path.toString(); // optimization;
		
		this.id = id;

		this.className = path.file;
	}
}