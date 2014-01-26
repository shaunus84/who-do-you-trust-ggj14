package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author michael.bunby
	 */
	public class ConversationManager extends Sprite {
		[Embed(source="../../../../assets/chat/chat.xml", mimeType="application/octet-stream")]
		private var _data : Class;
		private var _xmlConversations : XML;
		static public const STYLE_FRIENDLY : String = "friendly";
		static public const STYLE_NEUTRAL : String = "neutral";
		static public const STYLE_RUDE : String = "rude";
		private var _currentConversation : Vector.<String>;
		private var _speechBubble : TextField;
		private var _nameBubble : TextField;
		private var _currentSpeechStep : uint = 0;
		private var _sentenceIndex : uint = 0;

		public function ConversationManager() {
			_xmlConversations = new XML(new _data);

			this.addEventListener(Event.ADDED_TO_STAGE, configure);
			this.addEventListener(Event.REMOVED_FROM_STAGE, clean);
		}

		private function configure(event : Event) : void {
			with(this.graphics) {
				lineStyle(2.0, 0xBBBBBB);
				beginFill(0xFFFFFF, 0.8);
				drawRoundRect(0, 0, this.stage.stageWidth - 20, 150, 5);
				endFill();
			}

			_nameBubble = new TextField();
			_nameBubble.setTextFormat(new TextFormat("Arial", 30));
			_nameBubble.defaultTextFormat = new TextFormat("Arial", 30);
			_nameBubble.multiline = true;
			_nameBubble.wordWrap = true;
			_nameBubble.selectable = false;
			_nameBubble.width = this.width - 10;
			_nameBubble.height = this.height / 2.6;

			_speechBubble = new TextField();
			_speechBubble.setTextFormat(new TextFormat("Arial", 30));
			_speechBubble.defaultTextFormat = new TextFormat("Arial", 30);
			_speechBubble.multiline = true;
			_speechBubble.wordWrap = true;
			_speechBubble.selectable = false;
			_speechBubble.width = this.width - 10;
			_speechBubble.height = this.height - 10;
			_speechBubble.x = (this.width - _speechBubble.width) * 0.5;
			_speechBubble.y = _nameBubble.height + ((this.height - _nameBubble.height) - _speechBubble.height) * 0.5;
			this.addChild(_speechBubble);
			this.addChild(_nameBubble);
		}

		private function clean(event : Event) : void {
			this.graphics.clear();

			this.removeChild(_speechBubble);
		}

		public function startConversation(style : String = null) : void {
			_currentSpeechStep = 0;

			_currentConversation = new Vector.<String>();

			getGreeting(style);
			getConversation(style);
			displayConversation()
			trace(_currentConversation);

			SoundManager.playTypewriter();
		}

		private function getGreeting(style : String) : void {
			var totalGreetings : int = _xmlConversations.welcome.greeting.length();

			if (style == null) {
				_currentConversation.push(_xmlConversations.welcome.greeting
				[
				Math.floor(Math.random() * totalGreetings)
				]);
			} else {
				_currentConversation.push(_xmlConversations.welcome.greeting.(@style == style)
				[
				Math.floor(Math.random() * _xmlConversations.welcome.length())
				]);
			}
		}

		private function getConversation(style : String) : void {
			var conversation : XML;

			var totalConversations : int = _xmlConversations.conversation.length();

			if (style == null) {
				conversation = _xmlConversations.conversation
				[
				Math.floor(Math.random() * totalConversations)
				];
			} else {
				conversation = _xmlConversations.conversation.(@style == style)
				[
				Math.floor(Math.random() * totalConversations)
				]
			}

			for each (var list : XML in conversation.step) {
				_currentConversation.push(list);
			}
		}

		private function displayConversation() : void {
			this.addEventListener(Event.ENTER_FRAME, animateSentence);
		}

		private function animateSentence(event : Event) : void {
			if (_sentenceIndex <= _currentConversation[_currentSpeechStep].length) {
				_speechBubble.text = _currentConversation[_currentSpeechStep].slice(0, _sentenceIndex++);
			} else {
				this.removeEventListener(Event.ENTER_FRAME, animateSentence);

				this.addEventListener(MouseEvent.CLICK, progressConversation);

				SoundManager.stopTypewriter();
			}
		}

		private function progressConversation(event : MouseEvent) : void {
			_speechBubble.text = "";

			++_currentSpeechStep;

			_sentenceIndex = 0;

			this.removeEventListener(MouseEvent.CLICK, progressConversation);

			if (_currentSpeechStep != _currentConversation.length) {
				this.addEventListener(Event.ENTER_FRAME, animateSentence);
				SoundManager.playTypewriter();
			} else {
				dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.CONVERSATION_COMPLETE));
			}
		}
	}
}
