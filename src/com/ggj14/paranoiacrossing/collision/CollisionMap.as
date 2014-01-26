package com.ggj14.paranoiacrossing.collision {
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author shaunmitchell
	 */
	public class CollisionMap extends Sprite {
		private var _centerFountain : CollisionLayer = new CollisionLayer();
		private var collisions : Array = new Array();
		private var doors : Array = new Array();
		private var _spawns : Array = new Array();
		private var noticeCollisions : Array = new Array();

		public function CollisionMap() : void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}

		private function onAddedToStage(event : Event) : void 
		{
			addChild(_centerFountain);

			for (var i : int = 1; i <= 24; i++) 
			{
				collisions.push(_centerFountain.getChildByName("col" + i));
			}
			
			for(var j:int = 1; j <= 6; j++)
			{
				doors.push(_centerFountain.getChildByName("door"+j));
			}
			
			for(var k:int = 1; k <= 15; k++)
			{
				spawns.push(_centerFountain.getChildByName("spawn"+k));
			}
			
			for(var l:int = 1; l <= 1; l++) 
			{
				noticeCollisions.push(_centerFountain.getChildByName("board"+l));
			}
			
			

		}

		public function get collisionMap() : Array {
			return collisions;
		}
		
		public function get doorsMap() : Array {
			return doors;
		}

		public function get spawns() : Array {
			return _spawns;
		}
		
		public function get boardsMap() : Array {
			return noticeCollisions;
		}
	}
}
