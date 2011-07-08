package de.mojjoLib.database.amf
{
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import de.mojjoLib.events.DatabaseEvent;

	public class AMFPHPBase extends EventDispatcher
	{
		protected var _gateway:String;
		protected var _connection:NetConnection;
		protected var _responder:Responder;

		public function AMFPHPBase (gateway:String)
		{
			_gateway = gateway;
			_connection = new NetConnection();
			_connection.connect (_gateway);
			_responder = new Responder(resultHandler,faultHandler);
		}
		
		public function resultHandler (object:Object):void
		{
			dispatchEvent(new DatabaseEvent(DatabaseEvent.RETURN_TRUE, object));
		}

		public function faultHandler (object:Object):void
		{
			dispatchEvent(new DatabaseEvent(DatabaseEvent.RETURN_FALSE, object));
		}
	}
}