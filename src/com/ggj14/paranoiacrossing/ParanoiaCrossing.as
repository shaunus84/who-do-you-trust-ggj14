package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import com.ggj14.paranoiacrossing.collision.CollisionMap;
	import com.ggj14.paranoiacrossing.mainmenu.MainMenu;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;

	[SWF(width="1440", height="960", frameRate="30", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite {
		public static const assetsLocation : String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
		private var townBackground : Bitmap;
		private var townBackgroundLoader : Loader = new Loader();
		public static var collisionMap : CollisionMap = new CollisionMap();

		public function ParanoiaCrossing() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;

			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));
		}

		private function onStartGame(event : ParanoiaCrossingEvent) : void 
		{
			var player : Player = new Player(null);
			player.x = 600;
			player.y = 600;
			addChild(player);
			
			createNPCS();
		}

		private function createNPCS() : void 
		{
			for(var i:int = 1; i <= 6; i++)
			{
				var npc:AnimatedCharacter = new AnimatedCharacter(null, assetsLocation + "sprites/" + Math.random() * 20 + "t.png");
			}
		}

		private function onBackgroundLoaded(event : Event) : void {
			addChild(collisionMap);
			townBackground = Bitmap(townBackgroundLoader.content);
			addChild(townBackground);
			
			var mainMenu : MainMenu = new MainMenu();
			addChild(mainMenu);
			
			mainMenu.init();
			
			mainMenu.addEventListener(ParanoiaCrossingEvent.START_GAME, onStartGame);

//			var chat : ConversationManager = new ConversationManager();
//			this.addChild(chat);
//			chat.x = (this.stage.stageWidth - chat.width) * 0.5;
//			chat.y = this.stage.stageHeight - chat.height - 10;
//			chat.startConversation();
		}
	}
}
