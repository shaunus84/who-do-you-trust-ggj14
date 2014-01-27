package com.ggj14.paranoiacrossing
{
	import com.ggj14.paranoiacrossing.collision.CollisionMap;
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import com.ggj14.paranoiacrossing.mainmenu.MainMenu;
	import com.ggj14.paranoiacrossing.util.RandomPlus;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.System;

	[SWF(width="1440", height="960", frameRate="30", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite
	{
		private const characterNames:Array = ["Adam", "Ashley", "Billy", "Brian", "Dave", "Dennis", "Diana", "Shmebulock", "Susan", "Tom", "Jennifer"];
		// , "Diana", "Geoff", "Jennifer", "Jessica", "Katie", "Kerry", "Mort", "Pat", "Rich", "Scooter", "Shmebulock", "Susan", "Tifa", "Tom"];
		// the assets location
		public static const assetsLocation:String = "http://www.culpritgames.co.uk/paranoia-crossing/assets/";
		//public static const assetsLocation:String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
		// map of the town
		private var townBackground:Bitmap;
		private var townBackgroundLoader:Loader = new Loader();
		// the map for collision
		public static var collisionMap:CollisionMap = new CollisionMap();
		// the characters
		public static var npcs:Array = new Array();
		private static const numNPCS:uint = 6;
		private var numNPCSLoaded:uint = 0;
		private const playerStartX:uint = 600;
		private const playerStartY:uint = 600;
		private var _player:Player;
		public static var _winningHouse:uint;
		public static var sceneCharacters:Vector.<String> = new Vector.<String>();
		private var _popup:PopUp = new PopUp();
		private var _finishedGamePopup:FinishedGamePopup = new FinishedGamePopup();
		public static var tableOfTruth:Array = new Array();
		// private var _tipBoard : Sprite = new Sprite();
		private var _tipBoard:TipBoardNewspaper = new TipBoardNewspaper();

		public function ParanoiaCrossing()
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;

			var context:LoaderContext = new LoaderContext();
			context.securityDomain = SecurityDomain.currentDomain;

			SoundMixer.soundTransform = new SoundTransform(0.7);
			SoundManager.initSounds();

			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));

			_tipBoard.visible = false;
			_tipBoard.scaleX = 0;
			_tipBoard.scaleY = 0;
			_tipBoard.x = 550;
			_tipBoard.y = 300;
			addChild(_tipBoard);
		}

		private function onBackgroundLoaded(event:Event):void
		{
			// add the collision map
			addChild(collisionMap);

			// load the town background
			townBackground = Bitmap(townBackgroundLoader.content);
			addChild(townBackground);

			// load the main menu for the first time
			var mainMenu:MainMenu = new MainMenu();
			addChild(mainMenu);

			// initialise the main menu
			mainMenu.init();
			// listen for the press to play the game
			mainMenu.addEventListener(ParanoiaCrossingEvent.START_GAME, onStartGame);
		}

		private function onStartGame(event:ParanoiaCrossingEvent):void
		{
			assignWinningHouse();
			// create the NPC's
			createNPCS();

			_popup.visible = false;
			stage.addChild(_popup);

			_popup.yesButton.addEventListener(MouseEvent.CLICK, onHouseChosen);
		}

		private function onHouseChosen(event:MouseEvent):void
		{
			_popup.visible = false;
			_player.removeEventListener(ParanoiaCrossingEvent.SHOW_POP_UP, onShowPopup);
			_player.removeEventListener(ParanoiaCrossingEvent.HIDE_POP_UP, onHidePopup);
			_popup.yesButton.removeEventListener(MouseEvent.CLICK, onHouseChosen);
			if (_player.currentHouse == _winningHouse)
			{
				addFinishedGamePopup(true);
			}
			else
			{
				addFinishedGamePopup(false);
			}

			_popup.visible = false;
		}

		private function populateTipBoard():void
		{
			var numFalse:int;
			var numTruth:int;
			for each (var character:Boolean in tableOfTruth)
			{
				if (character) numTruth++;
				else numFalse++;
			}

			_tipBoard.newspaperContent.text = "This just in, " + numFalse + " in 6 people in paranoia crossing could be lying to you.\n\nThis report was confirmed in a test conducted by Professor Shmebulock";
		}

		private function onShowTipBoard(event:ParanoiaCrossingEvent):void
		{
			if (!_tipBoard.filters.length > 0)
			{
				var filter:GlowFilter = new GlowFilter();
				filter.alpha = 0.75;
				filter.blurX = 15;
				filter.blurY = 15;
				filter.color = 0x333333;

				_tipBoard.filters = [filter];
			}
			
			_tipBoard.visible = true;
			TweenLite.to(_tipBoard, 0.5, {x:650, y:350, scaleX:0.55, scaleY:0.55});

			// position the tipboard
			//_tipBoard.x = 200;
			//_tipBoard.y = 300;

			//_tipBoard.visible = true;
			setChildIndex(_tipBoard, numChildren - 1);
		}

		private function onHidePopup(event:ParanoiaCrossingEvent):void
		{
			_popup.visible = false;

			if (_tipBoard.visible)
			{
				TweenLite.to(_tipBoard, 0.5, {x:550, y:300, scaleX:0, scaleY:0, onComplete:function():void{_tipBoard.visible = false;}});
			}
		}

		private function onShowPopup(event:ParanoiaCrossingEvent):void
		{
			_popup.visible = true;
		}

		private function createNPCS():void
		{
			var rand:RandomPlus = new RandomPlus(0, characterNames.length - 1);
			var randSpawn:RandomPlus = new RandomPlus(0, collisionMap.spawns.length - 1);
			for (var i:int = 0; i < numNPCS; i++)
			{
				npcs.push(new Character(characterNames[rand.getNum()]));

				trace(Character(npcs[i]).charname);
				sceneCharacters.push(Character(npcs[i]).charname);
				addChild(npcs[i]);

				var spawn:SpawnPoint = collisionMap.spawns[randSpawn.getNum()];
				trace(spawn);
				var pos:Point = new Point(spawn.x, spawn.y);

				Character(npcs[i]).x = pos.x;
				Character(npcs[i]).y = pos.y;

				Character(npcs[i]).addEventListener(ParanoiaCrossingEvent.CHARACTER_LOADED, onCharacterLoaded);
			}
		}

		private function onCharacterLoaded(event:ParanoiaCrossingEvent):void
		{
			event.stopImmediatePropagation();
			Character(event.target).removeEventListener(ParanoiaCrossingEvent.CHARACTER_LOADED, onCharacterLoaded);

			numNPCSLoaded++;

			if (numNPCSLoaded == numNPCS)
			{
				for (var i:int = 0; i < numNPCS; i++)
				{
					Character(npcs[i]).buildConversation();
				}
				// when the game starts create the player
				_player = new Player(null);
				_player.x = playerStartX;
				_player.y = playerStartY;
				addChild(_player);

				_player.addEventListener(ParanoiaCrossingEvent.SHOW_POP_UP, onShowPopup);
				_player.addEventListener(ParanoiaCrossingEvent.HIDE_POP_UP, onHidePopup);
				_player.addEventListener(ParanoiaCrossingEvent.SHOW_TIP_BOARD, onShowTipBoard);

				if (contains(_finishedGamePopup) && _finishedGamePopup.visible)
				{
					setChildIndex(_finishedGamePopup, numChildren - 1);
				}

				numNPCSLoaded = 0;
				populateTipBoard();
			}
		}

		private function assignWinningHouse():void
		{
			var r:RandomPlus = new RandomPlus(0, 5);
			_winningHouse = r.getNum();
		}

		private function restartGame(event:ParanoiaCrossingEvent):void
		{
			System.exit(0);
			// for each (var char : Character in npcs) {
			// removeChild(char);
			// }
			//
			// removeChild(_finishedGamePopup);
			//
			// removeChild(_player);
			//
			// sceneCharacters = null;
			// sceneCharacters = new Vector.<String>();
			//
			// tableOfTruth = null;
			// tableOfTruth = new Array();
			//
			//			//  load the main menu for the first time
			// var mainMenu : MainMenu = new MainMenu();
			// addChild(mainMenu);
			//
			//			//  initialise the main menu
			// mainMenu.init();
			//			//  listen for the press to play the game
			// mainMenu.addEventListener(ParanoiaCrossingEvent.START_GAME, onStartGame);
		}

		private function addFinishedGamePopup(success:Boolean):void
		{
			_finishedGamePopup.addGameData(success, npcs, []);
			addChildAt(_finishedGamePopup, numChildren - 1);
			_finishedGamePopup.addEventListener(ParanoiaCrossingEvent.RESTART_GAME, restartGame);
		}
	}
}
