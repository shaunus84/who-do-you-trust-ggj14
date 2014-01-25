package com.ggj14.paranoiacrossing.collision {
	import flash.display.Sprite;
	/**
	 * @author shaunmitchell
	 */
	public class CollisionMap extends Sprite {
		private var _centerFountain:CenterFountain = new CenterFountain();
		
		public function CollisionMap():void
		{
			addChild(_centerFountain);
		}

		public function get collisionMap() : CenterFountain {
			return _centerFountain;
		}
		
	}
}
