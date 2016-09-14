package classes.antidoto
{
	public class regToString
	{
		public function regToString(){}
		
		public static function propToLabel(prop : String) : String
		{
			return prop .replace(/[_]+([a-zA-Z0-9]+)|([0-9]+)/g, " $1$2 ")
				.replace(/(?<=[a-z0-9])([A-Z])|(?<=[a-z])([0-9])/g, " $1$2")
				.replace(/^(\w)|\s+(\w)|\.+(\w)/g, capitalise)
				.replace(/^\s|\s$|(?<=\s)\s+/g, '');
		}
		
		private static function capitalise(...args) : String
		{
			return String(' ' + args[1] + args[2] + args[3]).toUpperCase();
		}
	}
}