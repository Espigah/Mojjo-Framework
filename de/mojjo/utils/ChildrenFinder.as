/*
	Copyright (c) 2010, Mojjo.de Digital Interactive Ltda
	All rights reserved.
  

	VERSION: 0.21
	DATE: 2010-08-31
*/
package de.mojjo.utils 
{
	public class ChildrenFinder
	{
		
		private static var opened:Array = [];
		private static var closed:Array = [];
		private static var children:Array = [];
		
		
		/**
		 * Procura todos os DisplayObjects a partir do target.
		 * 
		 * @param target Ponto de partida. A Busca partirá dele.
		 * @return Um Vector.<DisplayObject> com todos os objetos.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext 
		 */
		
		
		public static function findChildren(target:*):Array  
		{
			opened[opened.length] = target;
			while (!findAll(opened[0])) { };
			return children;
		}
		
		
		/**
		 * Verifica todos os DisplayObjects a partir do target e retorna os que respeitarem as condições
		 * 
		 * @param target Ponto de partida. A Busca partirá dele.
		 * @param substr Procura objetos que contenham essa string no nome.
		 * @return Um Vector.<DisplayObject> com todos os objetos.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext 
		 */
		
		
		public static function findChildrenBy(target:*, substr:String = ""):Array 
		{
			opened[opened.length] = target;
			while (!findAll(opened[0])) { };
			var selectedChildren:Array = [];
			for (var i:int = 0; i < children.length; i++)
			{
				var child:* = children[i];
				var hasString:int = String(child.name).search(substr);
				if (hasString > -1)
					selectedChildren[selectedChildren.length] = child;
			}
			children.length = 0;
			return selectedChildren;
		}
		
		
		/**
		 * Verifica se o filho tem filhos e se os filhos do filho tem filhos...
		 * 
		 * @param target Ponto de partida. A Busca partirá dele.
		 * @return Um Vector.<DisplayObject> com todos os objetos.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext 
		 */
		
		 
		private static function findAll (target:*):Boolean
		{
			children[children.length] = target;
			if(target.hasOwnProperty("numChildren"))
				for (var i:int = 0; i < target.numChildren; i++)
				{
					opened[opened.length] = target.getChildAt(i);
				}
			closed[closed.length] = opened.shift();
			if (opened.length > 0)
				return false;
			else
			{
				opened.length = 0;
				closed.length = 0;
				return true;
			}
		}
	}
}