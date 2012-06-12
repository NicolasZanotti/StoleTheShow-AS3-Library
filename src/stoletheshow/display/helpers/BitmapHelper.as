package stoletheshow.display.helpers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Nicolas Zanotti
	 */
	public class BitmapHelper
	{
		public function BitmapHelper()
		{
		}

		public function getAssetAsBitmap(name:String):Bitmap
		{
			return new Bitmap(new (getDefinitionByName(name) as Class)(0, 0) as BitmapData, PixelSnapping.NEVER, true);
		}

		public function doubleBitmapWidth(bmp:Bitmap):Bitmap
		{
			var w:Number = bmp.width;
			var h:Number = bmp.height;
			var double:BitmapData = new BitmapData(w * 2, h, true);
			var rect:Rectangle = new Rectangle(0, 0, w, h);

			double.copyPixels(bmp.bitmapData, rect, new Point(0, 0));
			double.copyPixels(bmp.bitmapData, rect, new Point(w, 0));

			return new Bitmap(double, bmp.pixelSnapping, bmp.smoothing);
		}

		public function scale(factor:Number, original:BitmapData):BitmapData
		{
			var newWidth:Number = original.width * factor;
			var newHeight:Number = original.height * factor;
			var scaledBitmapData:BitmapData = new BitmapData(newWidth, newHeight, original.transparent, 0xFFFFFFFF);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(factor, factor);
			scaledBitmapData.draw(original, scaleMatrix);
			return scaledBitmapData;
		}

		public function convertToByteArray(bmp:Bitmap):ByteArray
		{
			var rect:Rectangle = new Rectangle(0, 0, bmp.width, bmp.height);
			var bytes:ByteArray = bmp.bitmapData.getPixels(rect);
			bytes.position = 0;
			return bytes;
		}

		public function convertToBitmapData(bytes:ByteArray, rect:Rectangle):BitmapData
		{
			var bmp:BitmapData = new BitmapData(rect.width, rect.height);
			bmp.setPixels(rect, bytes);
			return bmp;
		}

		public function resizeToFit(bmp:Bitmap, width:Number, height:Number, proportional:Boolean = true):void
		{
			if (proportional)
			{
				if (bmp.width < bmp.height)
				{
					bmp.width = width;
					bmp.scaleY = bmp.scaleX;
				}
				else
				{
					bmp.height = height;
					bmp.scaleX = bmp.scaleY;
				}
			}
			else
			{
				if (width < height)
				{
					bmp.width = width;
					bmp.height = height * bmp.width / width;
				}
				else
				{
					bmp.height = height;
					bmp.width = width * bmp.height / height;
				}
			}
		}
	}
}
