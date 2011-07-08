package de.mojjo.utils
{
	public class UniqueID
	{
		public static function getID():String
		{
			var d:Date = new Date();
			
			return d.getFullYear() + d.getMonth() + 1 + '' + d.getDate() + '' + d.getHours() + '' + d.getMinutes() + ''  + d.getMilliseconds();
		}
	}
}