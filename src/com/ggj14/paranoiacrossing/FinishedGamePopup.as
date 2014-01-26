package com.ggj14.paranoiacrossing {
	import com.shaunus84.assets.ggj14.winnerpopup.WinnerBackground;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * @author jamie
	 */
	public class FinishedGamePopup extends Sprite {
		private var _background : WinnerBackground;
		private var _headerFont : Font043B0Regular = new Font043B0Regular();
		
		private static const TITLE : String = "TITLE";
		
		public function FinishedGamePopup() : void {
			initWinnersPopup();
		}
		
		private function initWinnersPopup() : void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_background = new WinnerBackground();
			addChild(_background);
		}

		private function onAddedToStage(event : Event) : void {
			this.x = (stage.width - _background.width) >> 1;
			this.y = (stage.height - _background.height) >> 1;
			
			updatePositions();
		}
		
		public function addGameData(success : Boolean, playerArray : Array) : void {
			var headerText : TextField = new TextField(),
				headerFontFormat : TextFormat = new TextFormat(_headerFont.fontName);
			
			headerFontFormat.align = TextFormatAlign.CENTER;
			headerFontFormat.size = 30;
			
			if(success) {
				headerFontFormat.color = 0x266802;
				headerText.defaultTextFormat = headerFontFormat;
				headerText.text = "success";
			} else {
				headerFontFormat.color = 0x842828;
				headerText.defaultTextFormat = headerFontFormat;
				headerText.text = "fail";
			}
			
			headerText.name = TITLE;
			addChild(headerText);
		}
		
		public function updatePositions() : void {
			for(var i:int = 0; i<numChildren; ++i) {
				var object : DisplayObject = getChildAt(i);
				
				switch(object.name) {
					case TITLE:
						object.width = width;
						object.y = height >> 3;
						break;
				}
			}
		}
	}
}
