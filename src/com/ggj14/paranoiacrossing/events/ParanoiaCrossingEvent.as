package com.ggj14.paranoiacrossing.events {
	import flash.events.Event;

	/**
	 * @author shaunmitchell
	 */
	public class ParanoiaCrossingEvent extends Event 
	{
		public static const START_GAME:String = "START_GAME";
		public static const RESTART_GAME:String = "RESTART_GAME";
		public static const CONVERSATION_COMPLETE:String = "CONVERSATION_COMPLETE";
		public function ParanoiaCrossingEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
