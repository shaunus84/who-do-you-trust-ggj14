package com.ggj14.paranoiacrossing.collision {
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author shaunmitchell
	 */
	public class CollisionMap extends Sprite {
		private var _centerFountain : CollisionLayer = new CollisionLayer();
		private var collisions : Array = new Array();

		public function CollisionMap() : void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}

		private function onAddedToStage(event : Event) : void 
		{
			addChild(_centerFountain);

			for (var i : int = 1; i < 18; i++) 
			{
				collisions.push(_centerFountain.getChildByName("col" + i));
				trace(_centerFountain.getChildByName("col" + i))
			}
		}

		public function get collisionMap() : Array {
			return collisions;
		}
	}
}
