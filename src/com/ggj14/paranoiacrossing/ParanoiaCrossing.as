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
	public class ParanoiaCrossing extends Sprite 
	{
		public static const assetsLocation:String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
		
		private var townBackground:Bitmap;
		private var townBackgroundLoader:Loader = new Loader();

		public static var collisionMap : CollisionMap = new CollisionMap();
		
		private var spawns:Array = new Array();
		
		public static var npcs:Array = new Array();

		public function ParanoiaCrossing() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;

			SoundManager.initSounds();
			
			spawns.push(new Point(250,420));
			spawns.push(new Point(515,520));
			spawns.push(new Point(790,235));

			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));
		}

		private function onStartGame(event : ParanoiaCrossingEvent) : void {
			var player : Player = new Player(null);
			player.x = 600;
			player.y = 600;
			addChild(player);


			createNPCS();

			
			//createNPCS();
			
			//var mainMenu : MainMenu = new MainMenu();
			//addChild(mainMenu);
			
			//mainMenu.init();
		}

		private function createNPCS() : void 
		{
			var npc : AnimatedCharacter = new AnimatedCharacter(null, "7t.png");
			npc.x = spawns[0].x;
			npc.y = spawns[0].y;

			addChild(npc);
			
			npcs.push(npc);
			
			var npc1 : AnimatedCharacter = new AnimatedCharacter(null, "9t.png");
			npc1.x = spawns[1].x;
			npc1.y = spawns[1].y;

			addChild(npc1);
			npcs.push(npc1);
			
			var npc2 : AnimatedCharacter = new AnimatedCharacter(null, "10t.png");
			npc2.x = spawns[2].x;
			npc2.y = spawns[2].y;

			addChild(npc2);
			npcs.push(npc2);
		}

		private function onBackgroundLoaded(event : Event) : void {
			addChild(collisionMap);
			townBackground = Bitmap(townBackgroundLoader.content);
			addChild(townBackground);

			var mainMenu : MainMenu = new MainMenu();
			addChild(mainMenu);

			mainMenu.init();

			mainMenu.addEventListener(ParanoiaCrossingEvent.START_GAME, onStartGame);
		}
	}
}
