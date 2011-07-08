/*
	Copyright (c) 2010, Mojjo.de Digital Interactive Ltda
	All rights reserved.
  

	VERSION: 0.8
	CRIATION: 2010-10-30
	MODIFIED: 2010-11-09
*/
package de.mojjo.core
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.core.LoaderItem;
	
	import de.mojjo.core.*;
	import de.mojjo.events.*;
	import de.mojjo.utils.*;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;	
	
	public class ViewController extends Sprite
	{
		private var _eventStore:EventStore;
		private var _functionDispatcher:FunctionDispatcher;
		private var _id:String;
		private var _loader:LoaderMax;
		private var _state:String;
		private var _sWidth:Number;		
		private var _sHeight:Number;
		private var _mainController:MainController;
		private var _viewName:String;
		private var _level:int;
		private var _subLevel:int;
		private var _staticRequirements:String;
		private var _MLOs:Array = [];
		private var _callback:Function;
		private var _cbParams:Array;
		
		/**
		 * 
		 * GETTERS/SETTERS
		 * 
		 */
		
		public function get id ():String { return _id };
		public function set id (value:String):void { _id = value };

		public function get mainController ():MainController { return _mainController };
		public function set mainController (value:MainController):void { _mainController = value };
		
		public function get viewName ():String { return _viewName };
		public function set viewName (value:String):void { _viewName = value };
		
		public function get level ():int { return _level };
		public function set level (value:int):void { _level = value };
		
		public function get subLevel ():int { return _subLevel };
		public function set subLevel (value:int):void { _subLevel = value };
		
		public function get staticRequirements ():String { return _staticRequirements };
		public function set staticRequirements (value:String):void { _staticRequirements = value };
		
		public function get loader ():LoaderMax { return _loader };
		public function set loader (value:LoaderMax):void { _loader = value };
		
		public function get state ():String { return _state };
		
		public function get sWidth ():Number { return _sWidth };
		public function set sWidth (value:Number):void { _sWidth = value };
		
		public function get sHeight ():Number { return _sHeight };
		public function set sHeight (value:Number):void { _sHeight = value };
		
		public function get eventStore ():EventStore { return _eventStore };
		public function set eventStore (value:EventStore):void { _eventStore = value };

		public function get MLOs ():Array { return _MLOs };
		public function set MLOs (value:Array):void { _MLOs = value };
		
		/**
		 * Construtor ::
		 * Cria uma nova classe para controlar uma tela.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function ViewController() 
		{
			_eventStore = new EventStore();
			_functionDispatcher = new FunctionDispatcher(this);
			
			LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader, XMLLoader, CSSLoader, VideoLoader]);
			_loader = new LoaderMax( { onComplete:requirementsLoaded, onProgress:progressHandler } );
		};
		
		/**
		 * Carrega os recursos ESTÁTICOS necessários para a tela.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function loadStaticRequirements():void
		{
			//trace('Static Requirements ' + this);
			_loader.name =_viewName;
			
			if (_staticRequirements != "") 
			{
				var loader:LoaderCore = LoaderMax.parse(_staticRequirements, { onComplete:loadDynamicRequirements, name:'content' + this.loader.numChildren } );
				this.loader.append(loader);
				this.loader.load();
			}
			else
			{
				loadDynamicRequirements(null);
			}
		};
		
		
		/**
		 * Carrega os recursos DINÂMICOS necessários para a tela. Pode ser usado para tratar os recursos ESTÁTICOS carregados.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function loadDynamicRequirements(e:LoaderEvent):void
		{
			//trace('Dynamic Requirements ' + this);
			this.loader.load();
			//dispatchEvent(new MojjoEvent(MojjoEvent.VIEW_LOADED, _viewName));
		};
		
		
		/**
		 * Controla o progresso do loader.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function progressHandler(e:LoaderEvent):void
		{
			//trace(e.target.progress, e.target.status, loader.name);
		};
		
		
		/**
		 * Função chamada quando o requerimentos estáticos e dinâmicos estiverem sido carregados.
		 * Dá um dispatchEvent no MojjoEvent, passando o VIEW_LOADED como evento e o viewName como segundo parâmetro.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		public function requirementsLoaded (e:LoaderEvent):void
		{
			//trace('Complete Requirements ' + this);
			dispatchEvent(new MojjoEvent(MojjoEvent.VIEW_LOADED, _viewName));
		}
		
		
		/**
		 * Inicia a classe controladora. Aqui ela procura seu Main.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function init():void 
		{
			//this.alpha = 0.5;
			_state = 'initiated';
			dispatchEvent(new MojjoEvent(MojjoEvent.VIEW_INITIATED, _viewName));
			//trace('init ' + this);
		};
		
		/**
		 * Inicia os eventos que controlarão a tela. É chamada logo após o init().
		 * Os eventos iniciais, devem ser colocados dentro desta função.
		 * 
		 * É importante que sejam criados e adicionados grupos de eventos ao vetor actionsGroups, assim os eventos serão removidos adequadamente
		 * quando a tela for descarregada.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function initEventListeners():void {	};
		
		/**
		 * Remove todos os eventos da telas. É chamada quando outra tela estiver sendo carregada.
		 * 
		 * É importante que sejam criados e adicionados grupos de eventos ao vetor actionsGroups, assim os eventos serão removidos adequadamente
		 * quando a tela for descarregada.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function endEventListeners():void 
		{
			eventStore.removeAllEvents();
//			for (var j:int = 0; j < _eventsGroups.length; j++)
//				eventStore.removeEventsByGroup(_eventsGroups[j]);
		};
		
		
		/**
		 * Mostra a tela. this.alpha = 1;
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function show():Number 
		{
			return 0;
		}
		
		/**
		 * Esconde a tela. this.alpha = 0;
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function hide():Number 
		{
			return 0;
		}
		
		/**
		 * Remove os eventos, esconde a tela e remove do Main.
		 *
		 * @return Retorna o tempo necessário para remover a tela.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function unload ():Number {
			
			endEventListeners();
			
			var delay:Number = this.hide();
			_functionDispatcher.delayedCall(delay, this.dispose);
			_functionDispatcher.delayedCall(delay, this.dispatchEvent, [new MojjoEvent(MojjoEvent.VIEW_UNLOADED, _viewName)]);
			return delay;
			
		}
		
		/**
		 * Remove os eventos, esconde a tela e remove do Main.
		 *
		 * @return Retorna o tempo necessário para remover a tela.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */
		
		public function resize(sWidth:Number, sHeight:Number):void 
		{
			this.sWidth = sWidth;
			this.sHeight = sHeight;	
		}
		
		/**
		 * DISPOSE.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function dispose ():void {
			
		}
	}
}