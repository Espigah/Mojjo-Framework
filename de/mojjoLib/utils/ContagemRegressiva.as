package
{

import flash.utils.Timer;
import flash.events.TimerEvent;

	public class ContagemRegressiva
	{
		private var inicio:Date; //new Date(2011, 4, 24, 12, 0, 0, 0 );
		private var fim:Date; //new Date(2011, 5, 15, 23, 59, 59, 0 );

		private var totalSegundos:Number;
		private var totalMinutos:Number ;
		private var totalHoras:Number ;
		private var totalDias:Number;
		private var timer:Timer;
		private var data:Date;

		private var diasBase:Number;
		private var dias:Number;
		private var horasBase:Number;
		private var horas:Number;
		private var minutosBase:Number;
		private var minutos:Number;
		private var segundosBase:Number;
		private var segundos

		public function ContagemRegressiva (inicio:Date, fim:Date)
		{
			inicio = inicio;
			fim = fim;
			
			totalSegundos = Math.floor(((fim.time - inicio.time) / 1000));
			totalMinutos = Math.floor(totalSegundos / 60 );
			totalHoras = Math.floor(totalMinutos / 60 );
			totalDias = Math.floor(totalHoras / 24);
			timer = new Timer(1000);
			
			timer.addEventListener(TimerEvent.TIMER, timerEvent);
			timer.start();
		}
		

		private function timerEvent (e:TimerEvent):Array
		{
			data = new Date();
			
			// Progressiva
			segundosBase = Math.round(((data.getTime() - inicio.time) / 1000));
			segundos = Math.round(segundosBase % 60);
			minutosBase = Math.floor(segundosBase / 60);
			minutos = Math.floor(minutosBase % 60);
			horasBase =  Math.floor(minutosBase / 60);
			horas =  Math.floor(horasBase % 24);
			diasBase =  Math.floor(horasBase / 24);
			dias =  Math.floor(diasBase % 24);
			
			// Regressiva
			var regDias:Number = totalDias - dias;
			var regHoras:Number = totalHoras < 24 ? ( totalHoras - horas) : ( 24 - horas);
			var regMinutos:Number = (totalMinutos - minutosBase) < 60 ? totalMinutos - minutosBase : ( 60 - minutos ) == 60 ? 0 : ( 60 - minutos );
			var regSegundos:Number = (totalSegundos - segundosBase) < 60 ? totalSegundos - segundosBase : ( 60 - segundos ) == 60 ? 0 : ( 60 - segundos );
			
			
			// Colocando 00
			var sDias:String = regDias < 10 ? '0'+regDias.toString() : regDias.toString();
			var sHoras:String = regHoras < 10 ? '0'+regHoras.toString() : regHoras.toString();
			var sMinutos:String = regMinutos < 10 ? '0'+regMinutos.toString() : regMinutos.toString();
			var sSegundos:String = regSegundos < 10 ? '0'+regSegundos.toString() : regSegundos.toString();
			
			
			if(sDias == "00" && sHoras == "00" && sMinutos == "00" && sSegundos == "00")
			{
				timer.removeEventListener(TimerEvent.TIMER, timerEvent);
				timer.stop();
				timer.reset();
			}
			
			return new Array(sDias, sHoras, sMinutos, sSegundos);
		}
	}
}