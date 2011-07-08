/*
	Copyright (c) 2010, Mojjo.de Digital Interactive Ltda
	All rights reserved.
  

	VERSION: 0.21
	DATE: 2010-10-30
*/
package de.mojjo.core {
	
	import com.greensock.loading.*;
	
	import de.mojjo.utils.UniqueID;
	
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	public class MainConfiguration {
		
		
		/** @private **/
		protected static var _instance:MainConfiguration;
		
		/**
		 * Retorna uma instância global do MainConfiguration.
		 **/
		public static function getInstance():MainConfiguration {
			return _instance ? _instance : _instance = new MainConfiguration();
		}
		
		
		
		
		
		
		
		public var mainController:MainController;
		
		public var views:Vector.<ViewController> = new Vector.<ViewController>();
		
		public var stageAlign:String = "";
		
		public var scaleMode:String = StageScaleMode.SHOW_ALL;
		
		public var stageDisplayState:String = StageDisplayState.NORMAL;
		
		public var stageQuality:String = StageQuality.HIGH;
		
		public var debugMode:Boolean = false;
		
		
		/**
		 * Habilita/Desabilita o Flush de conteúdo. 
		 * Se for false, a função init das ViewControllers só será chamada uma vez. 
		 * Se for true, a função init será chamada sempre que a função loadView for requisitada.
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public var flushContent:Boolean = false;
		

		
		/**
		 * Constructor for MainConfiguration class
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */	
		
		public function MainConfiguration ():void {};
		
		
		
		
		public function addView (controller:ViewController, vars:Object = null):void {
			
			controller.viewName = (vars.name) ? String(vars.name) : "vc_" + UniqueID.getID();
			controller.level = (vars.level >= 0) ? int(vars.level) : -1;
			controller.subLevel = (vars.subLevel >= 0) ? int(vars.subLevel) : -1;
			controller.staticRequirements = (vars.staticRequirements) ? String(vars.staticRequirements) : "";
			controller.mainController = mainController;
			
			views.push(controller);
		}
		
		
		public function getViewByName (viewName:String):ViewController {
			
			for (var i:int = 0; i < views.length; i++) 
			{
				if (views[i].viewName == viewName)
				{
					return views[i];
				}
			}
			throw new Error('ViewController [' + viewName + '] não encontrada.');
			return null;
		}
		
		
		public function getViewByID (id:String):ViewController {
			
			for (var i:int = 0; i < views.length; i++) 
			{
				if (views[i].id == id)
				{
					return views[i];
				}
			}
			return null;
		}
	}
}