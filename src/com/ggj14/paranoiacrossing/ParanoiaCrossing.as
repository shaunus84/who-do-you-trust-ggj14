package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.collision.CollisionMap;
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import com.ggj14.paranoiacrossing.mainmenu.MainMenu;
	import com.ggj14.paranoiacrossing.util.RandomPlus;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;

	[SWF(width="1440", height="960", frameRate="30", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite {
		public static const assetsLocation : String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
		private var townBackground : Bitmap;
		private var townBackgroundLoader : Loader = new Loader();
		
		public static var collisionMap : CollisionMap = new CollisionMap();
		private var spawns:Array = new Array();
		private var spawnPoints:NPCPoints = new NPCPoints();

		public function ParanoiaCrossing() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			
			SoundManager.initSounds();
			
//			for(var i:int = 1; i <= 20; i++)
//			{
//				spawns.push(spawnPoints.getChildByName("npc" + i));
//			}
			
			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));
		}

		private function onStartGame(event : ParanoiaCrossingEvent) : void 
		{
			var player : Player = new Player(null);
			player.x = 600;
			player.y = 600;
			addChild(player);
			
			//createNPCS();
		}

		private function createNPCS() : void 
		{
			var rand:RandomPlus = new RandomPlus(0, 20);
			for(var i:int = 1; i <= 6; i++)
			{
				var npc:AnimatedCharacter = new AnimatedCharacter(null, assetsLocation + "sprites/" + rand.getNum() + "t.png");
				
				var spawnRand:RandomPlus = new RandomPlus(0, 19);
				var spawnPoint:NPCSpawnPoint = spawns[spawnRand.getNum()];
				var point:Point = new Point(spawnPoint.x, spawnPoint.y);
				
				npc.x = point.x;
				npc.y = point.y;
				
				addChild(npc);
				
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
