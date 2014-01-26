package com.ggj14.paranoiacrossing.collision {
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author shaunmitchell
	 */
	public class CollisionMap extends Sprite {
		private var _centerFountain : CollisionLayer = new CollisionLayer();
		private var collisions : Array = new Array();
		private var doors:Array = new Array();

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
			
			for(var j:int = 1; i <= 6; j++)
			{
				doors.push(_centerFountain.getChildByName("door"+6));
			}
		}

		public function get collisionMap() : Array {
			return collisions;
		}
		
		public function get doorsMap() : Array {
			return doors;
		}
	}
}
