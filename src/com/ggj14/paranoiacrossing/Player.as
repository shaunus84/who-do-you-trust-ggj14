package com.ggj14.amorphousblob 
{
	import flash.geom.Point;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;

	/**
	 * @author michael.bunby
	 */
	public class Player extends Sprite 
	{
		private static const MAX_SPEED : Number = 5;
		private var _velocity:Point = new Point();
		private var _acceleration : Number = 0.8;
		private var _friction : Number = 0.85;
		
		public function Player() 
		{
			this.addGraphics();
			
			this.addEventListener(Event.ADDED_TO_STAGE, configure);
			this.addEventListener(Event.REMOVED_FROM_STAGE, clear);
		}

		private function addGraphics() : void 
		{
			with(this.graphics)
			{
				lineStyle(1.0, 0x000000);
				beginFill(0xFF0000);
				drawCircle(0, 0, 10);
				endFill();
				moveTo(0, 0);
				lineTo(-10, 0);
			}
		}
		
		private function configure(event : Event) : void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkDirectionOfMovement);
			this.addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function clear(event : Event) : void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkDirectionOfMovement);
			this.removeEventListener(Event.ENTER_FRAME, move);
		}

		private function checkDirectionOfMovement(event : KeyboardEvent) : void 
		{
			trace("KEY DOWN")
			switch(event.keyCode)
			{
				case Keyboard.UP:
					(_velocity.y > -MAX_SPEED) ? _velocity.y -= _acceleration : _velocity.y = -MAX_SPEED;
					break;
				case Keyboard.DOWN:
					(_velocity.y < MAX_SPEED) ? _velocity.y += _acceleration : _velocity.y = MAX_SPEED;
					break;
				case Keyboard.LEFT:
					(_velocity.x > -MAX_SPEED) ? _velocity.x -= _acceleration : _velocity.x = -MAX_SPEED;
					break;
				case Keyboard.RIGHT:
					(_velocity.x < MAX_SPEED) ? _velocity.x += _acceleration : _velocity.x = MAX_SPEED;
					break;
				default:
			}
		}
		
		private function move(event : Event) : void 
		{
			(_velocity.x > 0.01 || _velocity.x < -0.01) ? _velocity.x *= _friction : _velocity.x = 0;
			(_velocity.y > 0.01 || _velocity.y < -0.01) ? _velocity.y *= _friction : _velocity.y = 0;
			
			var nX:Number = this.x + _velocity.x;
			var nY:Number = this.y + _velocity.y;
			var angle:Number = (Math.atan2(this.y - nY, this.x - nX) * (180 / Math.PI));
			
			this.rotation = angle;
			this.x += _velocity.x;
			this.y += _velocity.y;
		}
	}
}
