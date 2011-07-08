package de.mojjo.utils
{
	import de.mojjo.events.*;
	import de.mojjo.utils.EventStore;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class FunctionDispatcher
	{
		private var _eventStore:EventStore = new EventStore();
		private var _delayedCalls:Vector.<Object> = new Vector.<Object>();
		
		private var _dispatcher:*;
		
		public function FunctionDispatcher (dispatcher:*)
		{
			this._dispatcher = dispatcher;
		}
		
		public function delayedCall (delay:Number, callback:Function, cbParams:Array = null):void
		{
			var _timer:Timer = new Timer(delay * 1000);
			
			_delayedCalls.push( { timer:_timer, callback:callback, cbParams:cbParams } );
			
			_eventStore.addEvent(_timer, TimerEvent.TIMER, delayComplete, {id:'delayedCall' + _delayedCalls.length, group:'timer', callId:_delayedCalls.length});
			_timer.start();
		}
		
		
		private function delayComplete (e:TimerEvent):void
		{
			e.currentTarget.stop();
			_eventStore.removeEvent('delayedCall' + _eventStore.getEvent(null, e.currentTarget, TimerEvent.TIMER).vars.callId);
			
			for (var i:int = 0; i < _delayedCalls.length; i++) 
			{
				if (_delayedCalls[i].timer == e.currentTarget)
				{
					_delayedCalls[i].callback.apply(this, _delayedCalls[i].cbParams);
					_delayedCalls.splice(i, 1);
				}
			}			
		}
		
	}
}