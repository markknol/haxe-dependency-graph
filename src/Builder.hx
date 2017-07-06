package;

/**
 * ...
 * @author Mark Knol
 */
class Builder
{
	public static macro function include(path:String):haxe.macro.Expr.ExprOf<String>
	{
		return macro $v{sys.io.File.getContent(path)};
	}
	
}