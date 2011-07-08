package de.mojjoLib.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Rilton Lucena
	 */
	public class InverseMask 
	{
		
		public static function inverseMask(object:MovieClip):MovieClip
		{
			var _BMP:BitmapData = new BitmapData(stage.stageWidth,stage.stageHeight,true,0xFFFFFFFF)
			var invert:ColorTransform = new ColorTransform(0,0,0,1)
			var matrix:Matrix = new Matrix()
			matrix.translate(object.x,object.y)
			_BMP.draw(object, matrix,invert)
			_BMP.threshold(_BMP,new Rectangle(0,0,_BMP.width,_BMP.height),new Point(0,0),"<",0xFFFFFFFF,0x00FF0000)
			
			var BMP:Bitmap = new Bitmap(_BMP)
			var maskMC:MovieClip = new MovieClip()
			maskMC.addChild(BMP)
			maskMC.cacheAsBitmap = true
			this.addChild(maskMC)
			object.visible = false
			return maskMC;
		}
		
	}

}