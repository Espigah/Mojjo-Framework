package de.mojjoLib.utils 
{
	public class RemoveAccents 
	{
		public static var P_ACCENTS:Array = new Array(
		{ pattern:/[äáàâãª]/g,  char:'a' },
		{ pattern:/[ÄÁÀÂÃ]/g,  char:'A' },
		{ pattern:/[ëéèê]/g,   char:'e' },
		{ pattern:/[ËÉÈÊ]/g,   char:'E' },
		{ pattern:/[íîïì]/g,   char:'i' },
		{ pattern:/[ÍÎÏÌ]/g,   char:'I' },
		{ pattern:/[öóòôõº]/g,  char:'o' },
		{ pattern:/[ÖÓÒÔÕ]/g,  char:'O' },
		{ pattern:/[üúùû]/g,   char:'u' },
		{ pattern:/[ÜÚÙÛ]/g,   char:'U' },
		{ pattern:/[ç]/g,   char:'c' },
		{ pattern:/[Ç]/g,   char:'C' },
		{ pattern:/[ñ]/g,   char:'n' },
		{ pattern:/[Ñ]/g,   char:'N' }
		);
		
		public static var P_SPECIAL_CHARS:Array = new Array(
		{ pattern:/[äáàâãª]/g,  char:'a' },
		{ pattern:/[ÄÁÀÂÃ]/g,  char:'A' },
		{ pattern:/[ëéèê]/g,   char:'e' },
		{ pattern:/[ËÉÈÊ]/g,   char:'E' },
		{ pattern:/[íîïì]/g,   char:'i' },
		{ pattern:/[ÍÎÏÌ]/g,   char:'I' },
		{ pattern:/[öóòôõº]/g,  char:'o' },
		{ pattern:/[ÖÓÒÔÕ]/g,  char:'O' },
		{ pattern:/[üúùû]/g,   char:'u' },
		{ pattern:/[ÜÚÙÛ]/g,   char:'U' },
		{ pattern:/[ç]/g,   char:'c' },
		{ pattern:/[Ç]/g,   char:'C' },
		{ pattern:/[ñ]/g,   char:'n' },
		{ pattern:/[Ñ]/g,   char:'N' },
		{ pattern:/[-]/g,   char:'_' }
		);

		public static function removeFrom(str:String, pattern:Array):String
		{
			if (pattern == null) pattern = P_ACCENTS;
			
			for( var i:uint = 0; i < pattern.length; i++ ){
			  str = str.replace( pattern[i].pattern, pattern[i].char );
			}
			return str;
		}
		
	}

}