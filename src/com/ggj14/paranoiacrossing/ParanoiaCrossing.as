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
			
<<<<<<< HEAD
			var chat:ConversationManager = new ConversationManager();
			this.addChild(chat);
			chat.startConversation();
=======

			var player:Player = new Player(null);
			addChild(player);

			//var mainMenu : MainMenu = new MainMenu();
			//addChild(mainMenu);
			
			//mainMenu.init();
>>>>>>> 959257de5540563ec5ac63ae7fa61182bd271bd0
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
