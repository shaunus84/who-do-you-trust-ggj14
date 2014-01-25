package com.ggj14.paranoiacrossing 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author michael.bunby
	 */
	public class Player extends AnimatedCharacter {

		public function Player(xml:XML) 
		{
			_spriteFile = "player.png";
			super(xml, _spriteFile);
			this.addEventListener(Event.ADDED_TO_STAGE, configure);
		}


		private function configure(event : Event) : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Move);
			stage.addEventListener(KeyboardEvent.KEY_UP, Stop);
		}

		private function Stop(event : KeyboardEvent) : void 
		{
			switch(event.keyCode)
			{
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
			
			trace(this.x, this.y)
		}

		private function Move(event : KeyboardEvent) : void 
		{
			switch(event.keyCode) {
				case Keyboard.UP:
					_velocity.y = -MAX_SPEED;
					break;
				case Keyboard.DOWN:
					_velocity.y = MAX_SPEED;
					break;
				case Keyboard.LEFT:
					_velocity.x = -MAX_SPEED;
					break;
				case Keyboard.RIGHT:
					_velocity.x = MAX_SPEED;
					break;
				default:
			}
		}
	}
}
