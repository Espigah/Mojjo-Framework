package de.mojjoLib.text
{
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.events.TimerEvent;
 
	/**
	*   A text field that supports marqueeing
	*   @author Jackson Dunstan
	*/
	public class MarqueeTextField extends TextField
	{
		/** Timer that ticks every time the marquee should be updated */
		private var __marqueeTimer:Timer;
 
		/**
		*   Make the text field
		*/
		public function MarqueeTextField()
		{
			__marqueeTimer = new Timer(0);
			__marqueeTimer.addEventListener(TimerEvent.TIMER, onMarqueeTick);
		}
 
		/**
		*   Callback for when the marquee timer has ticked
		*   @param ev TIMER event
		*/
		private function onMarqueeTick(ev:TimerEvent): void
		{
			this.text = this.text.substr(1) + this.text.charAt(0);
		}
 
		/**
		*   Start marqueeing
		*   @param delay Number of milliseconds between wrapping the first
		*                character to the end or negative to stop marqueeing
		*/
		public function marquee(delay:int): void
		{
			__marqueeTimer.stop();
			if (delay >= 0)
			{
				__marqueeTimer.delay = delay;
				__marqueeTimer.start();
			}
		}
	}
}