package com.ggj14.paranoiacrossing {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;

	[SWF(width="1440", height="960", frameRate="60", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite 
	{
		public static const assetsLocation:String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
		
		private var townBackground:Bitmap;
		private var townBackgroundLoader:Loader = new Loader();
		
		public function ParanoiaCrossing() 
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			
			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));
			

			var player:Player = new Player(null);
			addChild(player);

			//var mainMenu : MainMenu = new MainMenu();
			//addChild(mainMenu);
			
			//mainMenu.init();
		}

		private function onBackgroundLoaded(event : Event) : void 
		{
			townBackground = Bitmap(townBackgroundLoader.content);
			addChild(townBackground);
			var player:Player = new Player(null);
			addChild(player);
		}
	}
}
