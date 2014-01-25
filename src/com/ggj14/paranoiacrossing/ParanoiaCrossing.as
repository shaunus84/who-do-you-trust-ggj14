package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.mainmenu.MainMenu;
	import com.ggj14.paranoiacrossing.tiledloader.TMXMap;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(width="1280", height="960", frameRate="60", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite 
	{
		public static const assetsLocation:String = "/Users/jamie/Documents/workspace/actionscript/who-do-you-trust-ggj14/assets/";
		
		public function ParanoiaCrossing() 
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			var map:TMXMap = new TMXMap("town.tmx");
			addChild(map);
			

			var player:Player = new Player(null);
			addChild(player);

			var mainMenu : MainMenu = new MainMenu();
			addChild(mainMenu);
			
			mainMenu.init();
		}
	}
}
