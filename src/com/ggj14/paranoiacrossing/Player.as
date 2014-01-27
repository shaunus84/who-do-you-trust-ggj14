package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	/**
	 * @author michael.bunby
	 */
	public class Player extends AnimatedCharacter {
		private var _chatting : Boolean = false;
		private var _showingPopup : Boolean = false;
		private var _currentHouse : int = 0;

		public function Player(xml : XML) {
			_spriteFile = "player.png";
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, configure);
		}

		private function configure(event : Event) : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Move);
			stage.addEventListener(KeyboardEvent.KEY_UP, Stop);
		}

		protected override function update(event : Event) : void {
			super.update(event);

			var hitAnything : Boolean = false;
			for (var i : int = 0; i < ParanoiaCrossing.collisionMap.doorsMap.length; i++) {
				if (this.hitTestObject(ParanoiaCrossing.collisionMap.doorsMap[i])) {
					hitAnything = true;
					dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.SHOW_POP_UP));
					_showingPopup = true;
					_currentHouse = i;
				}
			}

			if (!hitAnything && ParanoiaCrossing.collisionMap.boardsMap.length > 0) {
				for (var j : int = 0; j < ParanoiaCrossing.collisionMap.boardsMap.length; ++j) {
					if (this.hitTestObject(ParanoiaCrossing.collisionMap.boardsMap[j])) {
						hitAnything = true;
						dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.SHOW_TIP_BOARD));
						_showingPopup = true;
					}
				}
			}

			if (!hitAnything) {
				dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.HIDE_POP_UP));
				_showingPopup = false;
			}
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
					event.stopImmediatePropagation();
					if (!_chatting) {
						for (var k : int = 0; k < ParanoiaCrossing.npcs.length; k++) {
							if (this.hitTestObject(ParanoiaCrossing.npcs[k])) {
								_chatting = true;
								var chat : ConversationManager = new ConversationManager();
								this.stage.addChild(chat);
								chat.x = (this.stage.stageWidth - chat.width) * 0.5;
								chat.y = this.stage.stageHeight - chat.height - 10;
								chat.startConversation(ParanoiaCrossing.npcs[k]);

								chat.addEventListener(ParanoiaCrossingEvent.CONVERSATION_COMPLETE, function() : void {
									stage.removeChild(chat);
									chat = null;
									_chatting = false;
								});
							}
						}
					} else {
						stage.dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.ADVANCE_CONVERSATION));
					}
					break;
				default:
			}
		}

		public function get currentHouse() : int {
			return _currentHouse;
		}
	}
}
