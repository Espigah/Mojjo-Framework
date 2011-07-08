package de.mojjo.utils
{
	public class VectorUtils
	{
		public static function vectorToArray (vector:*):Array {
			var n:int = vector.length;
			var a:Array = [];
			for(var i:int = 0; i < n; i++) {
				a[i] = vector[i];
			}
			return a;
		}
		
		
		public static function sortOn (vector:*, fieldName:Object, options:Object = null):Array {
			return vectorToArray(vector).sortOn(fieldName, options);
		}
	}
}