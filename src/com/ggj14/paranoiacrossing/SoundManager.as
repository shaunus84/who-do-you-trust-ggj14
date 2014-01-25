package com.ggj14.paranoiacrossing {
	import flash.media.SoundChannel;
	import flash.media.Sound;
	/**
	 * @author jamie
	 */
	public class SoundManager {
		private static var _typewriterChannel : SoundChannel;
		
		private static var _typewriterSound : Sound;
		
		public static function initSounds() : void {
			_typewriterSound = new TypewriterSound();
		}
		
		public static function playTypewriter(loop : Boolean = false) : void {
			_typewriterChannel = _typewriterSound.play(0, (loop ? 0x7fffffff : 0));
		}
		
		public static function stopTypewriter() : void {
			_typewriterChannel.stop();
		}
	}
}
