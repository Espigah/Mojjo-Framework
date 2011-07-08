/*
	Copyright (c) 2010, Mojjo.de Digital Interactive Ltda
	All rights reserved.
  

	VERSION: 0.21
	DATE: 2010-10-30

	
	Implementações:

	- add/remover views
	- detecta resize
	- controle de níveis
	- remove automaticamente eventos adicionados com eventStore e armazenados no GroupEvents
	- controle de flush para todos os loaders do mainLoader;

	
	SUBTITLES

	MLO : Multi Language Object
	UFO : Updates Frequently Object
*/
package de.mojjo.core
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	
	import de.mojjo.core.*;
	import de.mojjo.events.MojjoEvent;
	import de.mojjo.utils.EventStore;
	import de.mojjo.utils.VectorUtils;
	import de.mojjo.utils.UniqueID;
	import de.mojjo.utils.FunctionDispatcher;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.system.System;
	
	import net.hires.debug.Stats;

	public class MainController extends Sprite
	{
		// debug
		
		private var _containerViews:Sprite;
		private var _views:Vector.<ViewController>;
		private var _viewsInTransition:Vector.<Object>;
		private var _mainLoader:LoaderMax;
		private var _eventStore:EventStore;
		
		public var configuration:MainConfiguration;
		public var sWidth:Number;
		public var sHeight:Number;
		
		
		public function get containerViews ():Sprite { return _containerViews };
		public function get mainLoader ():LoaderMax { return _mainLoader };
		public function get views ():Vector.<ViewController> { return _views };
		
		
		// Corrigir transição/arrangeLevels e tornar o FunctionDispatcher.delayedCall static
		private var fD:FunctionDispatcher = new FunctionDispatcher(this);
		
		/**
		 * Constructor for Main class
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */		
		
		public function MainController():void 
		{
			_containerViews = new Sprite();
			_views = new Vector.<ViewController>;
			_viewsInTransition = new Vector.<Object>;
			_mainLoader = new LoaderMax({ name:"mainLoader" });
			_eventStore = new EventStore();
			
			
			if (stage)initStage();
			else _eventStore.addEvent(this, Event.ADDED_TO_STAGE, initStage, {id:'initStage', group:'stage'});
		}
		
		
		private function initStage(e:Event = null):void 
		{
			this.configuration = MainConfiguration.getInstance();
			this.configuration.mainController = this;
			
			addChild(_containerViews);
			
			_eventStore.removeEvent('initStage');
		}
		
		
		
		public function init(initView:String):void 
		{
			this.sWidth = stage.stageWidth;
			this.sHeight = stage.stageHeight;
			
			//stage.quality = configuration.stageQuality;
			stage.align = configuration.stageAlign;
			stage.scaleMode = configuration.scaleMode;
			//stage.displayState = configuration.stageDisplayState;
			
			stage.addEventListener(Event.RESIZE, resize);
			
			if (configuration.debugMode)
			{
				var _stats:Stats = new Stats();
				addChild(_stats);
			}
			
			this.loadView(initView);
		}
		
		private function resize(e:Event):void 
		{
			this.sWidth = stage.stageWidth;
			this.sHeight = stage.stageHeight;
			
			for (var i:int = 0; i < _views.length; i++) 
			{
				_views[i].resize(sWidth, sHeight);
			}
		}
		
		
		
		/**
		 * Inicia o carregamento de uma nova Tela.
		 *
		 * @param viewToLoad O objeto contendo as informações da tela a ser carregada.
		 * @param viewToUnload (Opcional) O objeto contendo as informações da tela a ser carregada descarregada.
		 * A próxima tela só será carregada quando esta tela estiver devidamente removida. 
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext 
		 */	
		
		public function loadView(viewToLoad:String, viewToUnload:String = ""):void 
		{	
			var tmpView:ViewController = configuration.getViewByName(viewToLoad);
			var tmpID1:String = tmpView ? tmpView.id : null;
			
			var id1:String = tmpID1 ? tmpID1 : UniqueID.getID();
			var id2:String = (viewToUnload != "") ? configuration.getViewByName(viewToUnload).id : null;
			
			_viewsInTransition.push( { id1:id1, id2:id2 } );
			
			var viewController:ViewController = configuration.getViewByName(viewToLoad);
			viewController.id = id1;
			_views.push(viewController);
			
			_containerViews.addChild(viewController);
			
			_eventStore.addEvent(viewController, MojjoEvent.VIEW_LOADED, viewLoaded, {id: viewToLoad + 'loadView', group:'main'} );
			viewController.loadStaticRequirements();
			
		}
		
		
		private function viewLoaded(e:MojjoEvent):void 
		{
			_eventStore.removeEvent(e.viewName + 'loadView');
			
			var viewController:ViewController = configuration.getViewByName(e.viewName);
			var hasUnload:Boolean = false;

			for (var i:int = 0; i < _viewsInTransition.length; i++)
			{
				if (_viewsInTransition[i].id2 && _viewsInTransition[i].id1 == viewController.id)
				{
					hasUnload = true;
					unloadView(configuration.getViewByID(_viewsInTransition[i].id2).viewName);
					break;
				}
			}
			
			if (!hasUnload) 
			{
				for (i = 0; i < _viewsInTransition.length; i++) 
				{
					if(_viewsInTransition[i].id1 == viewController.id) 
					{
						this._viewsInTransition.splice(i, 1);
					}
				}
			
				initView(viewController);
			}
			
		}
		 
		
		
		public function unloadView(viewName:String):void {
			
			var viewController:ViewController = configuration.getViewByName(viewName);
			_eventStore.addEvent(viewController, MojjoEvent.VIEW_UNLOADED, viewUnloaded, { id:viewName + 'unloadView', group:'main'} );
			viewController.unload();
		}
		
		
		
		
		private function viewUnloaded (e:MojjoEvent):void{
			
			_eventStore.removeEvent(e.viewName + 'unloadView');	
			
			var viewToInit:ViewController;
			
			for (var i:int = 0; i < _viewsInTransition.length; i++) 
			{
				if(_viewsInTransition[i].id2 == configuration.getViewByName(e.viewName).id) 
				{
					viewToInit = this.configuration.getViewByID(_viewsInTransition[i].id1);
					this._viewsInTransition.splice(i, 1);
				}
			}

			removeView(this.configuration.getViewByName(e.viewName));
			
			if(viewToInit) this.initView(viewToInit);
		}
		
		
		
		private function initView(viewController:ViewController):void {
			
			arrangeLevels();
			
			_eventStore.addEvent(viewController, MojjoEvent.VIEW_INITIATED, viewInitiated, { id:'viewInitiated', group:'main' } );
			
			if(this.configuration.flushContent){
				viewController.init();
			}else if(viewController.state != 'initiated'){
				viewController.init();
			}
			else
			{
				_eventStore.removeEvent('viewInitiated');
				
				viewController.visible = true;
				
				resize(null);
				viewController.show();
				viewController.initEventListeners();
			}
				

		}
		
		
		private function viewInitiated (e:MojjoEvent):void
		{
			_eventStore.removeEvent('viewInitiated');
			
			var viewController:ViewController = e.currentTarget as ViewController;
			
			viewController.visible = true;
			
			resize(null);
			viewController.show();
			viewController.initEventListeners();
		}
		
		
		private function removeView (viewController:ViewController):void {
			
			for (var i:int = 0; i < _views.length; i++) 
			{
				if (_views[i] == viewController)
				{
					var loader:LoaderMax = _views[i].loader;
					
					_views.splice(i, 1);
					this.containerViews.removeChild(viewController);
					
					loader.empty(true, this.configuration.flushContent);
					
					viewController.visible = false;
				}
			}
		}
		
		
		
		private function arrangeLevels ():Boolean {
			
			var higherLevel:int = this.getHigherVectorValue(_views, 'level');
			
			for(var i:int = 0; i < _views.length; i++){
				if(_views[i].level < 0) _views[i].level = higherLevel + 1;	
			}
			
			var vectorSorted:Array = VectorUtils.sortOn(_views, "level", Array.NUMERIC);
			var indexed:Vector.<ViewController> = new Vector.<ViewController>();
			var currLevel:int = 0;
			
			for(i = 0; i < vectorSorted.length; i++){
				var childrenLevel:Vector.<ViewController> = new Vector.<ViewController>();
				
				for(var j:int = 0; j < vectorSorted.length; j++){
					
					if(vectorSorted[j].level == vectorSorted[i].level){
						var hasIndex:Boolean = false;
						
						for(var l:int = 0; l < indexed.length; l++){
							if(vectorSorted[j].viewName == indexed[l].viewName) hasIndex = true;
						}
						
						if(!hasIndex){
							if(vectorSorted[j].subLevel < 0){
								vectorSorted[j].subLevel = this.getHigherVectorValue(childrenLevel, 'subLevel') + 1; 
							}
							childrenLevel.push(vectorSorted[j]);
							indexed.push(vectorSorted[j])
						}
					}					
				}
				
				var childrenLevelSorted:Array = VectorUtils.sortOn(childrenLevel, "subLevel", Array.NUMERIC);
				
				for (l = 0; l < childrenLevelSorted.length; l++) {
					_containerViews.setChildIndex(childrenLevelSorted[l], currLevel);
					currLevel++;
				} 
			}
			
			return true;
		}
		
		
		private function getHigherVectorValue (vector:Vector.<ViewController>, numericProperty:String):Number{
			
			var higher:Number = 0;
			
			for (var i:int = 0; i < vector.length; i++){
				if (vector[i][numericProperty] > higher) higher = vector[i][numericProperty];
			}
			
			return higher;
		}
	}
	
}