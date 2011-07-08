package de.mojjoLib.events 
{
	import flash.events.Event;
	
	public class DatabaseEvent extends Event
	{
		private var _dataReturned:Object;
		
		public static const RETURN_TRUE:String = "return_true";
		public static const RETURN_FALSE:String = "return_false";
		
		public function get data ():Object { return _dataReturned };

		
		public function DatabaseEvent (type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_dataReturned = data;
			
			super (type, bubbles, cancelable);
		}
		
	}

}