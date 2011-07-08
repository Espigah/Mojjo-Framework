package de.mojjo.utils 
{
	import de.mojjo.utils.UniqueID;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EventStore
	{
		
		private var events:Vector.<Object>;
		private var eventsGroup:Vector.<Object>;
		
		private var eventsPaused:Vector.<Object>;
		private var eventsGroupPaused:Vector.<Object>;
		
		public function EventStore()
		{ 
			events = new Vector.<Object>();
			eventsGroup = new Vector.<Object>();
			
			eventsPaused = new Vector.<Object>();
			eventsGroupPaused = new Vector.<Object>();
		};
		
		/**
		 * Cria um simples evento que pode ser adicionado a um grupo. Se o grupo e/ou id não existir(em), será(ão) criado(s) automaticamente.
		 * 
		 * @param obj O Objeto que receberá o evento.
		 * @param event O tipo de evento a ser adicionado [ ex.: MouseEvent.CLICK ].
		 * @param func A função que será chamada pelo evento.
		 * @param vars Objeto contendo variáveis opcionais, como: id, group, buttonMode, tabEnabled, mouseChildren...
		 */
		
		public function addEvent(obj:Object, event:String, func:Function, vars:Object = null):void 
		{
			if (obj == null)
				throw new Error ("Não pode adicionar um evento à um objeto nulo");
			
			var group:String = (vars && vars.group != null && vars.group != "") ? vars.group : "untitledGroup";

			
			var hasGroup:Boolean = false;
			
			var eventsGroupLength:int = eventsGroup.length;
			for (var i:int = 0; i < eventsGroupLength; i++)
				if (eventsGroup[i] == group)
				{
					hasGroup = true;
					break;
				}
			
			if (!hasGroup)
				eventsGroup[eventsGroup.length] = group;

			
		
			var id:String = (vars && vars.id != null) ? vars.id : "ev"+this.events.length.toString();
			
				
			// Verifica se o evento já existe	
			var hasEvent:Boolean = false;	
				
			var eventsLength:int = events.length;
			for (i = 0; i < eventsLength; i++) 
			{
				if(events[i].vars.id == id)
				{				
					hasEvent=true
				}
			}
			
			// Se não existir, adiciona-o
			if(!hasEvent)
			{
				obj.addEventListener(event, func, false, 0, true);
				events[eventsLength] = { obj:obj, event:event, func:func, vars:vars };
				
				for (var n:* in vars)
				{
					if(vars[n] != group && vars[n] != id)
					{
						if(obj.hasOwnProperty(n)) obj[n] = vars[n];
					}
				}
			}
			else
			{
				trace("O evento não pôde ser adicionado, já existe um evento com este ID:" + id);
				//throw new Error ("O evento não pôde ser adicionado, por já existir um evento com este ID:" + id);
			}
		}
		
		
		public function getEvent (id:String, obj:Object = null, event:String = null):Object
		{
			var eventsLen:int = events.length;
			
			if (id)
			{
				for (var i:int = 0; i < eventsLen; i++) 
				{
					if (events[i].id == id)
						return events[i];
				}
			}
			else if (obj && event)
			{
				for (i = 0; i < eventsLen; i++) 
				{
					if (events[i].obj == obj && events[i].event == event)
						return events[i];
				}
			}
			
			return null;
		}
		
		
		// UM
		public function removeEvent (id:String):void { eventHandler(id); };
		
		public function pauseEvent (id:String):void	{ eventHandler(id, 1); };
		
		public function resumeEvent (id:String):void { eventHandler(id, 2);	};	
		
		

		
		// ALGUNS
		public function removeEventsByGroup (group:String):void { groupHandler(group); };
		
		public function pauseEventsByGroup (group:String):void	{ groupHandler(group, 1); };
		
		public function resumeEventsByGroup (group:String):void	{ groupHandler(group, 2); };
		
		
		
		
		// TODOS
		public function removeAllEvents():void 
		{
			var eventsLength:int = events.length - 1;
			for (var i:int = eventsLength; i >= 0; i--) 
				eventHandler(events[i].vars.id);
		}
		
		public function pauseAllEvents():void 
		{
			var eventsGroupLength:int = eventsGroup.length - 1;
			for (var i:int = eventsGroupLength; i >= 0; i--) 
				groupHandler(eventsGroup[i] as String, 1);
		}
		
		public function resumeAllEvents():void 
		{
			var eventsPausedLength:int = eventsPaused.length  - 1;
			for (var i:int = eventsPausedLength; i >= 0; i--) 
			{
				eventHandler(eventsPaused[i].vars.id, 2);
			}
			eventsGroupPaused.length = 0;
		}
		
		
		
		
		
		/**
		 * ...
		 * @param id O id definido quando o evento foi adicionado
		 * @param action Use 0 - remove / 1 - pause / 2 - resume
		 */
		 
		private function eventHandler (id:String, action:int = 0):void
		{
			if (action == 2)
			{
				var eventsPausedLength:int = eventsPaused.length;
				for (var i:int = 0; i < eventsPausedLength; i++) 
					if (eventsPaused[i].vars.id == id)
					{
						addEvent(eventsPaused[i].obj, eventsPaused[i].event, eventsPaused[i].func, eventsPaused[i].vars);
						eventsPaused.splice(i, 1);
						break;
					}
			}
			else
			{
				var eventsLength:int = events.length;
				for (i = 0; i < eventsLength; i++) 
					if (events[i].vars.id == id)
					{
						var obj:* = events[i].obj;
						
						// removendo propriedades, normalmente ( tabEnabled, buttonMode e mouseChildren )
						// deixei tudo false, se precisar de um valor diferente, terá que fazer manualmente após a remoção do evento.
						
						//var _vars:Object = events[i].vars;
						//for (var n:* in _vars)
						//{
							//if(_vars[n] != _vars.group && _vars[n] != _vars.id)
							//{
								//if(obj.hasOwnProperty(n)) obj[n] = false;
							//}
						//}
							
						if (action == 1)
								eventsPaused[eventsPaused.length] = events[i];
							
						obj.removeEventListener(events[i].event, events[i].func);
						events.splice(i, 1);
						break;
					}
			}
		}
		
		
		
		/**
		 * ...
		 * @param group Nome do grupo
		 * @param action Use 0 - remove / 1 - pause / 2 - resume
		 */
		 
		private function groupHandler (group:String, action:int = 0):void
		{
			// resumir
			if (action == 2)
			{
				// verificar todos os grupos
				var eventsGroupPausedLength:int = eventsGroupPaused.length;
				for (var i:int = 0; i < eventsGroupPausedLength; i++)
				{
					// se encontrar o grupo em questão
					if (eventsGroupPaused[i] == group)
					{
						// procura todos os eventos pausados relativos a ele
						var eventsPausedLength:int = eventsPaused.length - 1;
						for (var j:int = eventsPausedLength; j >= 0; j--) 
						{
							// se o evento for do grupo
							if (eventsPaused[j].vars.group == group)
							{
								// resume o evento
								eventHandler(eventsPaused[j].vars.id, action);
							}
						}
					}
				}
			}
			else
			{
				// talvez precise ser usada depois
				var hasGroup:Boolean = false;
				// verifica cada grupo de eventos
				var eventsGroupLength:int = eventsGroup.length;
				for (i = 0; i < eventsGroupLength; i++) 
				{
					// se encontrar o grupo em questão
					if (eventsGroup[i] == group)
					{
						// verifica todos os eventos
						var eventsLength:int = events.length - 1;
						for (j = eventsLength; j >= 0; j--) 
						{
							// para os eventos relativos ao grupo
							if (events[j].vars.group == group)
							{
								// aplica a ação
								eventHandler(events[j].vars.id, action);
							}
						}
						
						// se a ação for pausar, adiciona o grupo ao grupo dos pausados
						if (action == 1)
							eventsGroupPaused[eventsGroupPaused.length] = eventsGroup[i];
						// remove o grupo dos grupo de eventos ativos
						eventsGroup.splice(i, 1);
						// mostra que o grupo foi encontrado
						hasGroup = true;
						break;
					}
				}
			}
		}
	}

}