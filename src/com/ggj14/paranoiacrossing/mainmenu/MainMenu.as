package com.ggj14.paranoiacrossing.mainmenu {
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import com.ggj14.paranoiacrossing.ParanoiaCrossing;
	import com.greensock.TweenMax;
	import com.shaunus84.assets.ggj14.mainmenu.ScrollBackground;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class MainMenu extends Sprite {
		private var _scrollBackground : ScrollBackground = new ScrollBackground();
		private var _scrollBackgroundContainer : Sprite;
		private var _instructions : Sprite;
		private var _options : Vector.<String> = new <String>['play the game', 'instructions', 'exit'];
		private var _instructionsText : String;
		protected var _headingFont : Font043B0Regular = new Font043B0Regular();
		protected var _optionFont : FontMinecraftiaRegular = new FontMinecraftiaRegular();
		protected var _textFont : FontDoulosRegular = new FontDoulosRegular();

		public function MainMenu() {
			var urlRequest : URLRequest = new URLRequest(ParanoiaCrossing.assetsLocation + "sounds/Intro.mp3");
			var sound : Sound = new Sound(urlRequest);

			SoundMixer.soundTransform = new SoundTransform(0.6);
			sound.play(int.MAX_VALUE);
		}

		public function init() : void {
			addScrollBackground();
			addHeading();
			addOptions();
		}

		private function addScrollBackground() : void {
			_scrollBackgroundContainer = new Sprite;

			addChild(_scrollBackground);
			_scrollBackground.addChild(_scrollBackgroundContainer);

			_scrollBackground.x = (stage.stageWidth - _scrollBackground.width) >> 1;
			_scrollBackground.y = ((stage.stageHeight - _scrollBackground.height) >> 1) - 20;

			var filter : GlowFilter = new GlowFilter();
			filter.color = 0x0C0C0C;
			filter.alpha = 0.85;
			filter.blurX = 10;
			filter.blurY = 10;
			filter.quality = BitmapFilterQuality.MEDIUM;
			_scrollBackground.filters = [filter];
		}

		private function addHeading() : void {
			// add title
			var textFormat : TextFormat = new TextFormat(_headingFont.fontName);
			var headingField : TextField = new TextField();

			textFormat.size = 20;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.color = 0x424242;

			headingField.defaultTextFormat = textFormat;
			headingField.text = "PARANOIA CROSSING";
			headingField.x = 0;
			headingField.y = _scrollBackground.height >> 2;
			headingField.width = _scrollBackground.width;
			headingField.selectable = false;
			_scrollBackgroundContainer.addChild(headingField);
		}

		private function addOptions() : void {
			var textFormat : TextFormat = new TextFormat(_optionFont.fontName);
			var optionField : TextField;

			textFormat.size = 14;
			textFormat.color = 0x807066;
			textFormat.align = TextFormatAlign.CENTER;

			for (var i : int = 0; i < _options.length; ++i) {
				optionField = new TextField();
				optionField.width = _scrollBackgroundContainer.width;
				optionField.x = 0;
				optionField.y = (_scrollBackground.height >> 2) + (i * 40) + 60;
				optionField.selectable = false;
				optionField.defaultTextFormat = textFormat;

				optionField.text = _options[i].toUpperCase();
				_scrollBackgroundContainer.addChild(optionField);

				addEventListeners(optionField);
			}
		}

		private function addEventListeners(object : DisplayObject) : void {
			object.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			object.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function removeEventListeners(object : DisplayObject) : void {
			object.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			object.removeEventListener(MouseEvent.CLICK, onClick);
		}

		private function onMouseOver(event : MouseEvent) : void {
			if (!event.target is TextField) {
				return;
			}
		}

		private function onClick(event : MouseEvent) : void {
			var eventObject : TextField;

			if (!event.target is TextField) {
				return;
			}

			eventObject = event.target as TextField;
			switch(eventObject.text.toLowerCase()) {
				case _options[0]:
					playTheGame();
					break;
				case _options[1]:
					showInstructions();
					break;
				case _options[2]:
					quitProgram();
					break;
			}
		}

		private function playTheGame() : void {
			this.visible = false;
			dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.START_GAME));
		}

		private function showInstructions() : void {
			if (!_instructions) {
				_instructions = new Instructions(_scrollBackground.width, _scrollBackground.height);
			}
			
			_scrollBackground.addChild(_instructions);
			TweenMax.to(_scrollBackgroundContainer, 1, {alpha:0, onComplete:fadeInBox, onCompleteParams:[_instructions]});
			
			_instructions.addEventListener(ParanoiaCrossingEvent.INSTRUCTIONS_BACK_CLICK, onClickBack);
		}
		
		private function onClickBack(evt : ParanoiaCrossingEvent) : void {
			_instructions.alpha = 1;
			
			TweenMax.to(_instructions, 1, {alpha: 0, onComplete: removedInstructionsBox});
		}
		
		private function removedInstructionsBox() : void {
			_instructions.visible = false;
			_scrollBackground.removeChild(_instructions);
			
			fadeInBox(_scrollBackgroundContainer);
		}

		private function quitProgram() : void {
			System.exit(0);
		}

		private function fadeInBox(object : DisplayObject) : void {
			if (!object.visible) {
				object.visible = true;
			}

			TweenMax.to(object, 1, {alpha:1});
		}
	}
}
