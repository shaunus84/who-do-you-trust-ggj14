package com.ggj14.paranoiacrossing.events {
	import flash.events.Event;

	/**
	 * @author shaunmitchell
	 */
	public class ParanoiaCrossingEvent extends Event {
		public static const START_GAME : String = "START_GAME";
		public static const RESTART_GAME : String = "RESTART_GAME";
		public static const CONVERSATION_COMPLETE : String = "CONVERSATION_COMPLETE";
		public static const INSTRUCTIONS_BACK_CLICK : String = "INSTRUCTIONS_BACK_CLICK";
		public static const CHARACTER_LOADED : String = "CHARACTER_LOADED";
		public static const HOUSE_CHOSEN : String = "HOUSE_CHOSEN";
		public static const SHOW_POP_UP : String = "SHOW_POP_UP";
		public static const HIDE_POP_UP : String = "HIDE_POP_UP";
		public static const SHOW_TIP_BOARD : String = "SHOW_TIP_BOARD";

		public function ParanoiaCrossingEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
