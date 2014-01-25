package com.ggj14.paranoiacrossing.collision {
	import flash.display.Sprite;
	/**
	 * @author shaunmitchell
	 */
	public class CollisionMap extends Sprite {
		private var _centerFountain:CollisionClip = new CollisionClip();
		private var collisions:Array = new Array();
		
		public function CollisionMap():void
		{
			addChild(_centerFountain);
			
			collisions.push(_centerFountain.centerFountain);
			collisions.push(_centerFountain.leftSide);
		}

		public function get collisionMap() : Array {
			return collisions;
		}
		
	}
}
