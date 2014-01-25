package com.ggj14.paranoiacrossing.tiledloader {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author shaunmitchell
	 */
	public class TMXTileSheet extends Sprite 
	{
		private var _sheet:Bitmap;
		private var _startID:uint;
		private var _columns:uint;
		private var _rows:uint;
		
		public function TMXTileSheet(startID:uint, sheet:Bitmap):void 
		{
			_sheet = sheet;
			_startID = startID;
			
			_columns = _sheet.width / 32;
			_rows = _sheet.height / 32;
		}

		public function get sheet() : Bitmap 
		{
			return _sheet;
		}

		public function get startID() : uint 
		{
			return _startID;
		}

		public function get columns() : uint {
			return _columns;
		}

		public function get rows() : uint {
			return _rows;
		}
	}
}
