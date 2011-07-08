package de.mojjoLib.services
{
	/**
	* @author Christian Kaegi - www.flashcmsframework.com / www.turtlebite.com / www.kaegi.net
	*/
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.*;
	//
	public class VarLoader extends Sprite
	{
		private var __url:String;
		private var request:URLRequest;
		private var __sendVarsObj:Object;
		private var _errormsg:String;
		private var sendVars:URLVariables;
		private var loader:URLLoader;
		private var receiveVars:URLVariables;
		//
		public function VarLoader(url:String, vars:Object=null ) 
		{
			__url = url;
			__sendVarsObj = vars;
			init();
			sendAndLoad();
		}
		private function init():void {
			request = new URLRequest(__url);
			loader = new URLLoader  ;
			loader.addEventListener(Event.COMPLETE,onComplete);
			if (__sendVarsObj != null) {
				sendVars = new URLVariables;
				for (var n:* in __sendVarsObj) { 
					sendVars[n] = __sendVarsObj[n];
				}
				request.data = sendVars;
			}
			request.method = URLRequestMethod.POST;
			receiveVars = new URLVariables;
		}
		private function sendAndLoad():void {
			loader.load(request);
		}
		private function onComplete(e:Event):void {
			//trace(e.currentTarget.data);
			try {
				receiveVars.decode(e.currentTarget.data);
				dispatchEvent(new Event(Event.COMPLETE));
			} catch (error:*) {
				_errormsg = error;
				_errormsg += "\n\nPlease note: it could also be that there was an error parsing the PHP script!";
				dispatchEvent(new Event(Event.CANCEL));
			}
		}
		public function get vars():URLVariables {
			return receiveVars;
		}
		public function get errormsg():String {
			return _errormsg;
		}
	}
}