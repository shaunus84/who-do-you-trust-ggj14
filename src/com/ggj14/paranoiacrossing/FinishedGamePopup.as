package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;

	import flash.events.MouseEvent;

	import com.shaunus84.assets.ggj14.winnerpopup.WinnerBackground;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author jamie
	 */
	public class FinishedGamePopup extends Sprite {
		private var _background : WinnerBackground;
		private var _headerFont : Font043B0Regular = new Font043B0Regular();
		protected var _container : Sprite = new Sprite();
		protected static const SPRITE_WIDTH : int = 55;
		protected static const SPRITE_HEIGHT : int = 55;
		public static const TITLE : String = "TITLE";
		public static const CONTAINER : String = "CONTAINER";

		public function FinishedGamePopup() : void {
			initWinnersPopup();
		}

		private function initWinnersPopup() : void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_background = new WinnerBackground();
			_background.restartButton.addEventListener(MouseEvent.CLICK, onRestart);
			addChild(_background);
			addChild(_container);
		}

		private function onRestart(event : MouseEvent) : void {
			dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.RESTART_GAME));
		}

		private function onAddedToStage(event : Event) : void {
			this.x = (stage.width - _background.width) >> 1;
			this.y = (stage.height - _background.height) >> 1;

			updatePositions();
		}

		public function addGameData(success : Boolean, playerArray : Array, truthArray : Array) : void {
			var headerText : TextField = new TextField(),
			headerFontFormat : TextFormat = new TextFormat(_headerFont.fontName);

			headerFontFormat.align = TextFormatAlign.CENTER;
			headerFontFormat.size = 30;

			if (success) {
				headerFontFormat.color = 0x266802;
				headerText.defaultTextFormat = headerFontFormat;
				headerText.text = "success";
			} else {
				headerFontFormat.color = 0x842828;
				headerText.defaultTextFormat = headerFontFormat;
				headerText.text = "fail";
			}

			headerText.name = TITLE;
			headerText.width = width;
			headerText.y = height >> 3;

			addChild(headerText);

			addPlayers(playerArray);
		}

		private function addPlayers(playerArray : Array) : void {
			var i : int = 0;

			for each (var player : Character in playerArray) {
				var bitmapData : BitmapData = new BitmapData(55, 55, true, 0xFF0000);
				var tempBitmapData : BitmapData = new BitmapData(player.sheet.width, player.sheet.height, true, 0xFF0000);

				tempBitmapData.draw(player.sheet);
				bitmapData.copyPixels(tempBitmapData, new Rectangle(1 * SPRITE_WIDTH, 2 * SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT), new Point(0, 0));

				var bitmap : Bitmap = new Bitmap(bitmapData);
				bitmap.x = (i * (bitmapData.width + 10));
				trace('>>>>>' + bitmap.width, bitmap.height);

				if (ParanoiaCrossing.tableOfTruth[player.charname]) {
					bitmap.transform.colorTransform = new ColorTransform(0x00ff00 >> 16 & 0x0000FF / 255, 0x00ff00 >> 8 & 0x0000FF / 255, 0x00ff00 & 0x0000FF / 255);
				} else {
					bitmap.transform.colorTransform = new ColorTransform(0xff0000 >> 16 & 0x0000FF / 255, 0xff0000 >> 8 & 0x0000FF / 255, 0xff0000 & 0x0000FF / 255);
				}
				_container.addChild(bitmap);

				++i;
			}

			_container.scaleX = _container.scaleY = 1.5;
			addChild(_container);

			_container.x = (_background.width - _container.width) >> 1;
			_container.y = _background.height >> 2;
			_container.name = CONTAINER;
		}

		public function updatePositions() : void {
			for (var i : int = 0; i < numChildren; ++i) {
				var object : DisplayObject = getChildAt(i);

				switch(object.name) {
					case TITLE:
						object.width = width;
						object.y = height >> 3;
						break;
					case CONTAINER:
						object.x = (_background.width - _container.width) >> 1;
						object.y = height >> 2;
						break;
				}
			}
		}
	}
}
