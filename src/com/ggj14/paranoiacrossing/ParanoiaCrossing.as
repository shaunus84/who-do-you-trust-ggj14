package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.mainmenu.MainMenu;
	import com.ggj14.paranoiacrossing.tiledloader.TMXMap;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(width="1280", height="960", frameRate="60", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite 
	{
		public static const assetsLocation:String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
		
		public function ParanoiaCrossing() 
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			var map:TMXMap = new TMXMap("paranoia.tmx");
			addChild(map);
			
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
	}
}
