package de.mojjoLib.services 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Rilton Lucena
	 */
	public class Uploader extends Sprite
	{
		private var fr:FileReference;
		
		public function Uploader()
		{
		}
		
		public function upload (reference:FileReference, newName:String, urlDestino:String, SScontroller:String):void
		{
			var controller:String = SScontroller; // 'http://metransformoemluar.com.br/amfphp/services/uploader/upload.php';
			var uploadURL:URLRequest = new URLRequest(controller + "?uploadDir=" + escape(urlDestino) +'&newName=' + escape(newName));
			
			this.fr = reference;
			this.fr.upload(uploadURL);
			
			//event handlers
			//this.fr.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
			//this.fr.addEventListener(Event.COMPLETE, this.completeUpload);
			//this.fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityError);
			this.fr.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
			//this.fr.addEventListener(Event.CANCEL, this.cancel);
			//this.fr.addEventListener(ProgressEvent.PROGRESS, this.uploadProgress);
			this.fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.uploadComplete);
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(" [FileUploader] IOError: " + e.text);
			//this.dispatchEvent(new UploadFailedEvent());
		}
		
		private function uploadComplete(e:DataEvent):void 
		{
			trace(" [FileUploader] File Upload DATA Complete");
			this.dispatchEvent(new Event('UPLOADED'));
		}
	}

}