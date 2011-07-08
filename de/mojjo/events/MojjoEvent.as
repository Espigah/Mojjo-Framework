package de.mojjo.events
{
	import flash.events.Event;

	public class MojjoEvent extends Event
	{
		public static const VIEW_LOADED:String = "view_loaded";
		public static const VIEW_UNLOADED:String = "view_unloaded";
		public static const VIEW_INITIATED:String = "view_initiated";
		
		private var _viewName:String;
		
		public function get viewName ():String { return _viewName };

		public function MojjoEvent (type:String, viewName:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_viewName = viewName;
			
			super (type, bubbles, cancelable);
		}
	}
}