package com.ggj14.paranoiacrossing.collision {
	import flash.display.Sprite;
	/**
	 * @author shaunmitchell
	 */
	public class CollisionMap extends Sprite
	{
		private var collisionMap:CollisionLayer = new CollisionLayer();
		
		public function CollisionMap():void
		{
			addChild(collisionMap);
		}
		
	}
}
