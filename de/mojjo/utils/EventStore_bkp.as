package de.mojjo.utils 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import de.mojjo.utils.UniqueID;
	
	public class EventStore_bkp
	{
		
		private var events:Vector.<Object> = new Vector.<Object>();
		private var eventsGroup:Vector.<Object> = new Vector.<Object>();
		
		private var eventsPaused:Vector.<Object> = new Vector.<Object>();
		private var eventsGroupPaused:Vector.<Object> = new Vector.<Object>();
		
		public function EventStore_bkp() { };
		
		/**
		 * Cria um simples evento que pode ser adicionado a um grupo. Se o grupo e/ou id não existir(em), será(ão) criado(s) automaticamente.
		 * 
		 * @param obj O Objeto que receberá o evento.
		 * @param event O tipo de evento a ser adicionado [ ex.: MouseEvent.CLICK ].
		 * @param func A função que será chamada pelo evento.
		 * @param id Se não for definido, será gerado um id único.
		 * @param group Grupo que o evento irá pertencer. Muito util quando se deseja vários eventos de uma vez.
		 * @param buttonMode Tratar como botão ou não.
		 */
		
		public function addEvent(obj:*, event:*, func:*, group:String = null, id:String = null, buttonMode:Boolean = true):void 
		{
			if (group != null && group != "")
			{
				var hasGroup:Boolean = false;
				
				var eventsGroupLength:int = eventsGroup.length;
				for (var i:int = 0; i < eventsGroupLength; i++)
					if (eventsGroup[i] == group)
					{
						//trace("O grupo [" + group + "] já existe");
						hasGroup = true;
						break;
					}
				
				if (!hasGroup)
					eventsGroup[eventsGroup.length] = group; // Umas 2x mais rápido do que o .push() 
			}
			
			// Vou fazer mais dinâmico, vc passa a variável que quiser tipo o vars do TweenMax.
			
//			if ((event == MouseEvent.CLICK || event == MouseEvent.MOUSE_DOWN || event == MouseEvent.MOUSE_OVER) && buttonMode == true)
//			{
//				if (obj.hasOwnProperty("buttonMode"))
//					obj.buttonMode = true;
//				//if (obj.hasOwnProperty("mouseChildren"))
//					//obj.mouseChildren = false;
//				if (obj.hasOwnProperty("tabEnabled"))
//					obj.tabEnabled = false;
//			}
				
						

			id = (id == null) ? "ev" + events.length.toString() : id;
				
				
			// Verifica se o evento já existe	
			var hasEvent:Boolean = false;	
				
			var eventsLength:int = events.length;
			for (i = 0; i < eventsLength; i++) 
			{
				if(events[i].id == id)
				{
					hasEvent = true;
				}
			}
			
			// Se não existir, adiciona-o
			if(!hasEvent)
			{
				obj.addEventListener(event, func, false, 0, true);
				events[events.length] = { id:id, obj:obj, event:event, func:func, group:group, buttonMode:buttonMode };
			}
			else
			{
				trace('Já existe um evento com esse ID:'+id);
			}
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
				eventHandler(events[i].id);
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
				eventHandler(eventsPaused[i].id, 2);
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
					if (eventsPaused[i].id == id)
					{
						addEvent(eventsPaused[i].obj, eventsPaused[i].event, eventsPaused[i].func, eventsPaused[i].id, eventsPaused[i].group, eventsPaused[i].buttonMode);
						eventsPaused.splice(i, 1);
						break;
					}
			}
			else
			{
				var eventsLength:int = events.length;
				for (i = 0; i < eventsLength; i++) 
					if (events[i].id == id)
					{
						var obj:* = events[i].obj;
						
						if (obj.hasOwnProperty("buttonMode"))
							obj.buttonMode = false;
							
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
							if (eventsPaused[j].group == group)
							{
								// resume o evento
								eventHandler(eventsPaused[j].id, action);
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
							if (events[j].group == group)
							{
								// aplica a ação
								eventHandler(events[j].id, action);
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