package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author michael.bunby
	 */
	public class Player extends AnimatedCharacter {
		private var _chatting : Boolean = false;

		public function Player(xml : XML) {
			_spriteFile = "player.png";
			super(xml, _spriteFile);
			this.addEventListener(Event.ADDED_TO_STAGE, configure);
		}

		private function configure(event : Event) : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Move);
			stage.addEventListener(KeyboardEvent.KEY_UP, Stop);
		}

		private function Stop(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case Keyboard.UP:
					_velocity.y = 0;
					break;
				case Keyboard.DOWN:
					_velocity.y = 0;
					break;
				case Keyboard.LEFT:
					_velocity.x = 0;
					break;
				case Keyboard.RIGHT:
					_velocity.x = 0;
					break;
				default:
			}
		}

		private function Move(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case Keyboard.UP:
					if (!_chatting) {
						_velocity.y = -MAX_SPEED;
					}
					break;
				case Keyboard.DOWN:
					if (!_chatting) {
						_velocity.y = MAX_SPEED;
					}
					break;
				case Keyboard.LEFT:
					if (!_chatting) {
						_velocity.x = -MAX_SPEED;
					}
					break;
				case Keyboard.RIGHT:
					if (!_chatting) {
						_velocity.x = MAX_SPEED;
					}
					break;
				case Keyboard.SPACE:
					if (!_chatting) {
						_chatting = true;
						for (var k : int = 0; k < ParanoiaCrossing.npcs.length; k++) {
							if (this.hitTestObject(ParanoiaCrossing.npcs[k])) {
								var chat : ConversationManager = new ConversationManager();
								this.stage.addChild(chat);
								chat.x = (this.stage.stageWidth - chat.width) * 0.5;
								chat.y = this.stage.stageHeight - chat.height - 10;
								chat.startConversation();

								chat.addEventListener(ParanoiaCrossingEvent.CONVERSATION_COMPLETE, function() : void {
									stage.removeChild(chat);
									chat = null;
									_chatting = false;
								});
							}
						}
					}
					break;
				default:
			}
		}
	}
}
